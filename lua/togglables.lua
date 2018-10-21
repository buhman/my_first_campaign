local function toggle_terrain(modifier, terrain)
   if terrain:sub(-1) == modifier then
      return terrain:sub(1, -2)
   else
      return terrain .. modifier
   end
end

function wml_actions.toggle_door(cfg)
   local x, y, terrain = cfg.x, cfg.y, cfg.terrain

   terrain = toggle_terrain("o", terrain)
   wesnoth.set_terrain(x, y, terrain)
end

function wml_actions.toggle_brazier(cfg)
   local x, y, terrain = cfg.x, cfg.y, cfg.terrain

   terrain = toggle_terrain("n", terrain)
   wesnoth.set_terrain(x, y, terrain)
end

function wml_actions.fire_special_event(cfg)
   for event_name, loc in pairs(wesnoth.special_locations) do
      x,y = table.unpack(loc)
      if x == cfg.x and y == cfg.y then
         wesnoth.fire(event_name, { terrain = cfg.terrain })
         return
      end
   end
end
