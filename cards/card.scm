(define-module (cards card)
  #:use-module (srfi srfi-9)
  #:export (<card>
        make-card
        card?
        card-satisfies?
        card-color
        card-value
        card-name)
  )

;; Basic card
;;
;; Color is a list of colors. Typical colors:
;; * red/heart: heal/empathy
;; * blue/club: (blunt) offense
;; * black/spade: (pierce) offense
;; * yellow/diamond: defense
;;
;; A card might have more than one color
(define-record-type <card>
  (make-card% color value name)
  card?
  (color card-color)
  (value card-value)
  (name card-name))


;; Method used to create a card
(define* (make-card color value #:optional (name #f))
  ;; Set default name if name is not set
  (let ([name (if name
                  name
                  (format #f "~a of ~a"
                          color
                          value))])
    (make-card% color value name)))

(define (card-satisfies? card color value)
  "Returns #t if a card satifies both color and value conditions, #f else

* color must be a (possibly empty) list of colors
* value must be a number. All cards satisfy a value of 0

"
  (unless (and (card? card)
               (list? color)
               (number? value))
    (error "Invalid arguments to card-satisfies?, expected card color value" card color value))
  (and
   (card-satisfies-color? card color)
   (>= (card-value card) value)))
  
(define (card-satisfies-color? card color)
  (if (null? color)
      #t
      (and (memq (car color)
                 (card-color card))
           (card-satisfies-color? card (cdr color)))))


;; Redefines how cards are displayed
(define (color->string color)
  "Transform a color as a quoted name to some string"
  (case color
    ([heart] "♥")
    ([spade] "♠")
    ([diamond] "♦")
    ([club] "♣")
    (else (error "Invalid color" color))))

(define (format-card-color color)
  "Transform a list of colors to a concise string"
  (if (null? color)
      ""
      (format #f "~a~a"
              (color->string (car color))
              (format-card-color (cdr color)))))

;; (set-record-type-printer! <card>
;;                      (lambda (record port)
;;                        (format port "~a~a"
;;                                (format-card-color (card-color record))
;;                                (card-value record))))


(define c (make-card '(heart club) 3))
;(display c)
