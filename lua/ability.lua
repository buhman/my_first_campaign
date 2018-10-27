local dialog = require "dialogs/ability"
local definitions = require "ability/definitions"

local function select_ability()
   local i = wesnoth.get_dialog_value("ability_list")
   local id = wesnoth.get_dialog_value("ability_list", i, "ability_id")
   local a = definitions.abilities[id]

   wesnoth.set_dialog_value(a.image, "ability_image")
   wesnoth.set_dialog_value(a.description, "ability_description")
end

local function make_postshow(result)
   return function()
      local i = wesnoth.get_dialog_value("ability_list")
      local id = wesnoth.get_dialog_value("ability_list", i, "ability_id")

      result.ability_id = id
   end
end

local function make_preshow(unit)
   local ability_ids = wml.array_access.get("custom_ability", unit.variables)

   return function()
      for i, acfg in ipairs(ability_ids) do
         local a = definitions.abilities[acfg.id]
         wesnoth.set_dialog_value(acfg.id, "ability_list", i, "ability_id")
         wesnoth.set_dialog_visible(false, "ability_list", i, "ability_id")
         wesnoth.set_dialog_value(a.name, "ability_list", i, "ability_name")
         wesnoth.set_dialog_value(a.icon, "ability_list", i, "ability_icon")
      end

      wesnoth.set_dialog_markup(true, "ability_description")
      wesnoth.set_dialog_callback(select_ability, "ability_list")

      select_ability()
   end
end

local function get_ability_filter(unit, ability)
   local ct = definitions.cast_types[ability.properties.cast_type]
   local filter = ct(unit, ability.properties)

   return filter
end

local function show_target_hexes(filter)
   for _, loc in pairs(wesnoth.get_locations(filter)) do
      items.place_halo(loc[1], loc[2], "misc/goal-highlight.png")
   end
end

local function remove_target_hexes(filter)
   for _, loc in pairs(wesnoth.get_locations(filter)) do
      items.remove(loc[1], loc[2], "misc/goal-highlight.png")
   end
end

function wml_actions.ability_cast(cfg)
   wesnoth.message("[cast]", string.format("%s %s: (%s, %s)", cfg.unit_id, cfg.ability_id, cfg.x, cfg.y))
   -- do the cast effect

   wml_actions.ability_cancel(cfg)
end

function wml_actions.ability_cancel(cfg)
   local unit = wesnoth.get_units({id = cfg.unit_id})[1]
   local ability = definitions.abilities[cfg.ability_id]
   local filter = get_ability_filter(unit, ability)

   remove_target_hexes(filter)
   wml_actions.clear_menu_item({id = "cast_ability"})
end

function wml_actions.learn_ability(cfg)
   local unit = wesnoth.get_units({id = cfg.unit_id})[1]
   local ability_id = cfg.ability_id
   local ability_ids = wml.array_access.get("custom_ability", unit.variables)

   -- don't add duplicate ability
   for _, id in ipairs(ability_ids) do
      if ability_id == id then
         wesnoth.message("bug", "attempt to learn duplicate ability: " .. id)
         return
      end
   end

   unit.variables[string.format("custom_ability[%d].id", #ability_ids)] = ability_id
end

function wml_actions.show_ability_list(cfg)
   local unit = wesnoth.get_unit(cfg.x, cfg.y)

   local function show_abilities()
      local result = {}
      local input = wesnoth.show_dialog(dialog, make_preshow(unit), make_postshow(result))
      return input > -2 and result or nil
   end

   local result = wesnoth.synchronize_choice("pick_ability", show_abilities)

   if not result.ability_id then
      return
   end
   local ability = definitions.abilities[result.ability_id]

   local filter = get_ability_filter(unit, ability)

   if #(wesnoth.get_locations(filter)) == 0 then
      wesnoth.message("[no target]", string.format("no %s in range of '%s'", ability.properties.cast_type, ability.name))
      return
   end

   show_target_hexes(filter)

   wml_actions.set_menu_item {
      id = "cast_ability",
      description = "Cast: " .. ability.name,
      image = "icons/editor-brush-1_25.png",
      {"filter_location", filter},
      {"command", {
          {"ability_cast", {ability_id = result.ability_id, unit_id = unit.id, x = "$x1", y = "$y1"}}
      } }
   }
end
