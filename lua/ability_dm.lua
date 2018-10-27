local dialog = require("dialogs/scenario")
local definitions = require("ability/definitions")

local function preshow()
   local i = 1

   for id, _ in pairs(definitions.abilities) do
      wesnoth.set_dialog_value(id, "scenario_list", i, "scenario_name")
      wesnoth.set_dialog_value(id, "scenario_list", i, "scenario_id")
      wesnoth.set_dialog_visible(false, "scenario_list", i, "scenario_id")

      i = i + 1
   end
end

local function make_postshow(result)
   return function()
      local i = wesnoth.get_dialog_value("scenario_list")
      local id = wesnoth.get_dialog_value("scenario_list", i, "scenario_id")

      result.ability_id = id
   end
end

function wml_actions.show_learn_ability_list(cfg)
   local function show_dialog()
      local result = {}
      local input = wesnoth.show_dialog(dialog, preshow, make_postshow(result))
      return input > -2 and result or nil
   end

   local result = wesnoth.synchronize_choice("show_ability_list", show_dialog)

   local function learn(ability_id)
      local unit = wesnoth.get_unit(cfg.x, cfg.y)
      wesnoth.message(unit.id, ability_id)
      wml_actions.learn_ability {
         unit_id = unit.id,
         ability_id = ability_id
      }
   end

   if result.ability_id then
      learn(result.ability_id)
   end
end
