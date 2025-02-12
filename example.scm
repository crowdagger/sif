(add-to-load-path ".")

(import (oop goops)
        (sif element))

(define room (make <element> #:name "Room"))
(define table (make <element> #:name "Table"))

(add room table)

(action room 'look-at)
