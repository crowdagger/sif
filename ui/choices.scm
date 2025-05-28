(define-module (tui choices))
(export
 )
(import
 )

(define (user-choice options)
  "Ask the user for a choice beween options.

Options must be a list of (text . value) pairs.
Returns the value of selected option."
  (display-options options))


(define (display-options options)
  "Display the options to terminal."
  (display "Todo"))
