(defun mavbozo/go-mode-hook ()
  (setq tab-width 4))

(use-package go-mode
  :mode (("\\.go\\'" . go-mode))
  :config
  (add-hook 'go-mode-hook 'mavbozo/go-mode-hook)
  :hook (go-mode . lsp-deferred))
