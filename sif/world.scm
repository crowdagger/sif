(define-module (sif world))
(export <world>
        world-add! world-ref world-del!)
(import (oop goops)
        (crow-utils vec)
        (sif element))

;;; Class used to store all elements.
(define-class <world> ()
  (elements #:init-form (make-vec)
            #:getter world-elements))

(define (world->list w)
  "Converts the world w to a standard lisp list"
  (let* ([elements (map (λ (e)
                         (element->list e))
                        ((world-elements w) '->list))])
    `(<world> ((elements . ,elements)))))

(define-method (write (w <world>) . args)
  (apply write (cons (world->list w) args)))
  ;; (let* ([elements (map (λ (e)
  ;;                        (format #f "~a" e))
  ;;                       ((world-elements w) '->list))]
  ;;       [elements (apply string-append elements)]
  ;;       [s (format #f "(<world> ((elements . ~a)))"
  ;;                  elements)])
  ;;   (apply write (cons s args))))

(define (world-add! world e)
  "Add an element to the world, return its index"
  ((world-elements world) 'push! e)
  (1- ((world-elements world) 'length)))

(define (world-ref world i)
  "Returns the element number i of world, or #f if it has been deleted"
  ((world-elements world) 'get i))

(define (world-del! world i)
  "Deletes element i, setting it to #f"
  ((world-elements world) 'set! i #f))

(define w (make <world>))
(world-add! w 42)
(display (world-ref w 0))
(world-del! w 0)
(display (world-ref w 0))

