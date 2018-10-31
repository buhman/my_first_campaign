local function unit_for_side(side)
   local units = wesnoth.get_units {
      side = side,
      canrecruit = true,
   }

   return units[1]
end

local function side_list()
   local t = {}
   for i, _ in ipairs(wesnoth.sides) do
      table.insert(t, i)
   end

   return t
end

return {
   unit_for_side = unit_for_side,
   side_list = side_list,
}
