(define-module (sif room))
(export <room>)
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

(define-method (initialize (r <room>) initargs)
  (next-method)

  ;; Add room's actions
  )


(define-method (element->alist (r <room>))
  (append
   `(
     (connections . ,(room-connections r)))
   (next-method)))
