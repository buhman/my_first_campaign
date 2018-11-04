local state = {
   next_side = nil,
   yield_to = nil,
   -- XXX: with a reverse lut, we could remove this; eh
   yield_from = nil,
   current_initiative = {},
}

local function lookup_table(initiative)
   local lookup = {forward = {}}
   for i, order in ipairs(initiative) do
      local next_side = i == #initiative and initiative[1].side or initiative[i+1].side
      lookup.forward[order.side] = next_side
   end
   return lookup
end

function wml_actions.yield_turn(cfg)
   state.yield_to = cfg.side
   state.yield_from = wesnoth.current.side

   wesnoth.end_turn(state.yield_to)
end

function wml_actions.maybe_turn_order(cfg)
   if #state.current_initiative == 0 then
      state.next_side = nil
      return
   end
   if state.yield_to == wesnoth.current.side then
      return
   end
   if state.yield_from == wesnoth.current.side then
      state.yield_from = nil
      state.yield_to = nil
      return
   end

   local lut = lookup_table(state.current_initiative)

   if state.yield_from ~= nil then
      wesnoth.end_turn(state.yield_from)
   elseif state.next_side == nil then
      -- go to first in initiative order, if we haven't started initiative yet
      state.next_side = state.current_initiative[1].side
      wesnoth.end_turn(state.next_side)
   elseif state.next_side ~= wesnoth.current.side then
      -- we are on the wrong side; fix it
      wesnoth.end_turn(state.next_side)
   else
      -- this is the correct side; set the next side
      state.next_side = lut.forward[state.next_side]
   end
end

-- the default turn_order doesn't have side=; fix it
function wml_actions.end_turn(cfg)
   wesnoth.end_turn(cfg.side)
end

return {
   state = state,
   lookup_table = lookup_table,
}
