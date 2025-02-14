(define-module (sif world))
(export <world>
        world-add! world-ref world-del!)
(import (oop goops)
        (crow-utils vec))

;;; Class used to store all elements.
(define-class <world> ()
  (elements #:init-form (make-vec)
            #:getter elements))

(define (world-add! world e)
  "Add an element to the world, return its index"
  ((elements world) 'push! e)
  (1- ((elements world) 'length)))

(define (world-ref world i)
  "Returns the element number i of world, or #f if it has been deleted"
  ((elements world) 'get i))

(define (world-del! world i)
  "Deletes element i, setting it to #f"
  ((elements world) 'set! i #f))

(define w (make <world>))
(world-add! w 42)
(display (world-ref w 0))
(world-del! w 0)
(display (world-ref w 0))

