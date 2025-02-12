(define-module (sif element))
(export <element>
        list-actions action add)

(import (oop goops)
        (ice-9 optargs)
        (ice-9 match)
        (srfi srfi-1))

(define-class <element> ()
  (name #:init-value ""
        #:getter name
        #:init-keyword #:name)
  (actions #:init-form (make-hash-table)
           #:getter actions)
  (description #:init-value ""
               #:getter description
               #:init-keyword #:description)
  (container #:init-value '()
             #:getter container
             #:init-keyword #:container)
  (inner #:init-value '()
         #:getter inner
         #:init-keyword #:inner)
)

;;; List all valid actions for an element
(define-generic list-actions)
(define-method (list-actions (e <element>))
  (hash-map->list (lambda (action _) action)
                  (actions e)))

;;; Perform the action on element
(define-generic action)
(define-method (action (e <element>) action . args)
  (unless (symbol? action)
    (error "Must be a symbol" action))
  (let ([handler (hashq-ref (actions e) action)])
    (when (eq? #f handler)
      (error "Unsupported action" action))
    (apply handler (cons e args))))

(define-method (initialize (e <element>) initargs)
  (next-method)
  ;; Add default actions 
  (add-action e 'look-at (λ (e) (look-at e)))
  (add-action e 'add (λ (e1 e2) (add e1 e2))))

;;; Adds an action to an element.
;;; Hander must be of the form (lambda (element . args))
(define-generic add-action)
(define-method (add-action (x <element>) symbol handler)
  (unless (symbol? symbol)
    (error "Must be a symbol" symbol))
  (unless (procedure? handler)
    (error "Must be a procedure" handler))
  (hashq-set! (actions x) symbol handler))

(define-generic message-up)
(define-method (message-up (x <element>) msg)
  (unless (nil? (container x))
    (message-up (container x)
                msg)))

(define-generic message-down)
(define-method (message-down (x <element>) msg)
  ; By default we do nothing apart from forwarding it to inner
  (display (name x))
  (display " received: ")
  (display msg)
  (newline)
  (map (λ (x) (message-down x msg))
       (inner x)))

(define-generic add)
(define-method (add (x <element>) (y <element>))
  ;; Add y to x's inner
  (slot-set! x
             'inner
             (cons y (inner x)))
  (let ([previous (container y)])
    (unless (nil? previous)
      (slot-set! previous
                 'inner
                 (delete y (inner previous)))))
  ;; Set x as y's container
  (slot-set! y 'container x))

;;; Command to look at object and show description.
(define-generic look-at)
(define-method (look-at (x <element>) . rest)
  (let-keywords rest #t
                ([nested #f])
                (display (name x))
                (newline)
                (when (and (not nested)
                           (not (null? (inner x))))
                  (display "Contains:\n")
                  (map (λ (e)
                         (display (look-at e #:nested #t)))
                       (inner x)))))
                           
  
