function make_dialog(cfg)
   return {
      T.tooltip { id = "tooltip_large" },
      T.helptip { id = "tooltip_large" },
      T.grid {
         T.row {
            grow_factor = 0,

            T.column {
               grow_factor = 1,
               border = "all",
               border_size = 5,
               horizontal_alignment = "left",

               T.label {
                  id = "title",
                  definition = "title",
                  label = cfg.label,
               }
            }
         },
         T.row {
            grow_factor = 1,

            T.column {
               horizontal_grow = true,
               vertical_grow = true,
               border = "all",
               border_size = 5,
               T.text_box { id = cfg.id, label = _ "", history = cfg.id }
            }
         }
      }
   }
end

return {
   make_dialog = make_dialog
}
