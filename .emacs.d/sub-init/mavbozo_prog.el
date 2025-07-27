(use-package yaml-mode
  :mode
  ("\\.yml\\'" . yaml-mode)
  ("\\.yaml\\'" . yaml-mode))


;; FLYCHECK
(use-package flycheck
  :ensure nil
  :hook
  (python-mode . flycheck-mode)
  (typescript-mode . flycheck-mode)
  (js-mode . flycheck-mode)
  (go-mode . flycheck-mode))


;; (add-to-list 'load-path (xah-get-fullpath "ext-packages/flycheck"))
;; (require 'flycheck)
;; (add-hook 'python-mode-hook #'flycheck-mode)
;; (add-hook 'js-mode-hook #'flycheck-mode)


;; (use-package flycheck
;;   :hook
;;   (python-mode . flycheck-mode)
;;   (js-mode . flycheck-mode))


;; LSP
;; --------------------------------------------------
;; load files for various programming environments


(defun mavbozo/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

;; (use-package lsp-mode
;;   :commands (lsp lsp-deferred)
;;   :hook (lsp-mode . mavbozo/lsp-mode-setup)
;;   :init
;;   (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
;;   :config
;;   (lsp-enable-which-key-integration t))


;;;; OPTIMIZATION
(setq read-process-output-max (* 1024 1024)) ;; 1mb




;; WEB MODE


(defun mavbozo/web-mode-hook-fn ()
  (interactive)
  (progn
    ;; create a keymap
    (define-prefix-command 'mavbozo/web-mode-leader-map)
    ;; add keys to it
    (define-key mavbozo/web-mode-leader-map (kbd "f") 'web-mode-fold-or-unfold)
    (define-key mavbozo/web-mode-leader-map (kbd "n") 'web-mode-navigate)
    (define-key mavbozo/web-mode-leader-map (kbd "s") 'web-mode-snippet-insert)
    (define-key mavbozo/web-mode-leader-map (kbd "m") 'web-mode-mark-and-expand)
    ;; (define-key mavbozo/mavbozo/web-mode-leader-map (kbd "c") 'cider-connect)
    ;; (define-key mavbozo/web-mode-leader-map (kbd "j") 'cider-jack-in)
    
    )
  ;; modify the major mode's key map, so that a key becomes your leader key
  (define-key web-mode-map (kbd "M-j") mavbozo/web-mode-leader-map))

(use-package web-mode
  :mode
  ("\\.html?\\'" . web-mode)
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (add-hook 'web-mode-hook 'mavbozo/web-mode-hook-fn)

  ;; (define-key web-mode-map [remap xah-goto-matching-bracket] 'web-mode-element-end)
  ;; (define-key web-mode-map [remap xah-goto-matching-bracket] 'web-mode-element-beginning )
  )


;; might need ws-butler package

(add-to-list 'load-path (xah-get-fullpath "../ext-packages/ws-butler"))

(require 'ws-butler)

;; activate ws-butler in yaml, python
(add-hook 'yaml-mode-hook #'ws-butler-mode)
(add-hook 'python-mode-hook #'ws-butler-mode)


(use-package yasnippet)

;; yasnippet-snippets
(add-to-list 'load-path (xah-get-fullpath "../ext-packages/yasnippet-snippets"))
(setq yasnippet-snippets-package-dir (xah-get-fullpath "../ext-packages/yasnippet-snippets"))
(require 'yasnippet-snippets)
;; (use-package yasnippet-snippets
;;   :load-path yasnippet-snippets-package-dir
;;   :hook (slime-mode . yas-minor-mode))

;; (add-to-list 'yas-snippet-dirs (xah-get-fullpath "../ext-packages/yasnippet-snippets"))

;; Silver Searcher
(use-package ag)

(setq string-edit-dir (xah-get-fullpath "../ext-packages/string-edit"))
;;
(use-package string-edit
  :load-path string-edit-dir)

;;;; paredit
(setq mavbozo/paredit-path (xah-get-fullpath "../ext-packages/paredit"))

(use-package paredit
  :load-path mavbozo/paredit-path)

(progn
  ;; change isearch's keys to use arrows to repeat
  (define-key paredit-mode-map (kbd "M-d") 'paredit-forward)
  (define-key paredit-mode-map (kbd "M-a") 'paredit-backward)
  (define-key paredit-mode-map (kbd "M-w") 'paredit-backward-up)
  (define-key paredit-mode-map (kbd "M-s") 'paredit-forward-down)
  (define-key paredit-mode-map (kbd "RET") 'paredit-newline))

(define-prefix-command 'mavbozo/paredit-keymap)
(define-key global-map (kbd "M-p") 'mavbozo/paredit-keymap)
(define-key mavbozo/paredit-keymap (kbd "d") 'delete-indentation)


;; add my cryptonym generator from local disk
(add-to-list 'load-path "/Users/mavbozo/yolo/bloir")
