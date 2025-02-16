(add-to-load-path ".")
(add-to-load-path ".")

(import (oop goops)
        (ice-9 pretty-print)
        (sif world)
        (sif element))

(define w (make <world>))

(define room (make <element> #:name "Room" #:world w))
(define table (make <element> #:name "Table" #:world w))

;(write table)
(add! room table)

(action room 'look-at)
(newline)
(write room)
(newline)
(write table)
(newline)
(define s (call-with-output-string
            (lambda (port)
              (write table port))))
(display s)
(newline)
(define v (call-with-input-string s
            (lambda (port)
              (element-read w port))))

(write (element->list v))
(newline)

(pretty-print w #:display? #t #:width 50)
(newline)
