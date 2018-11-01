local dialog = require("dialogs/side")
local utils = require("utils")


local function preshow()
   local sides = utils.side_list()

   for _, side in ipairs(sides) do
      local unit = utils.unit_for_side(side)

      if unit ~= nil then
         wesnoth.set_dialog_value(tostring(side), "side_list", side, "side_number")
         wesnoth.set_dialog_value(unit.name, "side_list", side, "side_name")
      end
   end
end

local function make_postshow(result)
   return function()
      local i = wesnoth.get_dialog_value("side_list")
      result.side_num = i
   end
end

function wml_actions.change_side(cfg)
   local unit = wesnoth.get_unit(cfg.x, cfg.y)

   local function show_change_side()
      local result = {}
      local input = wesnoth.show_dialog(dialog, preshow, make_postshow(result))
      return input > -2 and result or nil
   end

   local result = wesnoth.synchronize_choice("show_change_side", show_change_side)

   if result.side_num then
      unit.side = result.side_num
   end
end
