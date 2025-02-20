(import (oop goops)
        (ice-9 match))

(define-class <state> ()
  (id #:init-value 'default
      #:init-keyword #:id
      #:getter state-id)
  (handlers #:init-value '()
            #:init-keywords #:handlers
            #:getter state-handlers))

;; Returns the handler of a state for a given event
;;
;; Returns a procedure or errors if event isn't handled
(define (state-get-handler state event)
  (let ([handler (assoc-ref (state-handlers state)
                            event)])
    (if handler
        handler
        (error "Unhandled event" event))))

;; Add a handler for an event.
;;
;; Handler must be a procedure receiving state and event as parameters
(define (state-add-handler! state event handler)
  (slot-set! state 'handlers
             (acons event handler
                    (slot-ref state 'handlers))))

(define-generic state-event)
;; Dummy implementation
(define-method (state-event (state <state>) event)
  (let ([handler (state-get-handler state event)])
    (if handler
        (handler state event)
        (error "Unrecognized event" event))))


(define (state-closed)
  (let* ([state (make <state> #:id 'closed)])
    (state-add-handler! state 'open
                        (lambda (_s _e)
                          (display "Opening\n")
                          'open))
    (state-add-handler! state 'close
                        (lambda (_s _e)
                          (display "Already closed\n")
                          'closed))
    state))

(define (state-open)
  (let* ([state (make <state> #:id 'open)])
    (state-add-handler! state 'open
                        (lambda (_s _e)
                          (display "Already open\n")
                          'open))
    (state-add-handler! state 'close
                        (lambda (_s _e)
                          (display "Closing\n")
                          'closed))
    state))

(define-class <behaviour> ()
  (current-state #:init-value 'init
                 #:init-keyword #:init-state
                 #:getter current-state)
  (states #:init-value '()
          #:init-keyword #:states
          #:getter states))

(define-generic behaviour-add-state!)
(define-method (behaviour-add-state! (b <behaviour>) id (s <state>))
  (slot-set! b 'states
             (cons `(,id . ,s)
                   (slot-ref b 'states))))

(define-generic behaviour-event!)
(define-method (behaviour-event! (b <behaviour>) event)
  (let* ([state (current-state b)]
         [state (assoc-ref (slot-ref b 'states) state)]
         [next-state (state-event state event)])
    (format #t "New state:~a\n" next-state)
    (slot-set! b 'current-state next-state)))


(define b (make <behaviour> #:init-state 'open))
(behaviour-add-state! b 'open (state-open))
(behaviour-add-state! b 'closed (state-closed))

(behaviour-event! b 'open)
