(define-module (sif world))
(export <world>
        world-add! world-add-list! world-ref world-del!
        world->list list->world)
(import (oop goops)
        (ice-9 match)
        (crow-utils threading)
        (crow-utils vec)
        (sif element)
        (sif agent)
        (sif room))

;;; Class used to store all elements.
(define-class <world> ()
  (elements #:init-form (make-vec)
            #:getter world-elements))


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


(define (world->list w)
  "Converts the world w to a standard lisp list"
  (let* ([elements (->> ((world-elements w) '->list)
                       (filter (lambda (x) x))
                       (map (lambda (e) (element->list e))))])
    `(<world> ((elements . ,elements)))))

;;; Override write method
(define-method (write (w <world>) . args)
  (apply write (cons (world->list w) args)))

(define (world-add-list! world list)
  "Transform a list to an element in given world.
Also adds it to the world"
  (match-let ([(clss tail) list])
    (let ([e (cond
              [(eq? clss '<element>) (make <element> #:world world)]
              [(eq? clss '<room>) (make <room> #:world world)]
              [(eq? clss '<agent>) (make <agent> #:world world)]
              [else (error "Invalid class" clss)])])
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


(define (list->world lst)
  "Transform a list of world to a world object, allowing deserialization"
  (match lst
    [(clss (('elements . elements))) 
     (unless (eq? clss '<world>)
       (error "Invalid class, expected world" clss))
     (let lp ([world (make <world>)]
              [rest elements])
       (if (null? rest)
           world
          (begin
            (world-add-list! world (car rest))
            (lp world (cdr rest)))))]
    [else (error "Invalid list pattern for a world" lst)]))
