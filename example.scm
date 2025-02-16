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
;(world-add-list! w (element->list v))

(newline)
(display (world->list w))
(newline)

(define w2 (list->world
            (world->list w)))

(display (world->list w2))
(newline)
