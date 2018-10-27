local abilities = {
   blink = {
      name = "Blink",
      icon = "icons/abilities/blink.png~SCALE(60,60)",
      image = "icons/abilities/blink.png",
      properties = {
         cast_type = "point_target",
         cast_range = 30,
         cast_sound = "abilities/blink.ogg",
         cast_effect = "teleport",
      },
      description = [[
<b>Blink</b> <i>(Recharge 3-6)</i>

As a bonus action the monk teleports, along with any equipment he is wearing or carrying, up to 30 ft. to an unoccupied space he can see.
]],
   },
   arcane_void = {
      name = "Arcane Void",
      icon = "icons/abilities/mana_void.png~SCALE(60,60)",
      image = "icons/abilities/mana_void.png",
      properties = {
         cast_type = "unit_target",
         cast_range = 10,
         cast_effect = "mana_void",
         cast_sound = "abilities/mana_void.ogg",
      },
      description = [[
<b>Arcane Void</b> <i>(Recharge 6)</i>

See character sheet.
]]
   },
   conjure_mirror_image = {
      name = "Conjure Mirror Image",
      icon = "icons/abilities/conjure_mirror_image.png~SCALE(60,60)",
      image = "icons/abilities/conjure_mirror_image.png",
      properties = {
         cast_type = "point_target",
         cast_range = 5,
         cast_sound = "abilities/conjure_image.ogg",
         cast_effect = "mirror_image",
      },
      description = [[
<b>Conjure Mirror Image</b> <i>(Recharge 5-6)</i>

See character sheet.
]]
   }
}

local feet_per_hex = 5

local filter_impassable = T["not"] {
   terrain="Q*^*",
   T["or"] {
      terrain="*^Q*",
   },
   T["or"] {
      terrain="X*^*",
   },
   T["or"] {
      terrain="*^X*",
   },
}

local function default_filter(unit, properties, filter)
   return {
      T["and"] {
          x = unit.x,
          y = unit.y,
          radius = properties.cast_range / feet_per_hex,
      },
      T["and"] {
          T.filter_vision {
              visible = "yes",
              respect_fog = "yes",
              side = unit.side,
          },
      },
      filter_impassable,
      filter
   }
end

local cast_types = {
   point_target = function(unit, properties)
      local filter = T["not"] {
         T.filter {}
      }

      return default_filter(unit, properties, filter)
   end,

   unit_target = function(unit, properties)
      local filter = T["and"] {
         T.filter {
            T["not"] {
               side = unit.side
            }
         }
      }

      return default_filter(unit, properties, filter)
   end,
}

local function shuffle(t)
   local tbl = {}
   for i = #t, 1, -1 do
      local j = wesnoth.random(i)
      t[i], t[j] = t[j], t[i]
      table.insert(tbl, t[i])
   end
   return tbl
end

local effects = {
   teleport = function(unit, properties, target)
      wml_actions.teleport {
         T.filter {
            id = unit.id
         },
         x = target.x,
         y = target.y,
      }
   end,

   mirror_image = function(unit, properties, target)
      wml_actions.teleport {
         T.filter {
            id = unit.id
         },
         x = target.x,
         y = target.y,
      }

      local filter = {
         T["and"] {
            x = unit.x,
            y = unit.y,
            radius = 1,
         },
         T["not"] {
            T.filter {
            }
         },
      }

      local num_duplicates = 2
      for i, loc in pairs(shuffle(wesnoth.get_locations(filter))) do
         local dup = wesnoth.copy_unit(unit)
         dup.id = unit.id .. "_duplicate_" .. i
         dup.name = unit.name .. " duplicate"
         wesnoth.put_unit(dup, loc[1], loc[2])

         if i == num_duplicates then
            break
         end
      end

      wml_actions.event {
         name = "side " .. wesnoth.current.side .. " turn " .. (wesnoth.current.turn + 2),
         T.command {
            T.kill {
               id = unit.id .. "_duplicate_1"
            },
            T.kill {
               id = unit.id .. "_duplicate_2"
            },
         }
      }
   end,

   mana_void = function(unit, properties, target)
      local halo = "halo/implosion/implosion-1-[1~10].png:120,misc/empty.png:1000"
      items.place_halo(target.x, target.y, halo)

      wml_actions.delay {
         time = 1800
      }

      items.remove(target.x, target.y, halo)
   end,
}

return {
   abilities = abilities,
   effects = effects,
   cast_types = cast_types,
}
