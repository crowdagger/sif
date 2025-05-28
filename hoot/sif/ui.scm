(define-module (sif ui)
  #:use-module (sif character-data)
  #:use-module (sif main)
  #:use-module (web dom)
  #:use-module (scheme write)
  #:use-module (hoot ffi)
  #:export (message
            clear-screen
            raw-message
            user-choices))


(define (raw-message msg)
  "Display a HTML message to div 'story'"
  (append-html! (get-element-by-id "story") msg))


(define* (message msg #:optional (who #f))
  "Adds HTML formatting and call raw-message"
  ;; TODO: escape HTML
  (raw-message (format #f "<p>~a~a</p>"
                       (if who
                           (format #f "<span class = 'character-name' ~a>
~a
</span>: "
                                   (if (character-color who)
                                       (format #f "style = \"color: ~a;\" "
                                               (character-color who))
                                       "")
                                   (character-name who))
                           "")
                       msg))
  (post-message)
  'continue)


;; Adds a link to display next message
(define (post-message)
  (set-html! (get-element-by-id "user-input")
             "<p><a href = '#' id = 'next-link'>Next</a></p>")
  (add-event-listener! (get-element-by-id "next-link")
                       "click"
                       (procedure->external
                        (lambda (event)
                          (let ([ret (set-html! (get-element-by-id "next-link")
                                     "")])
                          (sif-main)
                          ret)))))

(define (clear-screen)
  "Clear the text region"
  (set-html! (get-element-by-id "story")
             ""))

(define (user-choices choices)
  (let ([user-input (get-element-by-id "user-input")])
    (set-html! user-input "<li class = 'choices'>")
    (let lp ([counter 0]
             [lst choices])
      (unless (null? lst)
        (let ([id (format #f "next-link-~a"
                          counter)]
              [msg (car (car lst))])
          (append-html! user-input
                        (format #f "<li><a href = '#' id = '~a'>~a</li>"
                                id
                                msg))

          (lp (+ 1 counter)
              (cdr lst)))))
    (append-html! user-input "</li>")
    ; Two loops instead of one because add-event-listener didn't seem to
    ; mix well with html appending
    (let lp ([counter 0]
             [lst choices])
      (unless (null? lst)
        (let ([id (format #f "next-link-~a"
                           counter)])
          (add-event-listener! (get-element-by-id id)
                               "click"
                               (procedure->external
                                (lambda (event)
                                  (let ([ret (set-html! user-input "")])
                                    (sif-main (format #f "~a" counter))
                                    ret))))
          (lp (+ 1 counter)
              (cdr lst)))))))
          


