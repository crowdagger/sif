(define-module (sif state)
  #:use-module (srfi srfi-9)
  #:export (<state>
            state?
            state-scene state-set-scene!
            state-index state-set-index!
            init-state))

;; State recording current player action
(define-record-type <state>
  (init-state% scene index)
  state?
  (scene state-scene state-set-scene!)
  (index state-index state-set-index!))
  

(define* (init-state scene #:optional (index 0))
  "Create an initial state starting at scene"
  (init-state% scene index))
