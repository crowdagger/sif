(define-module (script start)
  #:use-module (sif scene)
  #:use-module (sif ui)
  #:use-module (script characters)
  #:export (start-scene))

(define *dog-introduced* #f)
(define *suspicion* 0)

(define-scene start-scene
  (message "It was pretty early in the morning when Cherry woke up.")
  (cherry "Huuuuuh.")
  (cherry "Hum, what time is it?")
  (message "Or at least, it was pretty early according to her standards.")
  (cherry "Oh, it's not even 1:00 PM...")
  (#:menu "Go back to bed?"
          (("Yes" (jump sleep-scene))
           ("No"  (jump awake-scene))))
  )


(define-scene sleep-scene
  (clear-screen)
  (message "The woman closed her eyes again and used a pillow to hide from the light. But finding sleep again was not going to be that easy.")
  (dog "Meow!")
  (message "Dog had seen that she was awake, and he wasn't going to forget that.")
  (set! *dog-introduced* #t)
  (message "Dog, as his name didn't really suggest — he wasn't responsible for his human sense of humor — was a big orange cat, and he clearly wanted to play with Cherry.")
  (message "Or, more precisely, to use her as a trampoline.")
  (cherry "Oh, fine.")
  (jump awake-scene))

(define-scene awake-scene
  (clear-screen)
  (message "Cherry got up, yawned, dressed up and went in front of her computer.")
  (computer "Hmm. We’re having trouble finding that site.")
  (cherry "Oh, come on!")
  (message "Having connection issues upon waking was one of the things she hated the most.")
  (message "She looked at her internet router, and realized it was laying on the ground, its RJ-45 cable disconnected.")
  (message "Cherry glared at Dog.")
  (if *dog-introduced*
      (cherry "You weren't happy with preventing me to sleep, huh?")
      (message "Dog, as his name didn't really suggest — he wasn't responsible for his human sense of humor — was a big orange cat."))
  (message "Dog didn't appear to be mortified by his human's deadly glare.")
  (cherry "Whatever.")
  (clear-screen)
  (message "She got up from her chair and put the internet router back on an overencumbered table.")
  (message "As she was standing up, she decided to seize the opportunity and went to the kitchen to grab a sugar-free caffeinated soft drink in the fridge.")
  (message "When she came back to the chair in front of her computer, she looked at her cat again.")
  (message "He had also seized an opportunity and was sitting in her place.")
  (#:menu "Cherry sighed."
          (("Pet the cat" (begin
                            (set! *suspicion* (- *suspicion* 1))
                            (message "She carefully grabbed Dog and placed him on her knees once she sitted. The cat started purring sotfly.")))
           ("Scowl the cat" (message "She pushed the cat away from the chair, triggering an indignant meowing."))))
  (clear-screen)
  (message "Cherry eventually was able to connect to her Mastodon instance.")
  (message "She looked at her notifications, then scrolled a bit her feed to see news from her friends. She liked a few cat pictures in the process.")
  (message "Then, it was time to open the moderation interface.")
  (jump moderation))


(define-scene moderation
  (clear-screen)
  (cherry "Oh, damn.")
  (message "There were more reports than she was expecting. 'Looked like she was actually having to do some moderation work.")
  (message "She looked at the first report. Someone was complaining at the lack of content warning for the picture of a muscular gay men clearly showing more enthusiast than clothes.")
  (#:menu "Moderation"
          (("Do nothing" (message "It wasn't pornographic either, and Cherry failed to see how it was harmful. She decided to close the report."))
           ("Mark as sensitive" (message "Cherry absent-mindedly marked the message as sensitive and moved to the next report."))
            ("Delete post" (message "Cherry deleted the post. It was from a remote instance anyways, so it wasn't like it had a real impact."))))
  (clear-screen)
  (message "The next report was indicated as spam.")
  (julianne42 "Hey! I'm Julianne, a.k.a 'Fediverse Girl'!")
  (set! *suspicion* (+ 1 *suspicion*))
  (message "Cherry had seen similar posts before, by accounts with similar names. Yeah, probably spam.")
  (#:menu "Moderation"
          (("Suspend" (message "Cherry clicked the suspend button and moved to another report."))
           ("Investigate" (jump investigate-1))))
  (jump moderation-2))

(define-scene investigate-1
  (clear-screen)
  (message "The weird thing is, it was clearly spam. There were tons of accounts with the exact same post and the exact same bio and nearly the same user name all across the Fediverse.")
  (message "Yet, it wasn't really selling anything or linking to some weird bitcoin donation thing or anything like that.")
  (message "The only thing was a link to a private Discord server in he bio.")
  (cherry "Whatever.")
  (set! *suspicion* (+ 1 *suspicion*))
  (jump moderation-2))

(define-scene moderation-2
  (clear-screen)
  (message "The following report was against some right-wing dude who clearly had a problem againt trans people.")
  (#:menu "Moderation"
          (("Suspend" (jump moderation-3))
           ("Suspend" (jump moderation-3))
           ("Suspend" (jump moderation-3)))))

(define-scene moderation-3
  (cherry "F████ off.")
  (message "Cherry had no patience for transphobes.")
  (clear-screen)
  (message "The last report was another one for spam.")
  (julianne31 "Hey! I'm Julianne, a.k.a 'Fediverse Girl'!")
  (cherry "Again?")
  (set! *suspicion* (+ 1 *suspicion*))
  (#:menu "Moderation"
          (("Suspend" (jump moderation-4))
           ("Investigate" (jump investigate-2)))))

(define-scene investigate-2
  (clear-screen)
  (message "Cherry frowned.")
  (set! *suspicion* (+ 1 *suspicion*))
  (message "How did the person, or people, behind those accounts made any money?")
  (message "Was it just pure malevolence?")
  (cherry "It doesn't make sense.")
  (jump moderation-4))

(define-scene moderation-4
  (if (< *suspicion* 2)
      (jump end-scene)
      (clear-screen))
  (message "There were a few more reports more, but Cherry decided to take a break from her moderating duties.")
  (message "Well, not really actually, as all those spam messages had arisen her curiosity.")
  (cherry "Guess there's only one way to find out.")
  (message "She clicked on the link tha was on the bio of all those Juliennes fake accounts.")
  (clear-screen)
  (message "At this point, she didn't realize that her investigation would lead her to uncover a very shady conspiracy and to face CIA assassins and the calabrian 'Ndrangheta.")
  (jump end-scene))

(define-scene end-scene
  (message "THE END")
  (clear-screen)
  (message "Thanks for playing!"))
