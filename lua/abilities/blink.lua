local max_distance = 30 / 5 -- ft / 5

local function blink(cfg)
   local units = wesnoth.get_units {
      side = wesnoth.current.side,
      canrecruit = true,
   }

   for _, unit in ipairs(units) do
      local distance = helper.distance_between(unit.x, unit.y, cfg.x, cfg.y)

      if distance > max_distance then
         wesnoth.message("[blink]", "out of range")
      elseif cfg.valid_location ~= 1 then
         wesnoth.message("[blink]", "invalid target")
      else
         wml_actions.teleport {
            T.filter {
               id = unit.id
            },
            x = cfg.x,
            y = cfg.y,
         }
      end
   end
end

return blink
