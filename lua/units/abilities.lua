local initial_abilities = {
   ["Mageslayer Monk"] = {
      "blink",
      "arcane_void",
      "dash",
   },
   ["Master Sorcerer"] = {
      "chaos_meteor",
      "deafening_blast",
      "sun_strike",
      "ghost_walk",
   },
   ["Arch Warlock"] = {
      "chaotic_offering",
   },
   ["Ice Maiden"] = {
      "freezing_field",
   },
}

function wml_actions.init_abilities(cfg)
   local units = wesnoth.get_units { type = cfg.type }
   local abilities = initial_abilities[cfg.type]

   for _, unit in ipairs(units) do
      for _, ability_id in ipairs(abilities) do
         wml_actions.learn_ability {
            unit_id = unit.id,
            ability_id = ability_id,
         }
      end
   end
end
