local mana_per_xp = 5

local unit_mana = {
   ["Ice Maiden"] = 20,
   ["Master Sorcerer"] = 20,
   ["Ascendant Sorcerer"] = 30,
   ["Wind Ranger"] = 4,
   ["Arch Warlock"] = 15,
   ["Custom Dark Sorcerer"] = 5,
   ["Elvish Centaur"] = 9,
}

local function unit_init(unit)
   if unit_mana[unit.type] == nil then
      return
   end
   local xp = unit_mana[unit.type] * mana_per_xp

   wml_actions.modify_unit {
      T.filter {
         x = unit.x,
         y = unit.y,
      },
      hitpoints = xp,
      max_hitpoints = xp
   }
end

function wml_actions.mana_unit_init(cfg)
   local units = wesnoth.get_units { id = cfg.unit_id }
   unit_init(units[1])
end

function wml_actions.mana_remove(cfg)
   local unit = wesnoth.get_unit(cfg.x, cfg.y)
   local subtract = cfg.value * mana_per_xp
   local new_hp = unit.hitpoints - subtract
   if new_hp <= 0 then
      new_hp = 1
   end

   wml_actions.modify_unit {
      T.filter {
         x = unit.x,
         y = unit.y,
      },
      hitpoints = new_hp
   }
end

return {
   unit_init = unit_init
}
