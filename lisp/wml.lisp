(define-native _tag :bind-to "wml.tag")
(define-native _actions :bind-to "wesnoth.wml_actions")
(define-native variables :bind-to "wml.variables")

(defun table-call (tbl name cfg)
  (with (func (.> tbl name))
    (func cfg)))

(defun tag (name cfg)
  (table-call _tag name cfg))

(defun act (name cfg)
  (table-call _actions name cfg))
