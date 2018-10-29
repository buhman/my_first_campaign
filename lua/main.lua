-- globals

T = wml.tag
_ = wesnoth.textdomain 'wesnoth-my_first_campaign'

helper = wesnoth.require 'lua/helper.lua'
items = wesnoth.require "lua/wml/items.lua"
wml_actions = wesnoth.wml_actions

-- setup

function require(script)
   return wesnoth.require(("~add-ons/my_first_campaign/lua/%s.lua"):format(script))
end

-- theme

require("theme")

-- actions

-- [evaluate_expression]
require("eval")
-- [toggle_door]
-- [toggle_brazier]
require("togglables")

-- [place_unit]
require("unit/place")
-- [extract_unit]
require("unit/pop")

-- [change_scenario]
require("scenario")
-- [roll_initiative]
require("initiative")
-- [show_distance]
require("distance")
-- [use_ability]
require("ability")
-- [show_ability_list]
require("ability_dm")
-- [character_emote]
require("emote")
--
require("turn_order")

-- [init_abilities]
require("units/abilities")

-- compiled lisp includes
wesnoth.require("~add-ons/my_first_campaign/lisp/out.lua")

-- XXX zzz fixme hacks
function wml_actions.glyph_puzzle_events(cfg)
   for i = 1,3 do
      local this_lever = "lever" .. i

      wesnoth.add_event_handler {
         name = "enter_hex",
         first_time_only = "no",

         { "filter", {
              { "filter_location", {
                   location_id = this_lever,
              } }
         } },

         { "glyph_toggle_lever", {
              lever_id = i,
         } },

         { "cancel_action", {
         } },

         { "move_unit", {
              id = "$unit.id",
              to_x = "$x2",
              to_y = "$y2",
         } }
      }
   end
end

function wml_actions.glyph_puzzle_complete(cfg)
   wml_actions.tunnel {
      bidirectional = "no",

      { "filter", {
      } },

      { "source", {
           location_id = "tunnel_source",
      } },

      { "target", {
           location_id = "tunnel_target",
      } },
   }

   wml_actions.item {
      location_id = "tunnel_source",
      image = "items/portal_blue.png",
   }

   wml_actions.item {
      location_id = "tunnel_target",
      image = "items/portal_orange.png",
   }
end
