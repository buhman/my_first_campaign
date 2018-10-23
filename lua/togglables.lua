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
   local str, ending = cfg.terrain, cfg.ends_with
   local condition = str:sub(-#ending) ~= ending

   function fire_event(event_name)
      action = wml_actions[event_name]
      if action ~= nil then
         -- for native code, it is easier to write actions
         action {
            condition = condition
         }
      else
         -- for wml, custom events are easier
         local name = event_name .. string.format("_%s", condition)
         wml_actions.fire_event {
            name = name
         }
      end
   end

   for event_name, loc in pairs(wesnoth.special_locations) do
      x,y = table.unpack(loc)
      if x == cfg.x and y == cfg.y then
         fire_event(event_name)
      end
   end
end
