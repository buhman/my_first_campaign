local buttons = {
   attack = 2,
};

local function tab_bar(cfg)
   return T.horizontal_listbox {
      id = cfg.id,
      definition = "default",

      horizontal_scrollbar_mode = "never",
      vertical_scrollbar_mode = "never",

      T.list_definition {
         T.row {
            T.column {
               T.toggle_panel {
                  T.grid {
                     T.row {
                        T.column {
                           grow_factor = 0,
                           border = "all",
                           border_size = 5,
                           T.label {
                              id = cfg.id .. "_label",
                           }
                        }
                     }
                  }
               }
            }
         }
      }
   }
end

local function input_row(cfg)
   return T.row {
      T.column {
         grow_factor = 0,
         border = "all",
         border_size = 5,
         horizontal_alignment = "right",

         T.label {
            label = cfg.label
         }
      },
      T.column {
         grow_factor = 1,
         border = "all",
         border_size = 5,
         horizontal_grow = true,

         table.unpack(cfg)
      }
   }
end

local function input_row_text(cfg)
   return input_row {
      label = cfg.label,

      T.text_box {
         id = cfg.id,
         tooltip = cfg.tooltip,
      }
   }
end

local attack_fields = {
   input_row {
      label = "",
      tab_bar {
         id = "advantage"
      }
   },
   input_row {
      label = "multiattack",
      T.slider {
         id = "multiattack",
         minimum_value = 1,
         maximum_value = 6,
      }
   },
   input_row {
      label = "attack",
      T.grid {
         T.row {
            T.column {
               grow_factor = 1,
               T.text_box {
                  id = "attack_die",
                  tooltip = "Number of die faces on attack die; this is converted to an appropriate compound roll depending on the selected advantage type."
               }
            },
            T.column {
               border = "left,right",
               border_size = 5,
               T.label {
                  label = "+",
               }
            },
            T.column {
               grow_factor = 4,
               T.text_box {
                  id = "attack_mod"
               }
            }
         }
      }
   },
   input_row {
      label = "damage",
      T.grid {
         T.row {
            T.column {
               grow_factor = 2,
               T.spacer {
                  width = 50
               }
            },
            T.column {
               grow_factor = 0,
               T.spacer {
               }
            },
            T.column {
               grow_factor = 1,
               T.spacer {
               }
            }
         },
         T.row {
            T.column {
               horizontal_grow = true,
               T.text_box {
                  id = "damage_dice",
                  tooltip = "Dice that get re-rolled and summed on a critical hit",
               }
            },
            T.column {
               border = "left,right",
               border_size = 5,
               T.label {
                  label = "+",
               }
            },
            T.column {
               T.text_box {
                  id = "damage_mod"
               }
            },
         }
      }
   },
   input_row_text {
      id = "extra",
      label = "extra",
      tooltip = "Convenience field for on-hit effects like <i>Critical of the Corrupted Soul</i> and <i>Bash of the Abyss</i>."
   },
}

local preset_body = T.grid {
   table.unpack(attack_fields),
   --[[
   T.row {
      grow_factor = 1,
      T.column {
         horizontal_grow = true,
         vertical_alignment = "center",


      }
   }
   ]]--
}

local attack_page = T.page_definition {
   id = "attack_page",
   definition = "default",

   T.row {
      grow_factor = 0,
      T.column {
         vertical_alignment = "top",
         border_size = 5,
         border = "all",

         T.grid {
            T.row {
               T.column {
                  tab_bar {
                     id = "preset_tabs"
                  }
               },
               T.column {
                  border_size = 5,
                  border = "left",
                  T.button {
                     id = "create_profile",
                     definition = "add_transparent",
                     tooltip = "Create new attack profile",
                  }
               },
               T.column {
                  border_size = 5,
                  border = "left",
                  T.button {
                     id = "delete_profile",
                     definition = "delete_transparent",
                     tooltip = "Delete selected attack profile",
                  }
               }
            }
         }
      }
   },
   T.row {
      grow_factor = 1,
      T.column {
         vertical_alignment = "center",
         border_size = 5,
         border = "all",

         preset_body,
      }
   },
   T.row {
      grow_factor = 0,
      T.column {
         vertical_alignment = "bottom",

         T.grid {
            T.row {
               T.column {
                  grow_factor = 1,
                  border = "all",
                  border_size = 5,

                  T.button {
                     id = "save_profile",
                     label = "Save",
                     tooltip = "Store displayed values in selected profile",
                  }
               },

               T.column {
                  grow_factor = 1,
                  T.spacer {
                     width = 50,
                  }
               },

               T.column {
                  grow_factor = 1,
                  border = "all",
                  border_size = 5,

                  T.button {
                     label = "Attack!",
                     return_value = buttons.attack,
                  }
               }
            }
         }
      }
   }
}

return {
   page_definition = attack_page,
   buttons = buttons,
}
