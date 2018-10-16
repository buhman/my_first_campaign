local dialog = require("dialogs/initiative")

local eval = require("eval")
local engine = require("eval/engine")

local function preshow(side)
   local name = wesnoth.sides[wesnoth.current.side].user_team_name

   wesnoth.set_dialog_focus("eval_input")
   --wesnoth.set_dialog_value("Roll initiative for " .. name .. " : " .. side, "title")
end

local function sort_initiative(results)
   local initiative = {}

   for side, result in ipairs(results) do
      local name = wesnoth.sides[side].user_team_name
      -- XXX: ??? result gets clobbered by synchronize_choices??
      -- result.stack should be a table here, but it's not?
      if result.value ~= nil then
         initiative[#initiative+1] = {tonumber(result.value), name, side}
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
   if #mfc_campaign.current_initiative ~= 0 then
      mfc_campaign.current_initiative = {}
      return
   end

   local function show_initiative()
      local result = {}

      local val = wesnoth.show_dialog(dialog, preshow, eval.make_postshow(result))

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

   local sides = {1,2,3,4,5}
   local function default_value()
      return {}
   end
   local results = wesnoth.synchronize_choices("initiative", show_initiative, default_value, sides)

   local initiative = sort_initiative(results)
   --initiative_message(initiative)

   mfc_campaign.current_initiative = initiative
end
