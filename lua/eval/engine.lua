require "functional"

parser = require "eval/parser"
lexer = require "eval/lexer"
interpreter = require "eval/interpreter"

local eval = compose(
   lexer.tokenize,
   parser.uninfix,
   interpreter.evaluate
)

local function eval_single(expr)
   local stack = eval(expr)
   if #stack ~= 1 then
      local msg = [[usage error: single stack return value required
    expr = %q
    #stack = %q
    dump(stack) = %s
]]
      wesnoth.message(string.format(msg, expr, #stack, engine.dump(stack)))
      error("aborted")
   end
   return stack[#stack]
end

local function dump(o)
   if type(o) == 'table' then
      local s = '[ '
      for i, v in pairs(o) do
         if type(v) == 'string' then v = '"'..v..'"' end
         s = s .. dump(v) .. (i == #o and ' ' or ', ')
      end
      return s .. ']'
   else
      return tostring(o)
   end
end

return {
   eval = eval,
   eval_single = eval_single,
   dump = dump,
}
