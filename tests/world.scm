(import (srfi srfi-64)
        (oop goops)
        (sif world)
        (sif element))


(test-begin "world")
(test-group "class"
  (define w (make <world>))
  (test-equal "world-add!" 0 (world-add! w 42))
  (test-equal "world-add!" 1 (world-add! w "foo"))
  (test-equal "world-ref" 42 (world-ref w 0))
  (world-del! w 0)
  (test-equal "world-del!" #f (world-ref w 0))
  )

(test-group "de/serialization"
  (define w (make <world>))
  (define room (make <element> #:name "Room" #:world w))
  (define table (make <element> #:name "Table" #:world w))
  (element-add! room table)
  
  (define lst (world->list w))
  (define world2 (list->world lst (current-module)))
  (test-equal "list->world" "Room" (slot-ref (world-ref world2 0) 'name))
  (test-equal "list->world" "Table" (slot-ref (world-ref world2 1) 'name))

  (define lst2 (world->list world2))
  (test-equal "world->list" lst lst2)
  )
(test-end "world")
