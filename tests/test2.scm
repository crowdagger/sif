(import (srfi srfi-64)
        (oop goops)
        (sif world))


(test-begin "world")
(test-group "class"
  (define w (make <world>))
  (test-equal 0 (world-add! w 42))
  (test-equal 1 (world-add! w "foo"))
  (test-equal 42 (world-ref w 0))
  (world-del! w 0)
  (test-equal #f (world-ref w 0))
  )
(test-end "world")
