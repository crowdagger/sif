(import (oop goops)
        (ice-9 match))

(define-class <state> ()
  (id #:init-value 'default
      #:init-keyword #:id
      #:getter state-id))

(define-generic state-event)
;; Dummy implementation
(define-method (state-event (state <state>) event)
  (error "Unrecognized event" event))


(define-class <state-closed> (<state>))
(define-method (state-event (state <state-closed>) event)
  (match event
    ('open
     (display "Opening\n")
     'open)
    ('close
     (display "Already closed\n")
     'closed)
    (else
     (next-method))))

(define-class <state-open> (<state>))
(define-method (state-event (state <state-open>) event)
  (match event
    ('close
     (display "Closing\n")
     'closed)
    ('open
     (display "Already open\n")
     'open)
    (else
     (next-method))))

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
(behaviour-add-state! b 'open (make <state-open>))
(behaviour-add-state! b 'closed (make <state-closed>))
