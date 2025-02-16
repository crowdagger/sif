(define-module (sif element))
(export <element>
        element-read id list-actions action add!)

(import (oop goops)
        (ice-9 optargs)
        (ice-9 match)
        (srfi srfi-1)
        (sif world))

;;; Generic element, should be used by about anything
(define-class <element> ()
  (world #:init-value #f
         #:init-keyword #:world
         #:getter element-world)
  (id #:init-value #f
      #:init-keyword #:id
      #:getter element-id)
  (name #:init-value ""
        #:getter name
        #:init-keyword #:name)
  (actions #:init-form (make-hash-table)
           #:getter actions)
  (description #:init-value ""
               #:getter description
               #:init-keyword #:description)
  (container #:init-value #f
             #:getter element-container
             #:init-keyword #:container)
  (inner #:init-value '()
         #:getter element-inner
         #:init-keyword #:inner)
)

;;; Adds an element to another
;;;
;;; Elements must be in the same world (duh) else bad things will happen
(define-generic add!)
(define-method (add! (e1 <element>) (e2 <element>))
  ;; First, e2 to e1
  (let* ([world (element-world e1)]
         [world2 (element-world e2)]
         [id (element-id e2)]
         [new-inner (cons id (element-inner e1))])
    (unless (eq? world world2)
      (error "Elements are from different worlds" e1 e2))
    (slot-set! e1 'inner new-inner)
    ;; Then, set e1 as the container of e2
    (let ([previous (element-container e2)])
      (slot-set! e2 'container
                 (element-id e1))
      ;; We also need to remove e2 from its previous container
      (when previous
        (let ([previous (world-ref world previous)])
          (remove! previous e2))))))

;;; Remove an element from another containing it
(define-generic remove!)
(define-method (remove! (e1 <element>) (e2 <element>))
  (let* ([world (element-world e1)]
         [world2 (element-world e2)]
         [id (element-id e2)]
         [new-list (delete id
                           (element-inner e1))])
    (unless (eq? world world2)
      (error "Elements are from different worlds" e1 e2))
    (slot-set! e1 'inner new-list)))
  
(define-method (initialize (e <element>) initargs)
  (next-method)
  ;; Add self to world and set id
  (if (element-world e)
      (slot-set! e 'id
                 (world-add! (element-world e)
                             e)))
      
  ;; Add default actions 
  (add-action e 'look-at (λ (e) (look-at e)))
  (add-action e 'add (λ (e1 e2) (add! e1 e2))))

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


(define (element-read world port)
  "Read an element from optional port"
  (match-let* ([(clss tail) (read port)])
    (let ([e (make <element> #:world world)])
      (for-each (lambda (v)
                  (slot-set! e (car v) (cdr v)))
                tail)
      e)))

(define-method (write (x <element>) . rest)
  (let* ([ctnr (if (null? (element-container x))
                   ""
                   (format #f "(container . ~a)" (element-container x)))]
         [s (format #f "(~a ((name . ~s) (description . ~s) (inner . ~a) ~a))"
                   (class-name (class-of x))
                   (name x)
                   (description x)
                   (if (null? (element-inner x))
                       "()"
                       (format #f "~s" (element-inner x)))
                   ctnr
                   )])
  (apply display (cons s rest))))

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
  (unless (element-container x)
    (message-up (element-container x)
                msg)))

(define-generic message-down)
(define-method (message-down (x <element>) msg)
  ; By default we do nothing apart from forwarding it to inner
  (display (name x))
  (display " received: ")
  (display msg)
  (newline)
  (map (λ (x) (message-down x msg))
       (element-inner x)))

;;; Command to look at object and show description.
(define-generic look-at)
(define-method (look-at (x <element>) . rest)
  (let-keywords rest #t
                ([nested #f])
                (display (name x))
                (newline)
                (when (and (not nested)
                           (not (null? (element-inner x))))
                  (display "Contains:\n")
                  (map (λ (e)
                         (display (look-at (world-ref (element-world x)
                                                      e)
                                           #:nested #t)))
                       (element-inner x)))))
                           
  
