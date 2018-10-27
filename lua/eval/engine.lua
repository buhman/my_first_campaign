require "eval/functional"

parser = require "eval/parser"
lexer = require "eval/lexer"
interpreter = require "eval/interpreter"

local eval = compose(
   lexer.tokenize,
   parser.uninfix,
   interpreter.evaluate
)

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
   dump = dump,
}
