;; You most likely need to adjust this font size for your system!
(defvar mavbozo/default-font-size 200)
(defvar mavbozo/default-variable-font-size 200)

;; Make frame transparency overridable
(defvar mavbozo/frame-transparency '(100 . 100))

;; set gc cons higher during startup
;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; STARTUP TIME
(defun mavbozo/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                   (time-subtract after-init-time before-init-time)))
           gcs-done)) 

(add-hook 'emacs-startup-hook #'mavbozo/display-startup-time)


;; THEMING
(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

(column-number-mode)
;; (global-display-line-numbers-mode t)

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha mavbozo/frame-transparency)
(add-to-list 'default-frame-alist `(alpha . ,mavbozo/frame-transparency))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))



;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; workaround for elpa bad request. should be fixed in emacs 26.3
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; from http://ergoemacs.org/emacs/organize_your_dot_emacs.html
(defun xah-get-fullpath (@file-relative-path)
  "Return the full path of *file-relative-path, relative to caller's file location.

Example: If you have this line
 (xah-get-fullpath \"../xyz.el\")
in the file at
 /home/mary/emacs/emacs_lib.el
then the return value is
 /home/mary/xyz.el
Regardless how or where emacs_lib.el is called.

This function solves 2 problems.

① If you have file A, that calls the `load' on a file at B, and B calls `load' on file C using a relative path, then Emacs will complain about unable to find C. Because, emacs does not switch current directory with `load'.

To solve this problem, when your code only knows the relative path of another file C, you can use the variable `load-file-name' to get the current file's full path, then use that with the relative path to get a full path of the file you are interested.

② To know the current file's full path, emacs has 2 ways: `load-file-name' and `buffer-file-name'. If the file is loaded by `load', then `load-file-name' works but `buffer-file-name' doesn't. If the file is called by `eval-buffer', then `load-file-name' is nil. You want to be able to get the current file's full path regardless the file is run by `load' or interactively by `eval-buffer'."

  (concat (file-name-directory (or load-file-name buffer-file-name)) @file-relative-path)
  )


(setq default-directory (getenv "HOME"))  ;; set default directory
(setq make-backup-files nil) ; stop creating those backup~ files
(setq auto-save-default nil) ; stop creating those #auto-save# files
;; backup in one place. flat, no tree structure
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

(if (file-exists-p "~/.emacs.d/local_config.el")
  (load "~/.emacs.d/local_config.el")
  (message "Ensure local_config.el is setup"))

(if (boundp 'mavbozo-personal-files)
  (setq mavbozo-personal-files-dir mavbozo-personal-files)
  (message "Please setup mavbozo-personal-files in local_config.el"))


(and mavbozo-personal-files-dir
  (setq initial-buffer-choice (concat mavbozo-personal-files-dir "/Archive/A/org/inbox.org")))

;; FONT
;; set a default font in mac, default Fira Code Retina
(if (eq system-type 'darwin)
  (set-face-attribute 'default nil :font "Fira Code Retina" :height mavbozo/default-font-size)
  (progn
    ;; Set the fixed pitch face
    (when (member "DejaVu Sans Mono" (font-family-list))
      (set-face-attribute 'default nil :font "DejaVu Sans Mono 18"))))




;; WHERE EMACS SAVE THE CUSTOMIZATION
(setq custom-file "~/.emacs.d/custom.el")
;; load custom file if exists, useful for fresh install
(and (file-exists-p "~/.emacs.d/custom.el") (load custom-file))


;; INITIALIZE PACKAGE SOURCES
(require 'package)

(setq package-archives '(;; ("melpa" . "https://melpa.org/packages/")
			  ("melpa-stable" . "https://stable.melpa.org/packages/")
                          ("org" . "https://orgmode.org/elpa/")
                          ;; ("elpa" . "https://elpa.gnu.org/packages/")
			  ))

(package-initialize)

;; INSTALL PACKAGE WHEN NOT INSTALLED
(when (not package-archive-contents)
  (package-refresh-contents))

;; INITIALIZE USE-PACKAGE ON NON-LINUX PLATFORMS
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path (xah-get-fullpath ".emacs.d/ext-packages/use-package"))
  (require 'use-package)
  (setq use-package-always-ensure t))

;; SETUP XAH-FLY-KEYS
(add-to-list 'load-path "~/.emacs.d/ext-packages/xah-fly-keys")
(require 'xah-fly-keys)
(xah-fly-keys-set-layout "qwerty")
(xah-fly-keys 1)


;; THEME
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-tomorrow-night t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))


;; WHICH KEY
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 1))


;; RAINBOW DELIMITERS
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; NO LITTERING
(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))


;; change those annoying bell function to Subtly flash the modeline
;; https://www.emacswiki.org/emacs/AlarmBell
;; (setq ring-bell-function
;;       (lambda ()
;;         (let ((orig-fg (face-foreground 'mode-line)))
;;           (set-face-foreground 'mode-line "#F2804F")
;;           (run-with-idle-timer 0.1 nil
;;                                (lambda (fg) (set-face-foreground 'mode-line fg))
;;                                orig-fg))))


;; KEYFREQ
(use-package keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1)
  (setq keyfreq-excluded-commands
	'(self-insert-command
          forward-char
          backward-char
          previous-line
          next-line
	  org-self-insert-command
	  forward-word
	  dired-next-line
	  org-delete-backward-char
	  isearch-printing-char
	  dired-previous-line
	  xah-end-of-line-or-block                 
	  xah-beginning-of-line-or-block           
	  xah-cut-line-or-region
	  xah-fly-command-mode-activate
	  xah-fly-insert-mode-activate
	  save-buffer
	  backward-word
	  delete-backward-char
	  ivy-backward-delete-char
	  ivy-switch-buffer
	  xah-delete-backward-char-or-bracket-text
	  ivy-done
	  py-electric-backspace
	  xah-next-window-or-frame
	  magit-next-line)))




;;;; MAGIT

;; 2024-09-02 manually pin magit, transient, and with-editor with specific version because error: cl--generic-build-combined-method: Cyclic definition: %S: loadhist-unload-element when running git

;; use with-editor repo with tag v3.0.5
(setq with-editor-repo-path (xah-get-fullpath "ext-packages/with-editor"))
(use-package with-editor
  :load-path with-editor-repo-path)

;; use transient repo with tag v0.4.1
(setq transient-repo-path (xah-get-fullpath "ext-packages/transient/lisp"))
(use-package transient
  :load-path transient-repo-path)

;; use magit repo with tag v3.3.0
(setq magit-repo-path (xah-get-fullpath "ext-packages/magit/lisp"))
(use-package magit
  :load-path magit-repo-path
  :commands magit-status
  :config
  (setq magit-completing-read-function 'ivy-completing-read))

;; ABBREVIATION
(load (xah-get-fullpath "sub-init/mavbozo-abbr"))

(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package counsel)

;; set frame-title to file path
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; load other configurations
(load (xah-get-fullpath "sub-init/mavbozo_personal"))
(load (xah-get-fullpath "sub-init/mavbozo_prog"))
(load (xah-get-fullpath "sub-init/mavbozo_clojure"))
(load (xah-get-fullpath "sub-init/mavbozo_python"))
(load (xah-get-fullpath "sub-init/mavbozo_typescript"))
(load (xah-get-fullpath "sub-init/mavbozo_javascript"))
(load (xah-get-fullpath "sub-init/mavbozo_ocaml"))
(load (xah-get-fullpath "sub-init/mavbozo_common_lisp"))
(load (xah-get-fullpath "sub-init/mavbozo_lisp"))
(load (xah-get-fullpath "sub-init/mavbozo_org"))
(load (xah-get-fullpath "sub-init/mavbozo-nix"))


;; COMPANY MODE
(use-package company)
(add-hook 'after-init-hook 'global-company-mode)

;; FOR WSL2 Environment, display gpg prompt 
(setenv "DISPLAY"
	(string-trim-right
	 (shell-command-to-string "tail -1 /etc/resolv.conf  | cut -f 2 --delimiter ' ' | sed s/$/:0.0/")))



;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))

(put 'narrow-to-region 'disabled nil)
