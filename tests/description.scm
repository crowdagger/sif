(import (srfi srfi-64)
        (oop goops)
        (sif object)
        (sif component)
        (sif components description))

(test-begin "component::description")
(test-group "event"
  (define d (make <description> #:description "A description"))
  (test-equal "handle-event" "A description"
              (component-handle-event d 'describe))
  (test-equal "handle-event" "A description"
              (component-handle-event d 'describe 'some 'args))
  )
(test-group "serialization"
  (define d (make <description> #:description "A description"))
  (define l (object->list d))
  (define d2 (list->object l (current-module)))
  (test-equal "list->object" "A description"
             (slot-ref d2 'description))
  (test-equal "object->list" l
              (object->list d2))
)
(test-end "component::description")
