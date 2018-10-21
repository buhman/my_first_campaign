(import data/struct (defstruct))
(import operator (bit-and bit-not bit-xor shr shl))

(import wesnoth)
(import wml)

(define colors '("red" "green" "blue"))
(define glyph-len 4)

(define lever-ops
  (list (lambda (n) (bit-xor n 1))
        (lambda (n) (bit-and (shl n 1) #b1111))
        (lambda (n) (bit-xor n #b1111))))

(defstruct state
  (fields (mutable levers)
          (mutable current)
          (mutable expected)))

(define state (make-state))

;; more bit stuff

(defun bit-difference (a b)
  "4-bit xnor"
  (bit-and (bit-not (bit-xor a b)) #b1111))

(defun bit-each (func n len)
  (let ((state (= 1 (bit-and n 1)))
        (rest (shr n 1))
        (len (- len 1)))
    (func state len)
    (if (= 0 len)
      nil
      (bit-each func rest len))))

;; lever drawing

(defun lever-image (active pos)
  (let ((variant (if active "active" "inactive"))
        (color (nth colors pos)))
    (.. "items/lever_" variant ".png~RC(magenta>" color ")")))

(defun draw-lever! (levers pos)
  (let* ((active (nth levers pos))
         (new-image (lever-image active pos))
         (location-id (.. "lever" pos)))
    (wml/act :remove_item
      {:location_id location-id})
    (wml/act :item
      {:location_id location-id
       :image new-image})))

(defun draw-levers! (levers)
  (map (lambda (p) (draw-lever! levers p)) '(1 2 3)))

;; glyph drawing

(defun glyph-image (active)
  (let ((color (if active "" "~RC(magenta>black)")))
    (.. "items/glyph.png" color)))

(defun draw-glyph! (active pos)
  (let ((new-image (glyph-image active))
        (location-id (.. "light" pos)))
  (wml/act :remove_item
    {:location_id location-id})
  (wml/act :item
    {:location_id location-id
     :image new-image})))

(defun draw-glyphs! (current expected)
  (let ((dt (bit-difference current expected))
        (len glyph-len))
    (bit-each (lambda (a p) (draw-glyph! a (- len p))) dt len)))

;; init

(defun new-puzzle! (cfg)
  (let ((levers (list true true nil))
        (current (wesnoth/random 0 15))
        (expected (wesnoth/random 0 15)))
    (set-state-levers! state levers)
    (set-state-current! state current)
    (set-state-expected! state expected)
    (draw-levers! levers)
    (draw-glyphs! current expected)))

;; exports

(.<! wesnoth/wml_actions :glyph_new_puzzle new-puzzle!)

(defun update-glyphs! (idx)
  (let ((current (state-current state))
        (expected (state-expected state)))
    (let* ((func (nth lever-ops idx))
           (new-current (func current)))
      (set-state-current! state new-current)
      (draw-glyphs! new-current expected))))

(defun toggle-lever (cfg)
  (let* ((idx (.> cfg :lever_id))
         (levers (state-levers state))
         (toggle (not (nth levers idx))))
    (setq! (nth levers idx) toggle)
    (draw-lever! levers idx)
    (update-glyphs! idx)))

(.<! wesnoth/wml_actions :glyph_toggle_lever toggle-lever)
