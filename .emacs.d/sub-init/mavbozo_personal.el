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

;; prerequisite: set xah-fly keyboard to qwerty first.
;; make xah-fly-keys 【leader M-j】 as prefix for 'mavbozo/personal-keymap
(define-key xah-fly-leader-key-map (kbd "j") 'mavbozo/personal-keymap)

;; change xah-fly-keys 【leader j】 as prefix for my-keymap
;; prerequisite: set xah-fly keyboard to qwerty first.
(define-key xah-fly-leader-key-map (kbd "z") 'xah-fly-h-keymap)

(define-key xah-fly-leader-key-map (kbd "M-j") 'mavbozo/prog-keymap)

;; Make 《F8》 Key Do Cancel (C-g)
(define-key key-translation-map (kbd "<f8>") (kbd "C-g"))
;; Make M-f / ALT-f Key Do Cancel (C-g)
(define-key key-translation-map (kbd "M-h") (kbd "C-g"))
; Make M-p / ALT-p Key Quoted Insert (C-q)
(define-key key-translation-map (kbd "M-k") (kbd "C-q"))

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


;; mavbozo personal-key map
(define-key mavbozo/personal-keymap (kbd "n") nil)
(define-key mavbozo/personal-keymap (kbd "n s") 'swiper)
(define-key mavbozo/personal-keymap (kbd "n g") 'counsel-ag)
(define-key mavbozo/personal-keymap (kbd "n f") 'counsel-git)


;; mavbozo other keymap
(define-prefix-command 'mavbozo/f5-keymap)

(define-key mavbozo/f5-keymap (kbd "t l") 'mavbozo/load-light-theme)
(define-key mavbozo/f5-keymap (kbd "t d") 'mavbozo/load-dark-theme)
(define-key mavbozo/f5-keymap (kbd "t z") 'mavbozo/disable-all-themes)
(define-key mavbozo/f5-keymap (kbd "x r <SPC>") 'point-to-register)
(define-key mavbozo/f5-keymap (kbd "x r j") 'jump-to-register)
(define-key mavbozo/f5-keymap (kbd "m s") 'magit-status)
(define-key mavbozo/f5-keymap (kbd "o c") 'org-capture)
(define-key mavbozo/f5-keymap (kbd "o a") 'org-agenda)

;; make xah-fly-keys 【leader F5】 as prefix for mavbozo/f5-keymap
(define-key xah-fly-leader-key-map (kbd "<f5>") mavbozo/f5-keymap)


;; COPILOT
;; copilot.el package requires editorconfig package
(use-package editorconfig)

(add-to-list 'load-path "~/.emacs.d/ext-packages/copilot.el")
(require 'copilot)
(add-hook 'prog-mode-hook 'copilot-mode)
(define-key copilot-completion-map (kbd "<f5>") 'copilot-accept-completion)
;; (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
