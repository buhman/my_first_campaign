require "functional"

identifier = require "eval/identifier"

local interpreter = {}

-- operator mapping

local operators = {
   ["+"] = operator.add,
   ["-"] = operator.sub,
   ["*"] = operator.mul,
   ["/"] = operator.div,
   --
   ["d"] = identifier.roll,
   ["s"] = identifier.sum,
   ["kh"] = partial(identifier.keep, math.max),
   ["kl"] = partial(identifier.keep, math.min),
   ["khn"] = partial(identifier.keep_n, operator.gt),
   ["kln"] = partial(identifier.keep_n, operator.lt),
}

local unary = {
   ["s"] = true,
   ["kh"] = true,
   ["kl"] = true,
}

--

function interpreter.evaluate(rpn)
   local stack = {}

   local function digit(value)
      push(stack, tonumber(value))
   end

   local function operator(value)
      local func = operators[value]
      local args
      if unary[value] then
         args = {pop(stack)}
      else
         args = {pop(stack), pop(stack)}
      end
      local result = func(table.unpack(args))
      push(stack, result)
   end

   local switch = {
      ["digit"] = digit,
      ["operator"] = operator,
      ["identifier"] = operator,
   }

   function eval_token(token)
      token_type, token_value = table.unpack(token)
      switch[token_type](token_value)
   end

   map(eval_token, rpn)

   return stack
end

--

return interpreter
