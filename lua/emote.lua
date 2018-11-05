local dialog = require("dialogs/emote")

local messages = {
   {
      text = "Magic shall not prevail!",
      sound = "antimage/magic_shall_not_prevail.ogg",
   },
   {
      text = "I bring an end to magic!",
      sound = "antimage/bring_an_end_to_magic.ogg",
   },
   {
      text = "I fear no vile sorcery!",
      sound = "antimage/fear_no_vile_sorcery.ogg",
   },
   {
      text = "They who live by the wand, shall die by my blade",
      sound = "antimage/they_who_live_by_the_wand.ogg",
   },
   {
      text = "Are you even trying?",
      sound = "antimage/are_you_even_trying.ogg",
   },
   {
      text = "Spawn of sorcery!",
      sound = "antimage/spawn_of_sorcery.ogg",
   },
   {
      text = "Prepare thyself!",
      sound = "antimage/prepare_thyself.ogg",
   },
   {
      text = "I've sundered this cabal!",
      sound = "antimage/sundered_cabal.ogg",
   },
   {
      text = "Here's thy reckoning",
      sound = "antimage/heres_thy_reckoning.ogg",
   },
   {
      text = "Bark on bitch, I hear thee not",
      sound = "antimage/bark_on_bitch.ogg",
   },
   {
      text = "Beset on all sides, still I prevail!",
      sound = "antimage/beset_on_all_sides.ogg",
   },
   {
      text = "Vile sorcerers, to thy just reward my blade compels thee.",
      sound = "antimage/vile_sorcerers.ogg",
   }
}

local function preshow()
   for emote_id, emote in ipairs(messages) do
      wesnoth.set_dialog_value(emote.text, "emote_list", emote_id, "emote_name")
   end
end

local function make_postshow(result)
   return function()
      local i = wesnoth.get_dialog_value("emote_list")

      result.message_ix = i
   end
end

function wml_actions.character_emote(cfg)
   local unit = wesnoth.get_unit(cfg.x, cfg.y)

   local function show_emote()
      local result = {}
      local input = wesnoth.show_dialog(dialog, preshow, make_postshow(result))
      return input > -2 and result or nil
   end

   local result = wesnoth.synchronize_choice("show_emote", show_emote)

   if result.message_ix then
      local message = messages[result.message_ix]

      wml_actions.message {
         speaker = unit.id,
         message = message.text,
         voice = message.sound,
      }
   end
end
