function wml_actions.pop_unit(cfg)
   for _, unit in ipairs(wesnoth.get_recall_units {}) do
      wesnoth.put_unit(unit, cfg.x, cfg.y)
      return
   end
end
