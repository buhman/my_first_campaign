local dialog = require("dialogs/eval")
local engine = require("eval/engine")
local utils = require("utils")

local function preshow()
   wesnoth.set_dialog_focus("eval_input")
end

local function make_postshow(result, widget_id)
   return function()
      local input = wesnoth.get_dialog_value(widget_id)

      if input == "" then return end

      local function eval_err(message)
         wml_actions.chat {
            speaker="[eval]",
            message=message,
         }
      end

      local status, stack = xpcall(partial(engine.eval, input), eval_err)
      if not status then return end

      result.input = input
      -- make original raw values available
      result.stack = stack
      -- coerce single values
      stack = #stack == 1 and stack[1] or stack
      result.value = engine.dump(stack)
   end
end

function wml_actions.evaluate_expression(cfg)
   local function show_eval()
      local result = {}
      wesnoth.show_dialog(dialog, preshow, make_postshow(result, "eval_input"))
      result.side = wesnoth.get_viewing_side()
      return result
   end

   local result = wesnoth.synchronize_choice("evaluate_expression", show_eval)

   if result.input and result.value then
      local speaker = utils.unit_for_side(result.side).name
      wml_actions.chat {
         speaker = "[" .. speaker .. "]",
         message = "= " .. result.input .. "\n" .. engine.dump(result.value),
      }
   end
end

return {
   make_postshow = make_postshow
}
