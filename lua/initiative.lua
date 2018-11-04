local gt = require("dialogs/generic_text")

local eval = require("eval")
local engine = require("eval/engine")
local utils = require("utils")
local turn_order = require("turn_order")

local function preshow(side)
   local side = wesnoth.get_viewing_side()
   local name = utils.unit_for_side(side).name

   wesnoth.set_dialog_focus("eval_initiative")
   wesnoth.set_dialog_value("Roll initiative for " .. name, "title")
end

local function sort_initiative(results)
   local initiative = {}

   for side, result in ipairs(results) do
      if result.value ~= nil then
         table.insert(initiative, { roll_value = result.value, side = side })
      end
   end

   local function cmp_initiative(a, b)
      return a.roll_value > b.roll_value
   end

   table.sort(initiative, cmp_initiative)

   return initiative
end

-- XXX dead code
local function initiative_message(initiative)
   local msg = "order:\n"
   for _, order in ipairs(initiative) do
      value, name = table.unpack(order)
      msg = msg .. string.format("  %s: %s\n", name, value)
   end

   wesnoth.message("[initiative]", msg)
end

local single_explain = [[your expression was either malformed, or returned multiple values (did you forget 's' on a dice roll?)"
    stack: %s
]]

function wml_actions.roll_initiative(cfg)
   -- clear initiative if already rolled
   if #turn_order.state.current_initiative ~= 0 then
      turn_order.state.current_initiative = {}
      return
   end

   local function show_initiative()
      local result = {}

      local dialog = make_dialog {
         id = "eval_initiative",
      }
      local val = wesnoth.show_dialog(dialog, preshow, eval.make_postshow(result, "eval_initiative"))

      if not result.stack or #(result.stack) ~= 1 or type(result.stack[1]) ~= "number" then
         wesnoth.message("[invalid expression]", string.format(single_explain, result.value))
         return show_initiative()
      end

      wesnoth.message("[initiative roll]", result.value)
      return {value = result.stack[1]}
   end

   local sides = utils.side_list()
   local results = wesnoth.synchronize_choices("initiative", show_initiative, identityf({}), sides)

   local initiative = sort_initiative(results)

   turn_order.state.current_initiative = initiative
end
