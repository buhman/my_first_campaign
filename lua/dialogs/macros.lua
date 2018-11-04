local attack_page = require "dialogs/macros/attack_page"

local macro_list = T.listbox {
   id = "macro_list",
   definition = "default",

   horizontal_scrollbar_mode = "never",
   vertical_scrollbar_mode = "always",

   T.list_definition {
      T.row {
         T.column {
            vertical_grow = true,
            horizontal_grow = true,

            T.toggle_panel {
               T.grid {
                  T.row {
                     grow_factor = 0,

                     T.column {
                        grow_factor = 0,
                        horizontal_alignment = "left",
                        border = "all",
                        border_size = 10,
                        T.label {
                           id = "macro_name",
                        }
                     },
                  }
               }
            }
         }
      }
   }
}

-- XXX: dead code
local test_page = T.page_definition {
   id = "test_page",
   definition = "default",

   T.row {
      grow_factor = 1,

      T.column {
         border = "all",
         border_size = 5,
         horizontal_grow = true,
         vertical_grow = true,

         T.label {
            id = "test_label",
         }
      }
   }
}

local macro_pages = T.multi_page {
   id = "macro_pages",

   attack_page.page_definition,
}

local dialog = {
   id = "macro_dialog",

   --T.resolution {
      definition = "default",

      automatic_placement = false,

      width = "(min(screen_width, 550))",
      height = "(min(screen_height, 500))",

      x = "(floor((screen_width  - window_width)  / 2))",
      y = "(floor((screen_height - window_height) / 2))",

      T.tooltip {
         id = "tooltip",
      },
      T.helptip {
         id = "tooltip",
      },

      T.grid {
         T.row {
            grow_factor = 0,

            T.column {
               border = "all",
               border_size = 5,
               horizontal_alignment = "left",

               T.label {
                  definition = "title",
                  label = "Macros",
               }
            }
         },

         T.row {
            grow_factor = 1,

            T.column {
               horizontal_grow = true,
               vertical_grow = true,

               T.grid {
                  T.row {
                     horizontal_grow = true,
                     vertical_grow = true,

                     T.column {
                        grow_factor = 2,
                        border = "all",
                        border_size = 5,
                        horizontal_alignment = "left",

                        vertical_alignment = "top",

                        macro_list,
                     },

                     T.column {
                        grow_factor = 1,
                        border = "all",
                        border_size = 5,

                        vertical_grow = true,

                        macro_pages,
                     }
                  }
               }
            }
         },

         T.row {
            T.column {
               grow_factor = 0,
               border = "all",
               border_size = 5,
               horizontal_alignment = "right",

               T.button {
                  id = "cancel",
                  label = "Close",
               }
            }
         }
      }
   --}
}

return dialog
