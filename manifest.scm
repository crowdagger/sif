;; Taken from hoot game jam template and sligthly modified but
;; I have no idea what I'm doing
(use-modules (guix git-download)
             (guix packages)
             (gnu packages base)
             (gnu packages guile)
             (gnu packages guile-xyz))

(packages->manifest (list guile-next guile-hoot guile-lib))
