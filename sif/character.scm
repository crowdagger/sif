(define-module (sif character)
  #:use-module (sif character-data)
  #:use-module (sif ui)
  #:export (make-character))

(define* (make-character name #:optional (html-color #f))
  "Wraps around character-data and returns a function that takes a message and makes this character say it"
  (let ([data (make-character-data name html-color)])
    (lambda (msg)
      (message msg data))))
    
