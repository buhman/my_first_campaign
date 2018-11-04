local turn_order = require "turn_order"
local utils = require "utils"

-- global

--[[
  {
    { roll_value = 1, side = 1 }
  }
]]--

-- shows initiative order when present
local old_unit_weapons = wesnoth.theme_items.unit_weapons


local function row_for_side(side, value)
   local unit = utils.unit_for_side(side)
   local name = unit and unit.name or "Side " .. side
   local row = T.element {
      text = string.format("<span color='#f5e6c1'>  %s</span>: %s\n", name, value)
   }
   return row
end

local function display_initiative(tbl, initiative)
   local title = T.element {
      text = "\n<span color='#a69275'><i>Initiative</i></span>\n",
   }
   table.insert(tbl, title)

   local lut = turn_order.lookup_table(turn_order.state.current_initiative)
   local side = wesnoth.current.side

   for i = 1,#initiative do
      -- lol
      it = filter(function (v) return v.side == side end, initiative)
      local row = row_for_side(side, it[1].roll_value)
      table.insert(tbl, row)
      side = lut.forward[side]
   end
end

function wesnoth.theme_items.unit_weapons()
   local u = wesnoth.get_displayed_unit()
   if not u then return {} end

   local tbl = old_unit_weapons()

   if #turn_order.state.current_initiative > 0 then
      display_initiative(tbl, turn_order.state.current_initiative)
   end

   return tbl
end
