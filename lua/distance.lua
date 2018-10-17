local feet_per_hex = 5

function wml_actions.show_distance(cfg)
   local units = wesnoth.get_units {
      side = wesnoth.current.side,
      canrecruit = true,
   }

   for _, unit in ipairs(units) do
      local distance = helper.distance_between(unit.x, unit.y, cfg.x, cfg.y)

      wesnoth.message(string.format("distance (%s %s) (%s %s) = %s units = %s ft.", unit.x, unit.y, cfg.x, cfg.y, distance, distance * feet_per_hex))
   end
end
