(define-module (sif ui)
  #:use-module (oop goops)
  #:use-module (string wrap)
  #:use-module (sif character-data)
  #:use-module (ice-9 readline)
  #:use-module (term ansi-color)
  #:export (message
            clear-screen
            raw-message
            user-choices))

(define wrapper (make <text-wrapper> #:line-width 60 #:break-long-words? #f))

(define (raw-message msg)
  "Display a text message"
  (display msg)
  (newline))

(define* (message msg #:optional (who #f))
  "Wrapper around raw-message"
  ;; TODO: wrap lines, ANSI color, stuff
  (raw-message (format #f "~a~a"
                       (if who
                           (colorize-string
                            (format #f "~a: "
                                    (character-name who))
                            'RED 'BOLD)
                           "")
                       (fill-string wrapper msg)))
  'continue)

(define (clear-screen)
  (display "\x1b[2J")
  (display "\x1b[H"))

(define (user-choices choices)
  (let lp ([counter 0]
           [lst choices])
    (unless (null? lst)
      (let ([msg (car (car lst))])
        (format #t "~a: ~a\n"
                counter
                msg)
        (lp (+ 1 counter)
            (cdr lst))))))
