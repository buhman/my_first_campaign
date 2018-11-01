local side_list = T.listbox {
   id = "side_list",

   T.list_definition {
      T.row {
         grow_factor = 1,

         T.column {
            T.toggle_panel {
               T.grid {
                  T.row {
                     T.column {
                        border = "all",
                        border_size = 5,

                        T.label {
                           id = "side_number",
                        }
                     },
                     T.column {
                        border = "all",
                        border_size = 5,

                        T.label {
                           id = "side_name",
                        }
                     }
                  }
               }
            }
         }
      }
   }
}

local dialog = {
   T.tooltip { id = "tooltip_large" },
   T.helptip { id = "tooltip_large" },
   T.grid {
      T.row {
         grow_factor = 1,

         T.column {
            side_list
         }
      },
   }
}

return dialog
