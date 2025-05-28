(define-module (web dom)
  #:use-module (hoot ffi)
  #:export (document-body
            get-element-by-id
            add-event-listener!
            make-text-node
            set-html!
            append-html!
            append-child!))

(define-foreign add-event-listener!
    "element" "addEventListener"
    (ref null extern) (ref string) (ref null extern) -> none)

(define-foreign document-body
  "document" "body"
  -> (ref null extern))

(define-foreign get-element-by-id
  "document" "getElementById"
  (ref string) -> (ref null extern))

(define-foreign make-text-node
  "document" "createTextNode"
  (ref string) -> (ref null extern))

(define-foreign set-html!
  "element" "setHtml"
  (ref null extern) (ref string) -> (ref null extern))

(define-foreign append-html!
  "element" "appendHtml"
  (ref null extern) (ref string) -> (ref null extern))

(define-foreign append-child!
  "element" "appendChild"
  (ref null extern) (ref null extern) -> (ref null extern))
