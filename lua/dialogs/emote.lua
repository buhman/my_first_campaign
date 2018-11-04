local emote_list = T.listbox {
   id = "emote_list",
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
                           id = "emote_name",
                           linked_group = "name"
                        }
                     },
                  }
               }
            }
         }
      }
   }
}

local dialog = {
   id = "character_emote",
   description = "Character Emote",

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
               label = "Character emote"
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
            emote_list
         }
      },

            -- confirmation
      T.row {
         grow_factor = 0,

         T.column {
            grow_factor = 0,
            horizontal_grow = true,

            T.grid {
               T.row {
                  T.column {
                     grow_factor = 1,
                     horizontal_alignment = "left",
                     T.spacer {
                     }
                  },
                  T.column {
                     grow_factor = 0,
                     border = "all",
                     border_size = 5,
                     horizontal_alignment = "right",

                     T.button {
                        id = "ok",
                        definition = "default",
                        label = "Emote",
                     }
                  },

                  T.column {
                     grow_factor = 0,
                     border = "all",
                     border_size = 5,
                     horizontal_alignment = "right",

                     T.button {
                        id = "cancel",
                        definition = "default",
                        label = "Cancel",
                     }
                  }
               }
            }
         }
      }
   }
}

return dialog
