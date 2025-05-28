(define-module (sif main)
  #:use-module (sif state)
  #:use-module (ice-9 match)
  #:export (sif-init
            sif-main
            *state*))

(define *state* #f)

(define* (scene-handler! state #:optional (input #f))
  "Call the appropriate passage of a scene according to the current state

This function modifies the state"
  (let* ([scene (state-scene state)]
         [index (state-index state)]
         [ret ((vector-ref scene index) input)])
    (match ret
      [('jump scene)
       (state-set-scene! state scene)
       (state-set-index! state 0)
       (scene-handler! state)]
      ['continue
       (state-set-index! state (+ 1 index))
       ret]
      ['repeat
       ret]
      ['end
       ;; Todo
       #f]
      [else
       (state-set-index! state (+ 1 index))
       (scene-handler! state)])))


(define (sif-init scene)
  (set! *state* (init-state scene)))

(define* (sif-main #:optional (input #f))
  (scene-handler! *state* input))
