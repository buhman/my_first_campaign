local dialog = require("dialogs/unit")
local engine = require("eval/engine")

local function select_unit()
   local i = wesnoth.get_dialog_value("unit_list")
   local id = wesnoth.get_dialog_value("unit_list", i, "list_id")
   local ut = wesnoth.unit_types[id].__cfg

   wesnoth.set_dialog_value(ut.image .. "~SCALE_SHARP(125, 125)", "type_image")
   wesnoth.set_dialog_value(ut.name, "type_name")
end

local function preshow()
   local i = 1

   for id, u in pairs(wesnoth.unit_types) do
      wesnoth.set_dialog_value(u.__cfg.image, "unit_list", i, "list_image")

      wesnoth.set_dialog_value("<big>" .. u.name .. "</big>", "unit_list", i, "list_name")
      wesnoth.set_dialog_markup(true, "unit_list", i, "list_name")

      wesnoth.set_dialog_value(id, "unit_list", i, "list_id")
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
      wesnoth.put_unit(cfg.x, cfg.y, unit)
   end
end
