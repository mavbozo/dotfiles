
;; WORKING SETUP USING JS2-MODE AND XREF-JS2

;; XREF-JS2
;; (defun setup-xref-backend-for-js2-mode ()
;;   (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t))

;; (use-package xref-js2
;;   :defer t
;;   :after (js2-mode)
;;   :init (setq xref-js2-search-program 'ag) 
;;   )

;; (use-package js2-mode
;;   :defer t
;;   :mode ("\\.js\\'" . js2-mode)
;;   :hook
;;   ((js2-mode . setup-xref-backend-for-js2-mode)
;;    ;; (js-mode . js2-minor-mode)
;;    ;; (js-mode . lsp-deferred)
;;    )
;;   :config
;;   (define-key js-mode-map (kbd "M-.") nil)
;;   )

;; END WORKING SETUP USING JS2-MODE AND XREF-JS2

;; TERN MODE

;; (add-to-list 'load-path "~/.emacs.d/ext-packages/tern/emacs")
;; (autoload 'tern-mode "tern.el" nil t)

;; (use-package js2-mode
;;   :defer t
;;   :mode ("\\.js\\'" . js-mode)
;;   :hook
;;   (
;;    (js-mode . js2-minor-mode)
;;    (js-mode . tern-mode)
;;    )
;;   ;; :config
;;   ;; (define-key js-mode-map (kbd "M-.") nil)
;;   )

;; END TERN-MODE


;; LSP
(use-package js2-mode
  :defer t
  :mode ("\\.js\\'" . js-mode)
  :hook
  (
   (js-mode . js2-minor-mode)
   (js-mode . lsp-deferred)
   )
  :config
  ;; use xref
  (define-key js-mode-map (kbd "M-.") nil)
  )
;; END LSP

(use-package json-mode
  :defer t
  :mode ("\\.json\\'" . json-mode))




(use-package prettier
  :hook (js-mode . prettier-mode))
