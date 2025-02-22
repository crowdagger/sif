(define-module (sif component))
(export <component>
        component-handle-event
        component-list-events
        component-world
        component-set-world!
        component-owner
        component-set-owner!)
(import (oop goops)
        (ice-9 match)
        (sif object))


;; Component that can be added to any elements.
;;
;; A component handles events, and must thus implement the
;; generic functions component-handle-event and component-list-events
;;
;; A component is thus quite similar to an interface and shall often be named stull-able
;;
;; Different components may handle the same event: this is particularly the case
;, for 'tick, which updates a component (if needed) every turn.
(define-class <component> (<sif-object>)
  (id #:init-value 'component
      #:init-keyword #:id
      #:getter component-id)
  (world #:init-value #f
         #:init-keyword #:world
         #:getter component-world
         #:setter component-set-world!)
  (owner #:init-value #f
         #:init-keyword #:world
         #:getter component-owner
         #:setter component-set-owner!)
  )

;; Handle a given event. Returns #f is event is not handled
(define-generic component-handle-event)

;; Return a list of supported events
(define-generic component-list-events)

;; The basic methods don't do much, a component implementation must
;; override them
(define-method (component-handle-event (component <component>) _event . args)
  #f)

(define-method (component-list-events (component <component>) . args)
  '())


