local dialog = {
   T.tooltip { id = "tooltip_large" },
   T.helptip { id = "tooltip_large" },
   T.grid {
      T.row {
         T.column {
            T.text_box { id = "eval_input", label = _ "", history = "eval_input" }
         }
      },
   }
}

return dialog
