function wml_actions.init_monk_abilities(cfg)
   local units = wesnoth.get_units { type = "Mageslayer Monk" }
   local abilities = { "blink", "arcane_void" }

   for _, unit in ipairs(units) do
      for _, ability_id in ipairs(abilities) do
         wml_actions.learn_ability {
            unit_id = unit.id,
            ability_id = ability_id,
         }
      end
   end
end
