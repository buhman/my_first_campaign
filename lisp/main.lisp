(import wesnoth)
(import operator (bit-xor bit-and shl shr))

(defun shift (func n len)
  (let ((bit (bit-and n #b1))
        (rest (shr n 1))
        (len (- len 1)))
    (func bit)
    (if (= 0 len)
      nil
      (shift func rest len))))

;shift (lambda (bit) (print! (.. "bit2: " bit))) #b10101 4)

(defun shift_test (cfg)
  (let ((func (lambda (bit) (wesnoth/message "bit3" bit))))
    (shift func #b10110 5)))

(.<! wesnoth/wml_actions :shift_test shift_test)
