;; OCAML

;; Major mode for OCaml programming
(use-package tuareg
  :defer t
  :mode (("\\.ocamlinit\\'" . tuareg-mode)))

;; Major mode for editing Dune project files
(use-package dune
  :defer t)

;; Merlin provides advanced IDE features
(use-package merlin
  :defer t
  :config
  (add-hook 'tuareg-mode-hook #'merlin-mode)
  (add-hook 'merlin-mode-hook #'company-mode)
  ;; we're using flycheck instead
  (setq merlin-error-after-save nil))

(use-package merlin-eldoc
  :defer t
  :hook ((tuareg-mode) . merlin-eldoc-setup))

;; This uses Merlin internally
(use-package flycheck-ocaml
  :defer t
  :config
  (flycheck-ocaml-setup))

;; Use the opam installed utop
(setq utop-command "opam exec -- utop -emacs")

;; utop configuration
(use-package utop
  :defer t
  :config
  (add-hook 'tuareg-mode-hook #'utop-minor-mode)
  (define-key utop-minor-mode-map [remap eval-last-sexp] 'utop-eval-phrase)
  (define-key utop-minor-mode-map [remap eval-buffer] 'utop-eval-buffer))
