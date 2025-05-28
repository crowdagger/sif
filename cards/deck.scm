(define-module (cards deck))
(export <deck>
        deck?
        deck-stack
        deck-hand
        deck-trash)
(import (srfi srfi-9))

;; Deck
;;
;; All cards of a player.
;;
;; Cards can be in three zones:
;; * stack
;; * hand
;; * trash
(define-record-type <deck>
  (make-deck stack hand trash)
  deck?
  (stack deck-stack)
  (hand deck-hand)
  (trash deck-trash))


