(define-module (sif room))
(export <room>
        room-connect room-connections)
(import (oop goops)
        (sif element)
        (sif world))

;;; Room, inherit element.
;;;
;;; Adds connection to other rooms and a way to move from
;;; one to another
(define-class <room> (<element>)
  (connections #:init-value '()
               #:init-keyword #:connections
               #:getter room-connections))

;;; Necessary overloads
(define-method (initialize (r <room>) initargs)
  (next-method)

  ;; Add room's actions
  (add-action r 'connections (λ (r) (list-connections r)))
  )


(define-method (element->alist (r <room>))
  (append
   `(
     (connections . ,(room-connections r)))
   (next-method)))


;;; Add a connection beween a room to another
;;;
;;; Connects room1 to room2 with description desc
(define-generic room-connect)
(define-method (room-connect (room1 <room>)
                             (room2 <room>)
                             desc)
  (let* ([conn (slot-ref room1 'connections)]
         [new-conn (cons `(,desc . ,(element-id room2))
                         conn)])
    (slot-set! room1 'connections new-conn)))


;;; List all valid connections from a room
(define-generic list-connections)
(define-method (list-connections (r <room>))
  (room-connections r))
