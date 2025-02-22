(define-module (sif components description))
(export <description>)
(import (oop goops)
        (ice-9 match)
        (sif object)
        (sif component))

;; Basic description component. Takes a reference to an element,
;; and describes it
;;
;; id: 'description
;;
;; Handles events :
;; * describe
(define-class <description> (<component>)
  (description #:init-value ""
               #:init-keyword #:description
               #:getter get-description))

(define-method (initialize (d <description>) initargs)
  (next-method)
  (slot-set! d 'id 'description))

(define-method (component-handle-event (d <description>) event . args)
  (match event
    ('describe
     (get-description d))
    (else
     (next-method))))

(define-method (component-list-events (d <description>) . args)
  (cons 'describe
        (next-method)))

(define-method (object->list (d <description>))
  (append (next-method)
          `(#:description ,(get-description d))))
