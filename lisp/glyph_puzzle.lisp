(import data/struct (defstruct))
(import operator (bit-and bit-not bit-xor shr shl pow))
(import core/string (ends-with?))

(import wesnoth)
(import wml)

(define colors '("red" "green" "blue"))
(define glyph-len 4)
(define glyph-mask (- (pow 2 glyph-len) 1))

(define lever-ops
  (list (lambda (n) (bit-xor n 1))
        (lambda (n) (bit-and (shl n 1) glyph-mask))
        (lambda (n) (bit-xor n glyph-mask))))

(defstruct state
  (fields (mutable levers)
          (mutable current)
          (mutable expected)
          (mutable enabled)))

(define state (make-state))

;; more bit stuff

(defun bit-difference (a b)
  "4-bit xnor"
  (bit-and (bit-not (bit-xor a b)) glyph-mask))

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

;; puzzle state update

(defun puzzle-solved? (current expected)
  (if (= current expected)
    (progn
      (wesnoth/play-sound "effects/secret.ogg")
      (wml/act :glyph_puzzle_complete nil)
      true)
    nil))

(defun update-glyphs! (idx)
  (let ((current (state-current state))
        (expected (state-expected state)))
    (let* ((func (nth lever-ops idx))
           (new-current (func current)))
      (set-state-current! state new-current)
      (draw-glyphs! new-current expected)
      (puzzle-solved? new-current expected))))

;; event handlers

(defun new-puzzle! (&cfg)
  (let ((levers (list nil nil nil))
        (current (wesnoth/random 0 15))
        (expected (wesnoth/random 0 15)))
    (set-state-levers! state levers)
    (set-state-current! state current)
    (set-state-expected! state expected)
    (draw-levers! levers)
    (draw-glyphs! current expected)))

(defun toggle-lever! (cfg)
  (if (state-enabled state)
    (let* ((idx (.> cfg :lever_id))
           (levers (state-levers state))
           (toggle (not (nth levers idx))))
      (setq! (nth levers idx) toggle)
      (draw-lever! levers idx)
      (update-glyphs! idx))
    (wesnoth/message "[lever]" "You attempt to move the lever, but find it is stuck"))
  (wesnoth/end-turn))

(defun light-glyphs! ()
  (wml/act :remove_shroud
    {:x 22 :y 22 :radius 2})
  (wml/act :remove_shroud
    {:x 25 :y 22 :radius 1})
  (wml/act :lift_fog
    {:x 23 :y 23 :radius 3 :multiturn true}))

(defun unlight-glyphs! ()
  (wml/act :place_shroud
    {:x 22 :y 22 :radius 2})
  (wml/act :place_shroud
    {:x 25 :y 22 :radius 1})
  (wml/act :reset_fog
    {:x 23 :y 23 :radius 3}))

(defun toggle-enable! (cfg)
  (let* ((enabled (.> cfg :condition)))
    (set-state-enabled! state enabled)
    (if enabled
      (progn
        (new-puzzle!)
        (light-glyphs!))
      (progn
        (unlight-glyphs!)
        (init-draw!)))))

(defun init-draw! (&cfg)
  (draw-levers! (list nil nil nil))
  (draw-glyphs! 0 15))

(.<! wesnoth/wml_actions :glyph_puzzle_init init-draw!)
(.<! wesnoth/wml_actions :glyph_toggle_lever toggle-lever!)
(.<! wesnoth/wml_actions :glyph_toggle_enable toggle-enable!)
