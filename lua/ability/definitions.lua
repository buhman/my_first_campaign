local dialog = require "dialogs/generic_text"

local gm_side = 1

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
   },
   deafening_blast = {
      name = "Deafening Blast",
      icon = "icons/abilities/deafening_blast.png~SCALE(60,60)",
      image = "icons/abilities/deafening_blast.png",
      properties = {
         cast_type = "ground_target",
         cast_range = 5,
         cast_effect = "deafening_blast",
         pre_cast_sound = "invoker/aureal_incapacitator.ogg",
         cast_sound = "abilities/deafening_blast.ogg",
      },
      description = [[
<b>Deafening Blast</b>

Knockback
]]
   },
   sun_strike = {
      name = "Sunburst",
      icon = "icons/abilities/sun_strike.png~SCALE(60,60)",
      image = "icons/abilities/sun_strike.png",
      properties = {
         cast_type = "self",
         cast_effect = "sun_strike",
         pre_cast_sound = "invoker/incantation_of_incineration.ogg",
         cast_sound = "abilities/sun_strike.ogg",
      },
      description = [[
<b>Sunburst</b>

More fire
]]
   },
   chaos_meteor = {
      name = "Meteor Swarm",
      icon = "icons/abilities/chaos_meteor.png~SCALE(60,60)",
      image = "icons/abilities/chaos_meteor.png",
      properties = {
         cast_type = "ground_target",
         cast_range = 5,
         cast_effect = "null",
         pre_cast_sound = "invoker/descent_of_fire.ogg",
         cast_sound = "abilities/chaos_meteor.ogg",
      },
      description = [[
<b>Meteor Swarm</b>

Fire
]]
   },
   ghost_walk = {
      name = "Invisibility",
      icon = "icons/abilities/ghost_walk.png~SCALE(60,60)",
      image = "icons/abilities/ghost_walk.png",
      properties = {
         cast_type = "self",
         cast_effect = "ghost_walk",
         pre_cast_sound = "invoker/invisibility.ogg",
         cast_sound = "abilities/ghost_walk.ogg",
      },
      description = [[
<b>Invisibility</b>
]]
   },
   chaotic_offering = {
      name = "Chaotic Offering",
      icon = "icons/abilities/chaotic_offering.png~SCALE(60,60)",
      image = "icons/abilities/chaotic_offering.png",
      properties = {
         cast_type = "point_target",
         cast_range = 35,
         cast_effect = "chaotic_offering",
         pre_cast_sound = "warlock/let_chaos_reign.ogg",
         --cast_sound = "abilities/chaotic_offering.ogg",
      },
      description = [[
<b>Chaotic Offering</b>

Golems
]]
   },
   freezing_field = {
      name = "Freezing Field",
      icon = "icons/abilities/freezing_field.png~SCALE(60,60)",
      image = "icons/abilities/freezing_field.png",
      properties = {
         cast_type = "self",
         cast_effect = "null",
         cast_sound = "abilities/freezing_field.ogg",
      },
      description = [[
<b>Freezing Field</b>
]]
   },
   enrage = {
      name = "Enrage",
      icon = "icons/abilities/enrage.png~SCALE(60,60)",
      image = "icons/abilities/enrage.png",
      properties = {
         cast_type = "self",
         cast_effect = "enrage",
         cast_sound = "abilities/enrage.ogg",
      },
      description = [[
<b>Enrage</b>
]]
   },
   dash = {
      name = "Dash",
      icon = "icons/abilities/dash.png~SCALE(60,60)",
      image = "icons/abilities/dash.png",
      properties = {
         cast_type = "self",
         cast_effect = "dash",
      },
      description = [[
<b>Dash</b>

When you take the Dash action, you gain extra movement for the current turn. The increase equals your speed, after applying any modifiers.
]]
   },
   overwhelm = {
      name = "Overwhelm",
      icon = "icons/abilities/storm_hammer.png~SCALE(60,60)",
      image = "icons/abilities/storm_hammer.png",
      properties = {
         cast_type = "unit_target",
         cast_range = 5,
         cast_effect = "overwhelm",
         cast_sound = "abilities/storm_hammer.ogg",
      },
      description = [[
<b>Overwhelm</b> <i>(Recharge 6)</i>
Duration: <i>2 rounds</i>

The targeted creature must perform an athletics contest against a physical manifestation of the blade's will. On a 25 or higher, overwhelm has no effect. On a 20 or higher, overwhelm's duration is halved. On failure, the target is affected for the full duration.

For the duration, the target <b>Unconcious</b>.
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
   ground_target = function(unit, properties)
      return default_filter(unit, properties)
   end,

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

   self = function(unit, properties)
      local filter = {
         T["and"] {
            x = unit.x,
            y = unit.y,
      }}

      return filter
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
   null = function(unit, properties, target)
   end,

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

   deafening_blast = function(unit, properties, target)
      wml_actions.animate_unit {
         flag = "deafening_blast",
         T.filter {
            id = unit.id
         }
      }

      local locs = wesnoth.get_locations {
         T["and"] {
            x = unit.x,
            y = unit.y,
            radius = 2,
         },
         T["not"] {
            x = unit.x,
            y = unit.y,
         },
         T["and"] {
            T.filter {
            }
         }
      }

      local function knockback(loc)
         local target = wesnoth.get_unit(loc[1], loc[2])
         local distance = wesnoth.map.distance_between(unit.x, unit.y, target.x, target.y)
         local blast_intensity = 3 - distance
         local dir = wesnoth.map.get_relative_dir(unit.x, unit.y, target.x, target.y)
         local moveto = wesnoth.map.get_direction(target.x, target.y, dir, blast_intensity)
         wesnoth.put_unit(target, moveto[1], moveto[2])
      end

      for _, loc in ipairs(locs) do
         knockback(loc)
      end

      wml_actions.redraw {}
   end,

   sun_strike = function(unit, properties, target)
      local halo = "halo/sunburst/circle-advance-1-[4,1~5].png:[1700,500,200,100*2,200],misc/empty.png:1000"

      wml_actions.delay { time = 100 }

      local locs = wesnoth.get_locations {
         T["and"] {
            x = unit.x,
            y = unit.y,
            radius = 30,
         },
         T["not"] {
            x = unit.x,
            y = unit.y,
         },
         T["and"] {
            T.filter {
            }
         }
      }

      for _, loc in ipairs(locs) do
         wml_actions.remove_shroud {
            x = loc[1],
            y = loc[2] - 5,
         }
         items.place_halo(loc[1], loc[2] - 5, halo)
      end

      wml_actions.delay { time = 3000 }

      for _, loc in ipairs(locs) do
         items.remove(loc[1], loc[2] - 5, halo)
      end
   end,

   ghost_walk = function(unit, properties, target)
      wesnoth.erase_unit(unit)

      wml_actions.redraw {}
   end,

   chaotic_offering = function(unit, properties, target)
      local cast_sound = "abilities/chaotic_offering.ogg"

      -- XXX extra delay; should be made more generic
      wml_actions.delay { time = 1300 }

      wesnoth.play_sound(cast_sound)

      local unit = wesnoth.create_unit { type = "Infernal Golem" }
      wesnoth.put_unit(unit, target.x, target.y)
   end,

   enrage = function(unit, properties, target)
      --wesnoth.advance_unit(unit, true)
      wml_actions.modify_unit {
         T.filter {
            id = unit.id
         },
         max_experience = 1,
         experience = 1,
      }
   end,

   dash = function(unit, properties, target)
      unit.moves = unit.moves + unit.max_moves
   end,

   overwhelm = function(unit, properties, target)
      local target = wesnoth.get_unit(target.x, target.y)

      local function save()
         result = {}
         local dialog = make_dialog {
            id = "overwhelm_duration",
            label = "Overwhelm duration?",
         }
         local function postshow()
            result.duration = tonumber(wesnoth.get_dialog_value("overwhelm_duration"))
         end
         while not result.duration or result.duration < 0 or result.duration > 2 do
            wesnoth.show_dialog(dialog, function () end, postshow)
         end
         return result
      end

      local result = wesnoth.synchronize_choices("overwhelm_outcome", save, identityf({}), {gm_side})
      local duration = result[gm_side].duration

      if duration == 0 then
         return
      end

      wml_actions.petrify {
         x = target.x,
         y = target.y,
      }

      wml_actions.event {
         name = "side " .. unit.side .. " turn " .. (wesnoth.current.turn + duration),
         T.command {
            T.unpetrify {
               x = target.x,
               y = target.y,
            }
         }
      }

   end
}

return {
   abilities = abilities,
   effects = effects,
   cast_types = cast_types,
}
