((narration "Something happened")
 (narration "And something else..."))
((narration "Then something else happened next turn"))
((narration "Finally, the player got some choice")
((if ????
     (((narration "Some branching happened")))
     (((narration "... or other one")))))


(define (f1)
  (narration "Something happened")
  (narration "And something else")
  f2)

(define (f2)
  (narration "Then something else happened next turn")
  f3)

(define (f3)
  (narration "Finally, the player got some choice")
  f4)

(define (f4 ???)
  (if ???
      (begin
        (narration "Some branching happened")
        f5)
      (begin
        (narration "... or other one")
        f6)))
