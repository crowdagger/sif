(define-module (sif object))
(export <sif-object>
        object->list
        list->object)
(import (oop goops)
        (ice-9 match))

;; Base class used by everything in sif.
;;
;; Essentially provides serialization and deserialization
(define-class <sif-object> ())

;; Method to serialize an object into a list, that can then
;; be saved to a file. This method must be completed by every class.
(define-generic object->list)
(define-method (object->list (obj <sif-object>))
  (list (class-name (class-of obj))))

;; Function to deserialize a list into an object. Unlike its counterpart,
;; it does not need to be completed by class that inherit <sif-object>,
;; provided their `initialize` method appropriatety sets the object.
;;
;; module should be set to (current-module) once you have loaded all classes
;; you might neeed
(define (list->object lst module)
  (match lst
    [(clss . options)
     (let ([clss (eval clss module)])
       (apply make (cons clss options)))]
    [else
     (error "Invalid argument for list->object" lst)]))
