(define-module (sif world))
(export <world>
        world-add! world-add-list! world-ref world-del!
        world->list list->world
        world-act!)
(import (oop goops)
        (ice-9 match)
        (crow-utils threading)
        (sif element)
        (crow-utils vec))

;;; Class used to store all elements.
(define-class <world> ()
  (elements #:init-form (make-vec)
            #:getter world-elements))


;; Adds an element to the world
(define (world-add! world e)
  "Add an element to the world, return its index"
  ((world-elements world) 'push! e)
  (1- ((world-elements world) 'length)))

;; Get ith element of world
(define (world-ref world i)
  "Returns the element number i of world, or #f if it has been deleted"
  ((world-elements world) 'get i))

(define (world-del! world i)
  "Deletes element i, setting it to #f"
  ((world-elements world) 'set! i #f))


(define (world->list w)
  "Converts the world w to a standard lisp list"
  (let* ([elements (->> ((world-elements w) '->list)
                       (filter (lambda (x) x))
                       (map (lambda (e) (element->list e))))])
    `(<world> ((elements . ,elements)))))

;;; Override write method
(define-method (write (w <world>) . args)
  (apply write (cons (world->list w) args)))

(define (world-add-list! world list module)
  "Transform a list to an element in given world. Also adds it to the world

Module should be set to (current-module), or any module containing all the bindings
for classes used in list"
  (match-let ([(clss tail) list])
    (let* ([clss (eval clss module)]
           [e (make clss #:world world)])
      (for-each (lambda (v)
                  (if (eq? (car v) 'id)
                      (unless (eq? (slot-ref e 'id)
                                   (cdr v))
                        (error "Element id does not match world id"
                               (cdr v)
                               (slot-ref e 'id)))

                      (slot-set! e (car v) (cdr v))))
                tail)
      e)))


(define (list->world lst module)
  "Transform a list of world to a world object, allowing deserialization

module should be set to (current-module) once you have loaded all classes
you might neeed"
  (match lst
    [(clss (('elements . elements)))
     (unless (eq? clss '<world>)
       (error "Invalid class, expected world" clss))
     (let lp ([world (make <world>)]
              [rest elements])
       (if (null? rest)
           world
          (begin
            (world-add-list! world (car rest) module)
            (lp world (cdr rest)))))]
    [else (error "Invalid list pattern for a world" lst)]))


;; Call act on all elements
(define (world-act! w)
  "Run a time step of all elements in world"
  (let ([len ((world-elements w) 'length)])
    (let lp ([i 0])
      (if (>= i len)
          #t
          (begin
            (element-act! (world-ref  w i))
            (lp (+ 1 i)))))))
