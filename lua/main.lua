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
require("door")

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

--
require("turn_order")


-- compiled lisp includes

wesnoth.require("~add-ons/my_first_campaign/lisp/out.lua")

function wml_actions.blah(cfg)
   wesnoth.message(string.format("%q", cfg.puzzle))
   for k, v in pairs(cfg.puzzle) do
      wesnoth.message(string.format("%s %s", k, v))
   end
end
