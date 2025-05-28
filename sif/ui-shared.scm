(define-module (sif ui-shared)
  #:use-module (sif ui)
  #:export (raw-menu))


(define* (raw-menu msg options #:optional (input #f))
  "Display a prompt for options if no input is given, else choose according to input"
  (if input
      (let ([input (string->number input)])
        (if (and input
                 (>= input 0)
                 (< input (length options)))
            (let ([choice (list-ref options input)])
              ((cadr choice)))
            (raw-menu msg options)))
      (begin
        (message msg)
        (user-choices options)
        'repeat)))
