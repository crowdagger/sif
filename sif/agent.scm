(define-module (sif agent))
(export <agent>
        agent-move! agent-list-objects agent-list-moves)
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
(define-generic agent-move!)
(define-method (agent-move! (a <agent>)
                           (r <room>))
  (let ([w (element-world a)]
        [w2 (element-world r)]
        [current (element-container a)])
    (unless (eq? w w2)
      (error "Agent and room are in two different worlds" w w2))
    (if (or (not current)
            (find (λ (x) (= (cdr x) (element-id r)))
                  (room-connections (world-ref w
                                               current))))
        (element-add! r a)
        (error "Current room is not connected to targer room" r))))

;;; List all current objects
(define-generic agent-list-objects)
(define-method (agent-list-objects (a <agent>))
  (let* ([world (element-world a)]
         [room (element-container a)]
         [room (if room
                   (world-ref world room)
                   #f)]
         [room-lst (if room
                       `((,(element-name room) . ,(element-id room)))
                       '())]
         [room-objects
          (if room
              (element-inner room)
              '())]
         [room-objects
          (map (λ (e)
                 `(,(element-name (world-ref world e)) . ,e))
               room-objects)])
    (append room-lst room-objects)))

;;; List possible moves
(define-generic agent-list-moves)
(define-method (agent-list-moves (a <agent>))
  (let ([world (element-world a)])
    (if (eq? (element-container a) #f)
        '()
        (let ([room (world-ref world
                               (element-container a))])
          (room-connections room)))))
        
