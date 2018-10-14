local function toggle_door(terrain)
   if terrain:sub(-1) == "o" then
      return terrain:sub(1, -2)
   else
      return terrain .. "o"
   end
end

function wml_actions.toggle_door(cfg)
   local x, y, terrain = cfg.x, cfg.y, cfg.terrain

   terrain = toggle_door(terrain)
   wesnoth.set_terrain(x, y, terrain)
end
