


;; (defun mavbozo/eval-last-sexp-wrapper ()
;;   "call different commands depending on what's current major mode."
;;   (interactive)
;;   (cond
;;    ((string-equal major-mode "emacs-lisp-mode") (call-interactively 'eval-last-sexp))
;;    ((string-equal major-mode "clojure-mode") (call-interactively 'inf-clojure-eval-last-sexp))
;;    ;; more major-mode checking here

;;    ;; if nothing match, do nothing
;;    (t (print "eval-last-sexp not applicable for this mode"))))


;; (define-key xah-fly-w-keymap (kbd "m") 'mavbozo/eval-last-sexp-wrapper)


;; (with-eval-after-load 'inf-clojure-mode
;;   (define-key inf-clojure-mode-map [remap eval-last-sexp] 'inf-clojure-eval-last-sexp))
