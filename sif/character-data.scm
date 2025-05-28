(define-module (sif character-data)
  #:use-module (srfi srfi-9)
  #:export (<character-data>
            character-data?
            make-character-data
            character-name set-character-name!
            character-color set-character-color!))

;; Data related to display used for a character
(define-record-type <character-data>
  (make-character-data% name html-color)
  character-data?
  (name character-name set-character-name!)
  (html-color character-color set-character-color!))

(define* (make-character-data name #:optional (html-color #f))
  (make-character-data% name html-color))
                        
