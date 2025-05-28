(define-module (sif scene)
  #:use-module (ice-9 match)
  #:use-module (sif ui)
  #:use-module (sif ui-shared)
  #:use-module (sif state)
  #:export (jump
            lambdaify
            define-scene))

;; define-scene macro
;;
;;
;; ;; What we want
;; (define-scene some-scene
;;   (display "Hello!")
;;   (display "How are you?")
;;   (choice
;;    ("Well" (display "Great"))
;;    ("Not so well" (display "Oh :(")))
;;   (display "I must go..."))
;;
;; ;; transformed to
;; (define some-scene
;;   (vector
;;    (lambda () (display "Hello!"))
;;    (lambda () (display "How are you?"))
;;    (lambda () (user-choice '("Well" "Not so well")))
;;    (lambda (input)   (cond
;;                       ((equal input 0) (display "Great"))
;;                       ((equal input 1) (display "Oh :("))
;;    (else (invalid-input))))))

(define-syntax lambdaify
  (syntax-rules ()
    ((_ (done ...) ())
     (list done ...))
    ((_ (done ...) ((todo-msg todo-exp) todo* ...))
     (lambdaify (done ... (list todo-msg (lambda* (#:optional (input #f)) todo-exp)) ) (todo* ...)))
;    ((_ (done ...) (todo ...))
;     (syntax-error "Invalid syntax for menu")))
    ))
        

;; Transform a line such as
;; (message "Foo")
;;
;; to
;; (lambda () (message "Foo"))
;;
;; and
;; (menu "Choice?" some_choices)
;; to
;; (lambda (input) (raw menu "Choice?" (lambdaify some_choices) input)
(define-syntax helper
  (syntax-rules ()
    ((_ (#:menu msg opt)) (lambda* (#:optional (input #f))
                          (raw-menu msg (lambdaify () opt) input)))
    ((_ exp) (lambda* (#:optional (input #f)) exp))))

(define-syntax %outer
  (syntax-rules ()
    ((_ name (done ...) ())
     (define name
       (vector done ...)))
    ((_ name (done ...) (todo todo* ...))
     (%outer name (done ... (helper todo)) (todo* ...)))
    ))

(define-syntax define-scene
  (syntax-rules ()
    ((_ name exp ...)
     (%outer name () (exp ... 'end)))))


(define (jump scene)
  "Indicate to jump to given scene"
  `(jump ,scene))
