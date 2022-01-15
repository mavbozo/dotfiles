
(when (fboundp 'clojure-mode)
  (setq clojure-toplevel-inside-comment-form t))

(defun mavbozo-cider-mode-hook-fn ()
  (setq cider-print-fn nil)
  
  (setq cider-auto-select-error-buffer nil)

  (setq cider-refresh-before-fn "dev/stop"
	cider-refresh-after-fn "dev/go")

  (setq cider-repl-prompt-function 'cider-repl-prompt-abbreviated)

  (defun cider-dev>reset ()
    "dev>(reset). convenient function to reset my clojure development system"
    (interactive)
    (cider-switch-to-repl-buffer)
    (insert "(dev/reset)")
    (cider-repl-return)
    (cider-switch-to-last-clojure-buffer))


  (defun cider-dev>c.t.n.repl/refresh ()
    "cider-dev>c.t.n.repl/refresh (). convenient function to reset my clojure development system"
    (interactive)
    (cider-switch-to-repl-buffer)
    (insert "(clojure.tools.namespace.repl/refresh)")
    (cider-repl-return)
    (cider-switch-to-last-clojure-buffer))

  ;; define my clojure-mode keymap
  (defun mavbozo-cider-repl-clear-buffer ()
    (interactive)
    (cider-switch-to-repl-buffer)
    (cider-repl-clear-buffer))

  (defun mavbozo-cider-repl-clear-output ()
    (interactive)
    (cider-switch-to-repl-buffer)
    (cider-repl-clear-output))

  (define-prefix-command 'my-clojure-mode-key-map)
  
  (define-key my-clojure-mode-key-map (kbd "c c") 'cider-eval-defun-at-point)
  (define-key my-clojure-mode-key-map (kbd "c e") 'cider-eval-last-sexp)
  (define-key my-clojure-mode-key-map (kbd "c C") 'cider-connect)
  (define-key my-clojure-mode-key-map (kbd "c d") 'cider-doc)
  (define-key my-clojure-mode-key-map (kbd "c E") 'cider-eval-last-sexp-to-repl)
  (define-key my-clojure-mode-key-map (kbd "c k") 'cider-load-buffer)
  (define-key my-clojure-mode-key-map (kbd "c N") 'cider-repl-set-ns)
  (define-key my-clojure-mode-key-map (kbd "c q") 'cider-quit)
  (define-key my-clojure-mode-key-map (kbd "c O") 'mavbozo-cider-repl-clear-output)
  (define-key my-clojure-mode-key-map (kbd "c o") 'mavbozo-cider-repl-clear-buffer)
  (define-key my-clojure-mode-key-map (kbd "c v n") 'cider-eval-ns-form)
  (define-key my-clojure-mode-key-map (kbd "c v r") 'cider-eval-region)
  (define-key my-clojure-mode-key-map (kbd "c v w")  'cider-eval-last-sexp-and-replace)
  (define-key my-clojure-mode-key-map (kbd "c x") 'cider-dev>reset)
  (define-key my-clojure-mode-key-map (kbd "c X") 'cider-dev>c.t.n.repl/refresh)
  (define-key my-clojure-mode-key-map (kbd "c z") 'cider-switch-to-repl-buffer)
  (define-key my-clojure-mode-key-map (kbd "c ;") 'cider-switch-to-last-clojure-buffer)
  (define-key my-clojure-mode-key-map (kbd "c M-;") 'cider-eval-defun-to-comment)


  ;; ;; define_the_leader_key_for_my-clojure-mode-keymap
  ;; ;; since I use qwerty keybinding, the leader key here is qwerty key
  (define-key xah-fly-leader-key-map (kbd "b") my-clojure-mode-key-map)
  
  )

(when (fboundp 'cider-mode)
  ;; disable auto pretty-printing

  (add-hook 'cider-repl-mode-hook 'subword-mode)
  (add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)
  (add-hook 'cider-repl-mode-hook 'mavbozo-cider-mode-hook-fn )
  
  )
