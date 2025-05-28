(import (srfi srfi-64)
        (sif scene))

(test-begin "scene")
(test-group "macro/call"
  (define-scene pouet
    (display "Foo\n")
    (display "Bar\n")
    (display "Baz\n"))
  
  (test-eq 1 (call-scene pouet 0))
  (test-eq 2 (call-scene pouet 1))
  (test-eq 3 (call-scene pouet 2))
  (test-eq #f (call-scene pouet 3))

  )

(test-end "scene")
