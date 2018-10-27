local abilities = {
   blink = {
      name = "Blink",
      icon = "icons/abilities/blink.png~SCALE(60,60)",
      image = "icons/abilities/blink.png",
      properties = {
         cast_type = "point_target",
         cast_range = 30,
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
      },
      description = [[
<b>Conjure Mirror Image</b> <i>(Recharge 5-6)</i>

See character sheet.
]]
   }
}

local feet_per_hex = 5

local function default_filter(unit, properties, filter)
   return {
      {"and", {
          x = unit.x,
          y = unit.y,
          radius = properties.cast_range / feet_per_hex,
      }},
      {"and", {
          {"filter_vision", {
              visible = "yes",
              respect_fog = "yes",
              side = unit.side,
          }},
      }},
      {"not", {
          terrain="Q*^*",
          {"or", {
              terrain="*^Q*",
          }}
      }},
      {"not", {
          terrain="X*^*",
          {"or", {
              terrain="*^X*",
          }}
      }},
      filter
   }
end

local cast_types = {
   point_target = function(unit, properties)
      local filter = {
         "not", {
            {"filter", {}}
      }}

      return default_filter(unit, properties, filter)
   end,

   unit_target = function(unit, properties)
      local filter = {
         "and", {
            {"filter", {
                {"not", {
                    side = unit.side
                }}
            }}
      }}
      return default_filter(unit, properties, filter)
   end,
}

local effects = {
}

return {
   abilities = abilities,
   effects = effects,
   cast_types = cast_types,
}
