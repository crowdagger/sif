(use-modules (hoot ffi)
             (web dom)
             (sif ui)
             (sif main)
             (sif scene)
             (script start))

(sif-init start-scene)
(sif-main)
;(append-child! story (make-text-node "Hello, world!"))

;(append-html! story (format #f "<b>POUET</b> ~a" f))
