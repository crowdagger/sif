(define-module (script characters)
  #:use-module (sif character)
  #:export (cherry
            computer
            dog
            julianne42
            julianne31))

(define julianne42 (make-character "Julianne42" "#ff4ff3"))
(define julianne31 (make-character "Julianne31" "#ff4fa7"))
(define computer (make-character "Computer" "#4ffffc"))
(define cherry (make-character "Cherry" "#ad03fc"))
(define dog (make-character "Dog" "#ffb04f"))
