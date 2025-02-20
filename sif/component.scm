(define-module (sif component))
(export <component>
        component-handle-event
        component-list-events)
(import (oop goops)
        (ice-9 match)
        (sif object))


;; Component that can be added to any elements.
;;
;; A component handles events, and must thus implement the
;; generic functions component-handle-event and component-list-events
;;
;; A component is thus quite similar to an interface and shall often be named stull-able
(define-class <component> (<sif-object>)
  (id #:init-value 'component
      #:init-keyword #:id
      #:getter component-id))

;; Handle a given event. Returns #f is event is not handled
(define-generic component-handle-event)

;; Return a list of supported events
(define-generic component-list-events)

;; The basic methods don't do much, a component implementation must
;; override them
(define-method (component-handle-event (component <component>) event args)
  #f)

(define-method (component-list-events (component <component>) args)
  '())


