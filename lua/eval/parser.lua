require "functional"

local parser = {}

local precedence = {
   ["+"] = 2,
   ["-"] = 2,
   ["*"] = 3,
   ["/"] = 3,
   ["s"] = 4,
   ["kh"] = 4,
   ["kl"] = 4,
   ["khn"] = 4,
   ["kln"] = 4,
   ["d"] = 5,
}

-- shunting yard; algebraic expression -> RPN expression

function parser.uninfix(input_queue)
   local output_queue = {}
   local operator_queue = {}

   local function shunt_operator(token)
      local _, this_value = table.unpack(token)

      while true do
         top_token = operator_queue[#operator_queue]
         if top_token == nil then break end
         local top_type, top_value = table.unpack(top_token)
         if (false
                or ((top_type == "operator" or top_type == "identifier")
                      and precedence[top_value] >= precedence[this_value])
                or (top_type == "paren" and top_value == ")"))
         then
            push(output_queue, pop(operator_queue))
         else
            break
         end
      end

      push(operator_queue, token)
   end

   local function right_paren(_)
      while true do
         top_token = operator_queue[#operator_queue]
         assert(top_token ~= nil, "mismatched parenthesis")
         local top_type, top_value = table.unpack(top_token)
         if not (top_type == "paren" and top_value == "(") then
            push(output_queue, pop(operator_queue))
         else
            break
         end
      end

      pop(operator_queue)
   end

   local paren_switch = {
      ["("] = partial(push, operator_queue),
      [")"] = right_paren,
   }

   local function shunt_paren(token)
      local _, this_value = table.unpack(token)

      paren_switch[this_value](token)
   end

   local type_switch = {
      ["digit"] = partial(push, output_queue),
      ["operator"] = shunt_operator,
      ["paren"] = shunt_paren,
      ["identifier"] = shunt_operator,
   }

   local function shunt(token)
      local token_type, _ = table.unpack(token)
      type_switch[token_type](token)
   end

   map(shunt, input_queue)

   while true do
      token = pop(operator_queue)
      if token == nil then break end
      push(output_queue, token)
   end

   return output_queue
end

--

return parser
