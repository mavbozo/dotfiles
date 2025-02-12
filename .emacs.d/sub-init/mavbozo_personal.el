;; require xah-fly-keys

(defun mavbozo/xah-fly-keys-mode ()
  (interactive)
  (xah-fly-keys 1))

(global-set-key (kbd "<f6>") 'mavbozo/xah-fly-keys-mode)

;; remove auto save when moving to command-mode
(remove-hook 'xah-fly-command-mode-activate-hook 'xah-fly-save-buffer-if-file)

(global-set-key (kbd "<end>") 'xah-fly-command-mode-activate)

;; mavbozo & xah-fly-keys
(define-prefix-command 'mavbozo/personal-keymap)
(define-prefix-command 'mavbozo/prog-keymap)

;; my personal keymap prefix 
(define-key global-map (kbd "M-k") 'mavbozo/personal-keymap)


(define-key xah-fly-leader-key-map (kbd "SPC") 'xah-fly-insert-mode-activate)

;; Make 《F8》 Key Do Cancel (C-g)
(define-key key-translation-map (kbd "<f8>") (kbd "C-g"))
;; Make M-f / ALT-f Key Do Cancel (C-g)
(define-key key-translation-map (kbd "M-h") (kbd "C-g"))
;; Make M-p / ALT-p Key Quoted Insert (C-q)
;; (define-key key-translation-map (kbd "M-k") (kbd "C-q"))

(defun mavbozo/load-light-theme ()
  (interactive)
  (load-theme 'doom-tomorrow-day t))

(defun mavbozo/load-dark-theme ()
  (interactive)
  (load-theme 'doom-tomorrow-night t))

(defun mavbozo/disable-all-themes ()
  (interactive)
  (mapcar #'disable-theme custom-enabled-themes)
  (message "all custom theme disabled"))

;; http://camdez.com/blog/2013/11/14/emacs-show-buffer-file-name/
(defun mavbozo/show-and-copy-buffer-filename ()
  "Show the full path to the current file in the minibuffer and copy to clipboard."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name
        (progn
          (message file-name)
          (kill-new file-name))
      (error "Buffer not visiting a file"))))

;; bind revert buffer to 【leader /】SPC-i-e
;; (define-key xah-fly-c-keymap (kbd "/") 'revert-buffer)

;; mavbozo personal-key map
(define-key mavbozo/personal-keymap (kbd "s") 'swiper)
(define-key mavbozo/personal-keymap (kbd "g") 'counsel-ag)
(define-key mavbozo/personal-keymap (kbd "f") 'counsel-git)
(define-key mavbozo/personal-keymap (kbd "c") 'counsel-company)


;; mavbozo other keymap
(define-prefix-command 'mavbozo/f5-keymap)

(define-key mavbozo/f5-keymap (kbd "t l") 'mavbozo/load-light-theme)
(define-key mavbozo/f5-keymap (kbd "t d") 'mavbozo/load-dark-theme)
(define-key mavbozo/f5-keymap (kbd "t z") 'mavbozo/disable-all-themes)
(define-key mavbozo/f5-keymap (kbd "x r <SPC>") 'point-to-register)
(define-key mavbozo/f5-keymap (kbd "x r j") 'jump-to-register)
(define-key mavbozo/f5-keymap (kbd "m s") 'magit-status)
(define-key mavbozo/f5-keymap (kbd "o c") 'org-capture)
(define-key mavbozo/f5-keymap (kbd "o i") 'org-capture-inbox)
(define-key mavbozo/f5-keymap (kbd "o a") 'org-agenda)
(define-key mavbozo/f5-keymap (kbd "s e") 'string-edit-at-point)

;; make xah-fly-keys 【leader F5】 as prefix for mavbozo/f5-keymap
(define-key xah-fly-leader-key-map (kbd "<f5>") mavbozo/f5-keymap)


;; COPILOT
;; copilot.el package requires editorconfig package
;; (use-package editorconfig)

;; (add-to-list 'load-path "~/.emacs.d/ext-packages/copilot.el")
;; (require 'copilot)
;; (add-hook 'prog-mode-hook 'copilot-mode)
;; (define-key copilot-completion-map (kbd "<f5>") 'copilot-accept-completion)
;; ;; (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)


;; Default set to t, slow down when scrolling with mark on.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Primary-Selection.html
(setq select-active-regions nil)
