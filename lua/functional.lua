-- map(function, ...)
-- > map(math.floor, {0.5, 1.5})
-- {0, 1}
function map(f, ...)
   local t = {}
   for k, v in ipairs(...) do
      t[#t+1] = f(v)
   end
   return t
end

-- filter(function, table)
-- > filter(function(v) return v == 3 end, {1,2,3,4,5})
-- {3}
function filter(f, tbl)
   local t = {}
   for i, v in pairs(tbl) do
      if func(v) then
         t[i] = v
      end
   end
   return t
end

-- foldr(function, initial_value, table)
-- > foldr(operator.mul, 1, {1,2,3,4,5})
-- 120
function foldr(func, val, tbl)
   for i, v in pairs(tbl) do
      val = func(val, v)
   end
   return val
end

-- partial(function, arg)
-- > add2 = partial(operator.add, 2)
-- > add2(2)
-- 4
function partial(f, arg)
   return function(...)
      return f(arg, ...)
   end
end

-- compose(function, ...)
-- > aasin = compose(math.sin, math.asin)
-- > aasin(0.5)
-- 0.5
function compose(...)
   local fn = {...}
   local function recurse(i, ...)
      if i == #fn then return fn[i](...) end
      return recurse(i + 1, fn[i](...))
   end
   return function(...) return recurse(1, ...) end
end

-- range(n)
-- > range(5)
-- {1,2,3,4,5}
function range(n)
   t = {}
   for i = 1,n do
      table.insert(t, i)
   end
   return t
end

-- repeat
function repeat_n(val, n)
   t = {}
   for i = 1,n do
      table.insert(t, val)
   end
   return t
end

-- table aliases

push = table.insert
pop = table.remove

-- functional operators

operator = {
   mod = math.mod;
   pow = math.pow;
   add = function(n,m) return n + m end;
   sub = function(n,m) return n - m end;
   mul = function(n,m) return n * m end;
   div = function(n,m) return n / m end;
   gt  = function(n,m) return n > m end;
   lt  = function(n,m) return n < m end;
   eq  = function(n,m) return n == m end;
   le  = function(n,m) return n <= m end;
   ge  = function(n,m) return n >= m end;
   ne  = function(n,m) return n ~= m end;
}

return {}
