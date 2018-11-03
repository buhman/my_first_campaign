require "functional"

local make_result_dialog = require "dialogs/macros/attack_page_results"
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

local function preshow(attacks)
   local unit = utils.unit_for_side(wesnoth.current.side)
   local color = wesnoth.sides[wesnoth.current.side].color

   local styled_name = "<span font_size='large' color='" .. color_table[color] .. "'>" .. unit.name .. "</span>"
   local rc_image = unit.__cfg.image .. "~RC(magenta>" .. color .. ")"

   for index, outcome in ipairs(attacks) do
      wesnoth.set_dialog_value(styled_name, "attack_result_list", index, "character")
      wesnoth.set_dialog_value(rc_image, "attack_result_list", index, "character_image")

      for field, tbl in pairs(outcome) do
         wesnoth.set_dialog_value(sized(tbl.value, 'larger', tbl.color), "attack_result_list", index, field)
      end
   end
end

function show_results(tooltips, attacks)
   local dialog = make_result_dialog(tooltips)
   wesnoth.show_dialog(dialog, partial(preshow, attacks))
end

return show_results
