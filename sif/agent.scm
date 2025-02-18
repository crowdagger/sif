(define-module (sif agent))
(export <agent>)
(import (oop goops)
        (sif world)
        (sif element))


;;; Agent, eg player
(define-class <agent> (<element>))

;;; Overrides usual suspects
(define-method (initialize (a <agent>) initargs)
  (next-method))

(define-method (element->alist (a <agent>))
  (append
   (next-method)))
