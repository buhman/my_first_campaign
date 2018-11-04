local function result_header(cfg)
   return T.column {
      grow_factor = 1,
      horizontal_grow = true,
      border = "all",
      border_size = 5,

      T.toggle_button {
         id = cfg.id .. "_sort",
         definition = "listbox_header",
         linked_group = cfg.id .. "_group",
         label = cfg.label,
      }
   }
end

local function result_column(cfg)
   return T.column {
      grow_factor = 1,
      horizontal_grow = true,
      border = "all",
      border_size = 5,

      T.label {
         id = cfg.id,
         definition = "default_small",
         linked_group = cfg.id .. "_group",
         use_markup = true,
         tooltip = cfg.tooltip,
      }
   }
end

local function result_image_column(cfg)
   return T.column {
      grow_factor = 1,
      horizontal_grow = true,

      border = "all",
      border_size = 5,

      T.grid {
         linked_group = cfg.id .. "_group",

         T.row {
            T.column {
               grow_factor = 0,
               horizontal_alignment = "left",

               T.image {
                  id = cfg.id .. "_image",
                  definition = "default",
                  linked_group = cfg.id .. "_image_group",
               }
            },
            T.column {
               grow_factor = 1,
               horizontal_grow = true,

               T.label {
                  id = cfg.id,
                  definition = "default",
                  use_markup = true,
               }
            }
         }
      }
   }
end

local gm_extra_headers = {
   result_header {
      id = "outcome",
      label = "Outcome?",
   }
}

local gm_extra_columns = {
   T.column {
      grow_factor = 1,
      horizontal_grow = true,
      border = "all",
      border_size = 5,

      T.slider {
         id = "outcome",
         minimum_value = -1,
         maximum_value = 1,
         minimum_value_label = "miss",
         maximum_value_label = "hit",

         best_slider_length = 50,

         linked_group = "outcome" .. "_group",
      }
   }
}

local function result_list(cfg)
   return T.listbox {
      id = "attack_result_list",
      definition = "default",

      T.header {
         T.row {
            result_header {
               id = "character",
               label = "Character",
            },
            result_header {
               id = "attack",
               label = "Attack",
            },
            result_header {
               id = "damage",
               label = "Damage",
            },
            result_header {
               id = "extra",
               label = "Extra",
            },
            table.unpack(cfg.extra_headers and cfg.extra_headers or {}),
         }
      },

      T.list_definition {
         T.row {
            T.column {
               vertical_grow = true,
               horizontal_grow = true,

               T.toggle_panel {
                  definition = "default",
                  return_value_id = "ok",

                  T.grid {
                     T.row {
                        result_image_column {
                           id = "character",
                        },
                        result_column {
                           id = "attack",
                           tooltip = cfg.tooltips.attack,
                        },
                        result_column {
                           id = "damage",
                           tooltip = cfg.tooltips.damage,
                        },
                        result_column {
                           id = "extra",
                           tooltip = cfg.tooltips.extra,
                        },
                        table.unpack(cfg.extra_columns and cfg.extra_columns or {}),
                     }
                  }
               }
            }
         }
      }
   }
end

local function fixed_width_group(cfg)
   return T.linked_group {
      id = cfg.id .. "_group",
      fixed_width = true,
   }
end

-- set_tooltip isn't exposed; luckily we don't need unique tooltips per row
local make_dialog = function(cfg)
   return {
      id = "attack_page_results",
      description = "attack outcome",

      definition = "default",
      automatic_placement = true,
      vertical_placement = "center",
      horizontal_placement = "center",
      --maximum_height = 750,

      T.linked_group {
         id = "character_image_group",
         fixed_height = true,
         fixed_width = true,
      },
      fixed_width_group {
         id = "character",
      },
      fixed_width_group {
         id = "attack",
      },
      fixed_width_group {
         id = "damage",
      },
      fixed_width_group {
         id = "extra",
      },
      fixed_width_group {
         id = "outcome",
      },

      T.tooltip {
         id = "tooltip",
      },
      T.helptip {
         id = "tooltip",
      },

      -- such gui, much wow
      T.grid {
         T.row {
            T.column {
               T.spacer {
                  -- XXX why is everything so broken?
                  width = 500,
               }
            }
         },
         T.row {
            grow_factor = 0,

            T.column {
               grow_factor = 1,
               border = "all",
               border_size = 5,
               horizontal_grow = true,

               T.label {
                  definition = "title",
                  label = _ "Attack Outcome",
                  id = "title",
               }
            }
         },

         T.row {
            grow_factor = 1,

            T.column {
               grow_factor = 1,
               horizontal_grow = true,
               vertical_grow = true,
               border = "all",
               border_size = 5,

               result_list {
                  tooltips = cfg.tooltips,
                  extra_columns = cfg.extra_columns,
                  extra_headers = cfg.extra_headers,
               },
            }
         },

         T.row {
            grow_factor = 0,

            T.column {
               grow_factor = 0,
               horizontal_alignment = "right",
               border = "all",
               border_size = 5,

               T.button {
                  id = "cancel",
                  definition = "default",
                  label = _ "Close",
               }
            }
         }
      }
   }
end

return {
   make_dialog = make_dialog,
   gm_columns = gm_extra_columns,
   gm_headers = gm_extra_headers,
}
