local my_dialog = {
   T.tooltip { id = "tooltip_large" },
   T.helptip { id = "tooltip_large" },
   T.grid {
      T.row {
         T.column {
            T.text_box { id = "test_inp", label = _ "", history = "test_inp" }
         }
      },
   }
}

return my_dialog;
