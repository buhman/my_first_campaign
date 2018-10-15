local scenario_list = T.listbox {
   id = "scenario_list",
   horizontal_scrollbar_mode = "never",

   T.list_definition {
      T.row {
         T.column {
            vertical_grow = true,
            horizontal_grow = true,

            T.toggle_panel {
               T.grid {
                  T.row {
                     grow_factor = 1,

                     T.column {
                        grow_factor = 1,
                        horizontal_alignment = "left",
                        border = "all",
                        border_size = 5,
                        T.label {
                           id = "scenario_name",
                           linked_group = "name"
                        }
                     },

                     T.column {
                        T.text_box {
                           id = "scenario_id",
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
   id = "change_scenario",
   description = "Scenario change dialog",

   maximum_height = 500,
   --maximum_width = 650,

   T.helptip { id = "tooltip_large" }, -- mandatory field
   T.tooltip { id = "tooltip_large" }, -- mandatory field

   T.linked_group { id = "name", fixed_width = true },

   T.grid {

      T.row {
         grow_factor = 1,
         T.column {
            border = "all",
            border_size = 5,
            horizontal_alignment = "left",
            T.label {
               definition = "title",
               id = "title",
               label = _ "Change scenario"
            }
         }
      },

      T.row {
         grow_factor = 1,
         T.column {
            grow_factor = 1,
            border = "all",
            border_size = 5,
            horizontal_grow = true,
            vertical_grow = true,

            --
            scenario_list
         }
      },
   }
}

return dialog
