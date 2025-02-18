(import (oop goops)
        (ice-9 pretty-print)
        (sif world)
        (sif element)
        (sif room))

(define w (make <world>))

(define room (make <room> #:name "Bedroom" #:world w))
(define hall (make <room> #:name "Living room" #:world w))
(define table (make <element> #:name "Table" #:world w))


(room-connect room hall "Living room")
(room-connect hall room "Door")
;(write table)
(element-add! room table)

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
