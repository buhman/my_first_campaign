local dialog = require "dialogs/unit"

local function select_unit()
   local i = wesnoth.get_dialog_value("unit_list")
   local id = wesnoth.get_dialog_value("unit_list", i, "list_id")
   local ut = wesnoth.unit_types[id].__cfg

   wesnoth.set_dialog_value(ut.image .. "~SCALE_SHARP(125, 125)", "type_image")
   wesnoth.set_dialog_value(ut.name, "type_name")
end

local function sorted_units(unit_types)
   local sorted = {}

   local function cmp_race_id(a, b)
      local race_a, id_a = table.unpack(a)
      local race_b, id_b = table.unpack(b)
      if race_a ~= race_b then
         return race_a < race_b
      else
         return id_a < id_b
      end
   end

   for _, u in pairs(unit_types) do
      sorted[#sorted+1] = {u.race, u.id}
   end

   table.sort(sorted, cmp_race_id)

   return sorted
end

local function preshow()
   local i = 1

   local units = sorted_units(wesnoth.unit_types)

   for _, tpl in ipairs(units) do
      _, id = table.unpack(tpl)
      u = wesnoth.unit_types[id]
      wesnoth.set_dialog_value(u.__cfg.race, "unit_list", i, "list_race")
      wesnoth.set_dialog_value(u.name, "unit_list", i, "list_name")

      wesnoth.set_dialog_value(u.id, "unit_list", i, "list_id")
      wesnoth.set_dialog_visible(false, "unit_list", i, "list_id")
      i = i + 1
   end

   wesnoth.set_dialog_callback(select_unit, "unit_list")

   select_unit()
end

local function make_postshow(result)
   return function()
      local i = wesnoth.get_dialog_value("unit_list")
      local id = wesnoth.get_dialog_value("unit_list", i, "list_id")

      result.unit_type = id
   end
end

function wml_actions.place_unit(cfg)
   local function show_unit()
      local result = {}
      local input = wesnoth.show_dialog(dialog, preshow, make_postshow(result))

      return input > -2 and result or nil
   end

   local result = wesnoth.synchronize_choice("place_unit", show_unit)

   if result.unit_type then
      local unit = wesnoth.create_unit { type = result.unit_type }
      wesnoth.put_unit(unit, cfg.x, cfg.y)
   end
end
