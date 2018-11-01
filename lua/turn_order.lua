local order = {
   next_side = nil,
   yield_to = nil,
   yield_from = nil,
}

local function order_lookup_table(initiative)
   local lookup = {forward = {}}
   for i, order in ipairs(initiative) do
      local next_side = i == #initiative and initiative[1][3] or initiative[i+1][3]
      lookup.forward[order[3]] = next_side
   end
   return lookup
end

function wml_actions.yield_turn(cfg)
   order.yield_to = cfg.side
   order.yield_from = wesnoth.current.side
   wesnoth.message("yield_from", order.yield_from)

   wesnoth.end_turn(order.yield_to)
end

function wml_actions.maybe_turn_order(cfg)
   if #tc_campaign.current_initiative == 0 then
      order.next_side = nil
      return
   end
   if order.yield_to == wesnoth.current.side then
      return
   end
   if order.yield_from == wesnoth.current.side then
      order.yield_from = nil
      order.yield_to = nil
      return
   end

   local lut = order_lookup_table(tc_campaign.current_initiative)

   if order.yield_from ~= nil then
      wesnoth.end_turn(order.yield_from)
   elseif order.next_side == nil then
      -- go to first in initiative order, if we haven't started initiative yet
      order.next_side = tc_campaign.current_initiative[1][3]
      wesnoth.end_turn(order.next_side)
   elseif order.next_side ~= wesnoth.current.side then
      -- we are on the wrong side; fix it
      wesnoth.end_turn(order.next_side)
   else
      -- this is the correct side; set the next side
      order.next_side = lut.forward[order.next_side]
   end
end

-- the default turn_order doesn't have side=; fix it
function wml_actions.end_turn(cfg)
   wesnoth.end_turn(cfg.side)
end
