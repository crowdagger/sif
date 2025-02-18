(define-module (sif trigger))
(export <trigger>)

(import (oop goop))

(define-class <trigger> ()
  (id #:init-value #f
      #:getter trigger-id
      #:init-keyword #:id)
  (condition #:init-value #f
             #:getter trigger-condition
             #:init-keyword #:condition)
  (event #:init-value #f
         #:getter trigger-event
         #:init-keyword #:condition))
