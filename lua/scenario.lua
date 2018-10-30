local dialog = require("dialogs/scenario")

local all_scenarios = {
   "my_first_scenario",
   "tyler_estate_intro",
   "cavern_stronghold",
   "forest_chase",
   "null",
}

local function preshow()
   local i = 1

   for _, scenario_id in ipairs(all_scenarios) do
      wesnoth.set_dialog_value(scenario_id, "scenario_list", i, "scenario_name")
      wesnoth.set_dialog_value(scenario_id, "scenario_list", i, "scenario_id")
      wesnoth.set_dialog_visible(false, "scenario_list", i, "scenario_id")

      i = i + 1
   end
end

local function make_postshow(result)
   return function()
      local i = wesnoth.get_dialog_value("scenario_list")
      local id = wesnoth.get_dialog_value("scenario_list", i, "scenario_id")

      result.scenario_id = id
   end
end

function wml_actions.change_scenario(cfg)
   local function show_scenario()
      local result = {}
      local input = wesnoth.show_dialog(dialog, preshow, make_postshow(result))

      return input > -2 and result or nil
   end

   local result = wesnoth.synchronize_choice("change_scenario", show_scenario)

   if result.scenario_id then
      wesnoth.set_next_scenario(result.scenario_id)

      wesnoth.end_level {
         --music = cfg.music,
         canrryover_report = false,
         save = false,
         replay_save = false,
         linger_mode = false,
         reveal_map = false,
         next_scenario = result.scenario_id,
         result = "victory",
      }
   end
end
