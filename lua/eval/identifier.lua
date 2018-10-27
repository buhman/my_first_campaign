-- identifier functions

local function roll(die, n)
   local t = {}
   for _ = 1,n do
      local value = math.random(die)
      print("roll d" .. die .. ": " .. value)
      t[#t+1] = value
   end
   return t
end

local function sum(tbl)
   return foldr(operator.add, 0, tbl)
end

--

local function keep(which, tbl)
   return which(table.unpack(tbl))
end

local function keep_n(cmp, n, tbl)
   local t = {}
   local function popcmp()
      local idx = #tbl
      for i, v in ipairs(tbl) do
         if cmp(v, tbl[idx]) then
            idx = i
         end
      end
      return table.remove(tbl, idx)
   end

   while #t < n do
      t[#t+1] = popcmp()
   end
   return t
end

return {
   roll = roll,
   sum = sum,
   keep = keep,
   keep_n = keep_n,
}
