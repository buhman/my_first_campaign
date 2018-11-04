local unit_list = T.listbox {
   id = "unit_list",
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
                        grow_factor = 0,
                        horizontal_alignment = "left",
                        border = "all",
                        border_size = 5,
                        T.label {
                           id = "list_race",
                           linked_group = "race"
                        }
                     },

                     T.column {
                        grow_factor = 1,
                        horizontal_alignment = "left",
                        border = "all",
                        border_size = 5,
                        T.label {
                           id = "list_name",
                           linked_group = "name"
                        }
                     },

                     T.column {
                        T.text_box {
                           id = "list_id",
                        }
                     }
                  }
               }
            }
         }
      }
   }
}

local right_pane = T.grid {
   T.row {
      T.column {
         grow_factor = 0,
         horizontal_grow = true,
         vertical_grow = true,
         border = "all",
         border_size = 5,

         T.unit_preview_pane {
            definition = "default",
            id = "place_details",
         }
      },

      T.column {
         grow_factor = 1,
         horizontal_grow = true,
         vertical_alignment = "top",
         border = "all",
         border_size = 5,

         unit_list
      }
   }
}

local dialog = {
   id = "unit_placement",
   description = "Unit placement dialog",

   maximum_height = 500,
   maximum_width = 650,

   T.helptip { id = "tooltip_large" }, -- mandatory field
   T.tooltip { id = "tooltip_large" }, -- mandatory field

   T.linked_group { id = "race", fixed_width = true },
   T.linked_group { id = "name", fixed_width = true },

   T.grid {
      T.row {
         grow_factor = 1,
         T.column {
            T.spacer {
               width = 600 -- Force a minimum width since min_width doesn't work
            }
         }
      },

      T.row {
         grow_factor = 1,
         T.column {
            border = "all",
            border_size = 5,
            horizontal_alignment = "left",
            T.label {
               definition = "title",
               id = "title",
               label = "Place unit"
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
            right_pane
         }
      },
   }
}

return dialog
