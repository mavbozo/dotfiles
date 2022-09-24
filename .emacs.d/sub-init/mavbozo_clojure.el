;; CLOJURE

;; First install the package:
(use-package flycheck-clj-kondo
  :defer t)


(defun mavbozo/cider-dev>reset ()
    "convenient function to reset my clojure development system"
    (interactive)
    (cider-switch-to-repl-buffer)
    (insert "(dev/reset)")
    (cider-repl-return)
    (cider-switch-to-last-clojure-buffer))


(defun mavbozo/cider-dev>c.t.n.repl/refresh ()
  "convenient function to reset my clojure development system"
  (interactive)
  (cider-switch-to-repl-buffer)
  (insert "(clojure.tools.namespace.repl/refresh)")
  (cider-repl-return)
  (cider-switch-to-last-clojure-buffer))


(defun mavbozo/clojure-mode-hook-fn ()
  (interactive)
  (progn
    (setq clojure-toplevel-inside-comment-form t)
    ;; create a keymap
    (define-prefix-command 'mavbozo/clojure-leader-map)
    ;; add keys to it
    (define-key mavbozo/clojure-leader-map (kbd "i") 'inf-clojure)
    (define-key mavbozo/clojure-leader-map (kbd "c") 'cider-connect)
    (define-key mavbozo/clojure-leader-map (kbd "j") 'cider-jack-in)
    
    )
  ;; modify the major mode's key map, so that a key becomes your leader key
  (define-key clojure-mode-map (kbd "<f9>") mavbozo/clojure-leader-map))


(use-package clojure-mode
  :mode (("\\.clj\\'" . clojure-mode) ("\\.cljs\\'" . clojure-mode) ("\\.edn\\'" . clojure-mode))
  :config
  (add-hook 'clojure-mode-hook 'mavbozo/clojure-mode-hook-fn)
  (add-hook 'clojure-mode-hook #'cider-mode)
  (add-hook 'clojure-mode-hook #'flycheck-mode)
  (require 'flycheck-clj-kondo))


(defun mavbozo/cider-mode-hook-fn ()
  (interactive)
  (progn
    ;; create a keymap
    (define-prefix-command 'mavbozo/cider-leader-map)
    ;; add keys to it
    (define-key mavbozo/cider-leader-map (kbd "p q") 'cider-quit)

    (define-key mavbozo/cider-leader-map (kbd "b") 'cider-interrupt)
    (define-key mavbozo/cider-leader-map (kbd "M-e") 'cider-eval-last-sexp-to-repl)
    (define-key mavbozo/cider-leader-map (kbd "v v") 'cider-eval-sexp-at-point)
    (define-key mavbozo/cider-leader-map (kbd "v f e") 'cider-pprint-eval-last-sexp)

    (define-key mavbozo/cider-leader-map (kbd "m") 'cider-macroexpand-1)
    (define-key mavbozo/cider-leader-map (kbd "M-m") 'cider-macroexpand-all)

    (define-key mavbozo/cider-leader-map (kbd "M-n M-n") 'cider-repl-set-ns)

    (define-key mavbozo/cider-leader-map (kbd "d d") 'cider-doc)
    (define-key mavbozo/cider-leader-map (kbd "d j") 'cider-java-doc)
    (define-key mavbozo/cider-leader-map (kbd "j") 'cider-switch-to-repl-buffer)

    (define-key mavbozo/cider-leader-map (kbd "i e") 'cider-inspect-last-sexp)
    (define-key mavbozo/cider-leader-map (kbd "i r") 'cider-inspect-last-result)

    
    (define-key mavbozo/cider-leader-map (kbd "u") 'mavbozo/cider-dev>reset)
    (define-key mavbozo/cider-leader-map (kbd "U") 'mavbozo/cider-dev>c.t.n.repl/refresh)
    
    )
  ;; modify the major mode's key map, so that a key becomes your leader key
  (define-key cider-mode-map (kbd "M-j") mavbozo/cider-leader-map))

(defun mavbozo/cider-repl-mode-hook-fn ()
  (interactive)
  (progn
    ;; create a keymap
    (define-prefix-command 'mavbozo/cider-repl-leader-map)
    ;; add keys to it
    (define-key mavbozo/cider-repl-leader-map (kbd "p q") 'cider-quit)
    (define-key mavbozo/cider-repl-leader-map (kbd "r b") 'cider-repl-clear-buffer)
    (define-key mavbozo/cider-repl-leader-map (kbd "r o") 'cider-repl-clear-output)
    (define-key mavbozo/cider-repl-leader-map (kbd "j") 'cider-switch-to-last-clojure-buffer)
    (define-key mavbozo/cider-repl-leader-map (kbd "u") 'mavbozo/cider-dev>reset)
    (define-key mavbozo/cider-repl-leader-map (kbd "U") 'mavbozo/cider-dev>c.t.n.repl/refresh)
    )
  ;; modify the major mode's key map, so that a key becomes your leader key
  (define-key cider-repl-mode-map (kbd "M-j") mavbozo/cider-repl-leader-map))

(use-package cider
  :pin melpa-stable
  :defer t
  :config
  (setq cider-auto-select-error-buffer nil)
  (define-key cider-mode-map [remap eval-last-sexp] 'cider-eval-last-sexp)
  (define-key cider-mode-map [remap eval-buffer] 'cider-eval-buffer)
  (add-hook 'cider-mode-hook 'mavbozo/cider-mode-hook-fn)
  (add-hook 'cider-repl-mode-hook 'mavbozo/cider-repl-mode-hook-fn)
  )

;; modify the major mode's key map, so that a key becomes your leader key
;; (define-prefix-command 'mavbozo-inf-clojure-leader-map)
;; (define-key inf-clojure-mode-map (kbd "<f9>") mavbozo-inf-clojure-leader-map)

(use-package inf-clojure
  :commands (inf-clojure)
  :defer t
  ;; :hook (clojure-mode-hook . inf-clojure-minor-mode)
  ;; :bind
  ;; ([remap eval-last-sexp] . inf-clojure-eval-last-sexp)
  ;; ([remap eval-buffer] . inf-clojure-eval-buffer)
  ;; ([remap eval-buffer] . inf-clojure-eval-buffer)
  ;; ([remap eval-region] . inf-clojure-eval-region)
  ;; :bind  (:map inf-clojure-mode-map
  ;;              ("[S] o" . inf-clojure-clear-repl-buffer)
  ;; 	       ("[f9] o" . inf-clojure-clear-repl-buffer)
  ;;              )
  ;; :config
  ;; ;; modify the major mode's key map, so that a key becomes your leader key
  ;; (define-prefix-command 'mavbozo-inf-clojure-leader-map)
  ;; (define-key inf-clojure-mode-map (kbd "S-a") mavbozo-inf-clojure-leader-map)
  ;; :after (clojure-mode)
  :config
  (define-key inf-clojure-minor-mode-map [remap eval-last-sexp] 'inf-clojure-eval-last-sexp)
  (define-key inf-clojure-minor-mode-map [remap eval-buffer] 'inf-clojure-eval-buffer)
  (define-key inf-clojure-minor-mode-map [remap eval-defun] 'inf-clojure-eval-defun)
  )

;; (define-prefix-command 'my-keymap)

;; (define-key my-keymap (kbd "z") 'inf-clojure-switch-to-repl)

;; make xah-fly-keys ALT-f as prefix for my-keymap
;; (define-key xah-fly-leader-key-map (kbd "M-f") my-keymap)
