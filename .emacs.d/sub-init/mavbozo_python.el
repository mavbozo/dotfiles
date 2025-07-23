;; PYTHON MODE

;; (use-package lsp-jedi
;;   :config
;;   (with-eval-after-load "lsp-mode"
;;     (add-to-list 'lsp-disabled-clients 'pyls)
;;     (add-to-list 'lsp-disabled-clients 'mspyls))
;;   :hook (python-mode . (lambda ()
;;                          (lsp-deferred))))


(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))


(defun mavbozo-python-mode-hook-fn ()
  ;; (local-set-key (kbd "SPC j e") 'py-execute-line)
  (interactive)
  (progn
    (define-prefix-command 'mavbozo/python-leader-map)
    (define-key mavbozo/python-leader-map (kbd "c r") 'py-shift-right)
    (define-key mavbozo/python-leader-map (kbd "c l") 'py-shift-left))
  (define-key python-mode-map (kbd "M-j") mavbozo/python-leader-map)
  )


;; The package is "python" but the mode is "python-mode":
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode)
  :config
  (add-hook 'python-mode-hook 'mavbozo-python-mode-hook-fn)
  (define-key python-mode-map [remap eval-last-sexp] 'py-execute-line)
  (define-key python-mode-map [remap eval-defun] 'py-execute-def)
  ;; :bind (("M-j c l" . py-shift-left)
  ;; 	 ("M-j c r" . py-shift-right))
  )




(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))


(use-package python-black
  :after python-mode
  :hook (python-mode . python-black-on-save-mode))

