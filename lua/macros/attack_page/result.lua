require "functional"

local apr = require "dialogs/macros/attack_page_results"
local gt = require "dialogs/generic_text"
local utils = require "utils"

local color_table = {
   black = "#989898",
   blue = "#7d89c0",
   green = "#9dd19e",
   purple = "#bb60c2",
   red = "#ff6060",
}

local function sized(text, size, color)
   local color = color and color or "white"
   return "<span font_size='" .. size .. "' color='" .. color .. "' weight='bold'>" .. text .. "</span>"
end

local function summary_preshow(attacks, target_ac)
   local unit = utils.unit_for_side(wesnoth.current.side)
   local color = wesnoth.sides[wesnoth.current.side].color

   local styled_name = "<span font_size='large' color='" .. color_table[color] .. "'>" .. unit.name .. "</span>"
   local rc_image = unit.__cfg.image .. "~RC(magenta>" .. color .. ")"

   for index, outcome in ipairs(attacks) do
      wesnoth.set_dialog_value(styled_name, "attack_result_list", index, "character")
      wesnoth.set_dialog_value(rc_image, "attack_result_list", index, "character_image")

      for field, tbl in pairs(outcome) do
         local value = tbl.value and tbl.value or "-"
         wesnoth.set_dialog_value(sized(value, 'larger', tbl.color), "attack_result_list", index, field)
      end
   end
end

local function armor_postshow(result)
   local value = wesnoth.get_dialog_value("armor_class")

   result.armor_class = tonumber(value)
end

local function vs_ac(target_ac, outcome)
   local color

   if outcome.attack.value >= target_ac then
      color = "teal"
   else
      color = "lightgrey"
      outcome.damage.value = nil
      outcome.damage.extra = nil
   end

   -- if already colored, this is a critical; ignore
   if not outcome.attack.color then
      outcome.attack.color = color
   end

   return outcome
end

local function show_results(tooltips, attacks)
   local gm_side = 1

   local armor_dialog = gt.make_dialog {
      id = "armor_class",
      label = "Target armor class?"
   }

   local summary_dialog = apr.make_dialog {
      tooltips = tooltips,
   }

   local function resolve_attacks()
      local result = {}
      wesnoth.show_dialog(armor_dialog, function () end, partial(armor_postshow, result))
      if not result.armor_class then
         return resolve_attacks()
      end

      return result
   end

   local res = wesnoth.synchronize_choices("resolve_attacks_gm", resolve_attacks, identityf({}), {gm_side})
   local target_ac = res[1].armor_class
   local attacks = map(partial(vs_ac, target_ac), attacks)

   local this_side = wesnoth.get_viewing_side()
   if this_side == gm_side or this_side == wesnoth.current.side then
      wesnoth.show_dialog(summary_dialog, partial(summary_preshow, attacks))
   end
end

return show_results
