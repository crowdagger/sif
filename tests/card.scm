(import (srfi srfi-64)
        (ice-9 format)
        (cards card))

(test-begin "card")
(test-group "basis"
  (define c (make-card '(heart) 2))
  (test-eq #t (card-satisfies? c '() 0))
  (test-eq #t (card-satisfies? c '() 2))
  (test-eq #f (card-satisfies? c '() 3))
  (test-eq #t (card-satisfies? c '(heart) 0))
  (test-eq #f (card-satisfies? c '(spade) 0)))
(test-group "display"
  (define c (make-card '(heart club) 3))
  (test-equal "♥♣3" (format #f "~a" c))
  )
(test-end "card")
