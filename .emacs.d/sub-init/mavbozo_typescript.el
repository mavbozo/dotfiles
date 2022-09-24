

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  ;; (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  ;; (company-mode +1)
  )

;; ;; aligns annotation to the right hand side
;; (setq company-tooltip-align-annotations t)

(use-package typescript-mode
  :mode ("\\.ts\\'" . typescript-mode)
  ("\\.tsx\\'" . typescript-mode)
  :hook
  ;; (typescript-mode . lsp-deferred)
  ((typescript-mode . prettier-mode)
   ))


(use-package tide
  :defer t
  :after (typescript-mode)
  :hook ((typescript-mode . setup-tide-mode))
  )

