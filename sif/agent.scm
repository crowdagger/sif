(define-module (sif agent))
(export <agent>
        agent-move)
(import (oop goops)
        (srfi srfi-1)
        (sif world)
        (sif room)
        (sif element))


;;; Agent, eg player
(define-class <agent> (<element>))

;;; Overrides usual suspects
(define-method (initialize (a <agent>) initargs)
  (next-method))

(define-method (element->alist (a <agent>))
  (append
   (next-method)))


;;; Move to a room
(define-generic agent-move)
(define-method (agent-move (a <agent>)
                           (r <room>))
  (let ([w (element-world a)]
        [w2 (element-world r)]
        [current (element-container a)])
    (unless (eq? w w2)
      (error "Agent and room are in two different worlds" w w2))
    (if (or (not current)
            (find (λ (x) (= (cdr x) (element-id r)))
                  (room-connections current)))
        (element-add! r a)
        (error "Current room is not connected to targer room" r))))
