local lexer = {}

-- token matchers

local function is_digit(c)
   return string.match(c, "[0-9]") == c
end

local function is_operator(c)
   return string.match(c, "[-+*/]") == c
end

local function is_whitespace(c)
   return string.match(c, "[%s]") == c
end

local function is_paren(c)
   return string.match(c, "[()]") == c
end

local function is_identifier(c)
   return string.match(c, "[a-z]") == c
end

-- token mapping

local tokens = {
   ["digit"] = is_digit,
   ["operator"] = is_operator,
   ["whitespace"] = is_whitespace,
   ["paren"] = is_paren,
   ["identifier"] = is_identifier,
}

local discard = {
   ["whitespace"] = true,
}

local collect = {
   ["digit"] = true,
   ["identifier"] = true,
}

local function find_token(c)
   for token_type, match in pairs(tokens) do
      if match(c) then
         return token_type
      end
   end
   return "invalid"
end

function lexer.tokenize(string_expr)
   local buffer = ""
   local tokens = {}
   local last_token = "invalid"

   local function maybe_insert(token_type, token_value)
      if buffer ~= "" and not discard[token_type] then
         table.insert(tokens, {last_token, buffer})
      end
   end

   local function maybe_collect(token_type, c)
      if collect[token_type] then
         return buffer .. c
      else
         return c
      end
   end

   for c in string_expr:gmatch('.') do
      local this_token = find_token(c)

      if not (collect[this_token] and last_token == this_token) then
         maybe_insert(last_token, buffer)
         buffer = ""
      end

      buffer = maybe_collect(this_token, c)
      last_token = this_token
   end
   table.insert(tokens, {last_token, buffer})

   return tokens
end

--

return lexer
