local dialog = require "dialogs/ability"

local callbacks = {
   blink = require "abilities/blink",
}

local abilities = {
   {
      name = "Blink",
      icon = "icons/abilities/blink.png~SCALE(60,60)",
      image = "abilities/blink.png~SCALE_INTO(225,100)",
      description = "<b>Blink</b> <i>(Recharge 3-6)</i>\nAs a bonus action the monk teleports, along with any equipment he is wearing or carrying, up to 30 ft. to an unoccupied space he can see.",
      callback = callbacks.blink,
   },
   {
      name = "Dummy",
      icon = "misc/blank-hex.png~SCALE(60,60)",
      image = "portraits/undead/wraith.png~SCALE_INTO(225,150)",
      description = "<b>Dummy</b>\nAs a bonus action, isn't this the coolest shit?"
   }
}

local function select_ability()
   local i = wesnoth.get_dialog_value("ability_list")
   local a = abilities[i]

   wesnoth.set_dialog_value(a.image, "ability_image")
   wesnoth.set_dialog_value(a.description, "ability_description")
end

local function make_postshow(result)
   return function()
      local i = wesnoth.get_dialog_value("ability_list")

      result.choice = i
   end
end

local function preshow()
   for i, a in ipairs(abilities) do
      wesnoth.set_dialog_value(a.name, "ability_list", i, "ability_name")
      wesnoth.set_dialog_value(a.icon, "ability_list", i, "ability_icon")
   end

   wesnoth.set_dialog_markup(true, "ability_description")

   wesnoth.set_dialog_callback(select_ability, "ability_list")

   select_ability()
end

function wml_actions.use_ability(cfg)
   local function show_abilities()
      local result = {}

      local input = wesnoth.show_dialog(dialog, preshow, make_postshow(result))

      return input > -2 and result or nil
   end

   local result = wesnoth.synchronize_choice("pick_ability", show_abilities)

   if result.choice then
      local a = abilities[result.choice]
      if a.callback then a.callback(cfg) end
   end
end
