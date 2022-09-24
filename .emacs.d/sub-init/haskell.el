(require 'haskell-interactive-mode)
(require 'haskell-process)


(defun mavbozo-haskell-mode-hook-fn ()
  (define-prefix-command 'my-haskell-mode-key-map)

  (define-key my-haskell-mode-key-map (kbd "b") 'haskell-interactive-bring)
  (define-key my-haskell-mode-key-map (kbd "l") 'haskell-process-load-or-reload)
  
  (define-key xah-fly-leader-key-map (kbd "b") my-haskell-mode-key-map)
  )

(when (fboundp 'haskell-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'mavbozo-haskell-mode-hook-fn)
  )
