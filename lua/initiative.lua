local gt = require("dialogs/generic_text")

local eval = require("eval")
local engine = require("eval/engine")
local utils = require("utils")

local function preshow(side)
   local side = wesnoth.get_viewing_side()
   local name = utils.unit_for_side(side).name

   wesnoth.set_dialog_focus("eval_initiative")
   wesnoth.set_dialog_value("Roll initiative for " .. name, "title")
end

local function sort_initiative(results)
   local initiative = {}

   for side, result in ipairs(results) do
      local unit = utils.unit_for_side(side)
      if unit ~= nil then
         -- XXX: ??? result gets clobbered by synchronize_choices??
         -- result.stack should be a table here, but it's not?
         if result.value ~= nil then
            table.insert(initiative, {tonumber(result.value), unit.name, side})
         end
      end
   end

   local function cmp_initiative(a, b)
      local value_a, _, _ = table.unpack(a)
      local value_b, _, _ = table.unpack(b)

      return value_a > value_b
   end

   table.sort(initiative, cmp_initiative)

   return initiative
end

local function initiative_message(initiative)
   local msg = "order:\n"
   for _, order in ipairs(initiative) do
      value, name = table.unpack(order)
      msg = msg .. string.format("  %s: %s\n", name, value)
   end

   wesnoth.message("[initiative]", msg)
end

function wml_actions.roll_initiative(cfg)
   -- clear initiative if already rolled
   if #tc_campaign.current_initiative ~= 0 then
      tc_campaign.current_initiative = {}
      return
   end

   local function show_initiative()
      local result = {}

      local dialog = make_dialog {
         id = "eval_initiative",
      }
      local val = wesnoth.show_dialog(dialog, preshow, eval.make_postshow(result))

      -- XXX maybe use single_eval
      if not result.stack or #(result.stack) ~= 1 or type(result.stack[1]) ~= "number" then
         local explain = "your expression was either malformed, or returned multiple values (did you forget 's' on a dice roll?)"
         local msg = string.format("single value required, got: %s\n%s", result.value, explain)
         wesnoth.message("[invalid expression]", msg)
         return show_initiative()
      else
         wesnoth.message("[initiative]", result.value)
         return result
      end
   end

   local sides = utils.side_list()
   local function default_value()
      return {}
   end
   local results = wesnoth.synchronize_choices("initiative", show_initiative, default_value, sides)

   local initiative = sort_initiative(results)
   --initiative_message(initiative)

   tc_campaign.current_initiative = initiative
end
