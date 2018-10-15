-- globals

T = wml.tag
_ = wesnoth.textdomain 'wesnoth-my_first_campaign'

helper = wesnoth.require 'lua/helper.lua'
wml_actions = wesnoth.wml_actions

-- setup

function require(script)
   return wesnoth.require(("~add-ons/my_first_campaign/lua/%s.lua"):format(script))
end

-- actions

-- [evaluate_expression]
require("eval")
-- [toggle_door]
require("door")
-- [place_unit]
require("unit")
-- [change_scenario]
require("scenario")
