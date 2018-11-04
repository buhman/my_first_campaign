local ability_item = T.grid {
   T.row {
      -- ability_image
      T.column {
         grow_factor = 0,
         --horizontal_grow = true,
         horizontal_alignment = "center",

         border = "all",
         border_size = 1,

         T.image {
            id = "ability_icon",
            definition = "default",
            linked_group = "image",
         }
      },

      -- ability text
      T.column {
         horizontal_grow = true,
         grow_factor = 1,

         T.grid {
            T.row {
               T.column {
                  T.spacer {
                     -- XXX a little hacky
                     width = 200
                  }
               }
            },
            T.row {
               T.column {
                  border = "all",
                  border_size = 10,
                  horizontal_alignment = "left",

                  T.label {
                     id = "ability_name",
                     definition = "default",
                     linked_group = "name",
                  }
               }
            }
         }
      },

      T.column {
         T.text_box {
            id = "ability_id",
         }
      }
   }
}

local ability_list = T.listbox {
   id = "ability_list",
   horizontal_scrollbar_mode = "never",
   grow_factor = 0,

   T.list_definition {

      T.row {
         grow_factor = 1,

         T.column {
            vertical_grow = true,
            horizontal_grow = true,

            T.toggle_panel {
               definition = "default",
               return_value_id = "ok",

               ability_item
            }
         }
      }
   }
}

local ability_preview = T.grid {
   T.row {
      grow_factor = 1,

      T.column {
         grow_factor = 1,

         horizontal_alignment = "center",
         vertical_alignment = "center",

         border = "all",
         border_size = 5,

         T.image {
            id = "ability_image"
         }
      },
   },
   T.row {
      grow_factor = 0,
      horizontal_grow = false,

      T.column {
         horizontal_alignment = "left",
         grow_factor = 0,
         horizontal_grow = false,

         border = "all",
         border_size = 5,

         T.scrollbar_panel {
            T.definition {
            T.row { T.column {
            T.label {
               wrap = true,
               characters_per_line = 60,
               id = "ability_description",
            } }} }
         }
      }
   }
}

local dialog = {
   id = "ability_select",
   description = "Ability selection dialog",

   T.helptip { id = "tooltip_large" }, -- mandatory field
   T.tooltip { id = "tooltip_large" }, -- mandatory field

   definition = "default",

   default_width = 700,
   default_height = 800,

   max_height = 900,
   max_width = 900,

   T.linked_group { id = "image", fixed_width = true, fixed_height = true, },
   T.linked_group { id = "name", fixed_width = true },

   T.grid {
      -- title
      T.row {
         grow_factor = 0,

         T.column {
            grow_factor = 1,
            border = "all",
            border_size = 5,
            horizontal_alignment = "left",

            T.label {
               definition = "title",
               label = "Select Ability",
            }
         }
      },

      -- body
      T.row {
         T.column {
            horizontal_grow = true,
            vertical_grow = true,

            T.grid {
               T.row {
                  T.column {
                     grow_factor = 0,
                     horizontal_grow = true,
                     vertical_grow = true,
                     border = "all",
                     border_size = 5,

                     ability_preview
                  },

                  T.column {
                     grow_factor = 0,
                     horizontal_grow = true,
                     vertical_alignment = "top",
                     border = "all",
                     border_size = 5,

                     ability_list
                  }
               }
            }
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
                        label = "Cast",
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
