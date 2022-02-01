;; You most likely need to adjust this font size for your system!
(defvar mavbozo/default-font-size 200)
(defvar mavbozo/default-variable-font-size 200)

;; Make frame transparency overridable
(defvar mavbozo/frame-transparency '(90 . 90))

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


(setq inhibit-startup-message t)

;; THEMING

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

(column-number-mode)
(global-display-line-numbers-mode t)

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

(setq initial-buffer-choice (getenv "MY_TODO_FILE"))

(setq org-agenda-files (list (getenv "MY_TODO_FILE")))


;; FONT
;; set a default font
;; (set-face-attribute 'default nil :font "Fira Code Retina" :height mavbozo/default-font-size)

;; Set the fixed pitch face
;; (set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height mavbozo/default-font-size)
(when (member "DejaVu Sans Mono" (font-family-list))
  (set-face-attribute 'default nil :font "DejaVu Sans Mono 18"))


;; WHERE EMACS SAVE THE CUSTOMIZATION
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)


;; INITIALIZE PACKAGE SOURCES
(require 'package)

(setq package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
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

;; remove auto save when moving to command-mode
(remove-hook 'xah-fly-command-mode-activate-hook 'xah-fly-save-buffer-if-file)

(global-set-key (kbd "<end>") 'xah-fly-insert-mode-activate)

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


(defun mavbozo/load-light-theme ()
  (interactive)
  (load-theme 'doom-one-light t))

(defun mavbozo/load-dark-theme ()
  (interactive)
  (load-theme 'doom-tomorrow-night t))

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

(defun mavbozo/disable-all-themes ()
  (interactive)
  (mapcar #'disable-theme custom-enabled-themes)
  (message "all custom theme disabled"))


;; COMPANY MODE
;; (use-package company)
;; (add-hook 'after-init-hook 'global-company-mode)

;; TERN MODE

;; (add-to-list 'load-path "~/.emacs.d/ext-packages/tern/emacs")
;; (autoload 'tern-mode "tern.el" nil t)

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
          next-line)))

;; PYTHON MODE
;; The package is "python" but the mode is "python-mode":
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))

(use-package python-black
  :demand t
  :after python
  :hook (python-mode . python-black-on-save-mode))

;; FLYCHECK
(use-package flycheck
  :hook (python-mode . flycheck-mode))


;; MAGIT
(use-package magit
  :commands magit-status
  :config
  (setq magit-completing-read-function 'ivy-completing-read))


(load (xah-get-fullpath "sub-init/mavbozo-abbr"))

;; ORG MODE
(use-package org
  :pin org
  :hook (org-mode . mavbozo/org-mode-setup)
  :config
  (setq org-log-done t)
  (setq org-src-fontify-natively t))

;; ORG MODE??
;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)
(defun mavbozo/org-mode-setup ()
  (visual-line-mode 1))


;; ;; IDO SETUP
;; (progn
;;   ;; make buffer switch command do suggestions, also for find-file command
;;   (require 'ido)
;;   (ido-mode 1)

;;   ;; show choices vertically
;;   (if (version< emacs-version "25")
;;       (setq ido-separator "\n")
;;     (setf (nth 2 ido-decorations) "\n"))

;;   ;; show any name that has the chars you typed
;;   (setq ido-enable-flex-matching t)

;;   ;; use current pane for newly opened file
;;   (setq ido-default-file-method 'selected-window)

;;   ;; use current pane for newly switched buffer
;;   (setq ido-default-buffer-method 'selected-window)

;;   ;; stop ido from suggesting when naming new file
;;   (define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil))


;; ICOMPLETE
;; (progn
;;   ;; minibuffer enhanced completion
;;   (require 'icomplete)
;;   (icomplete-mode 1)
;;   ;; show choices vertically
;;   (setq icomplete-separator "\n")
;;   (setq icomplete-hide-common-prefix nil)
;;   (setq icomplete-in-buffer t)

;;   (define-key icomplete-minibuffer-map (kbd "<right>") 'icomplete-forward-completions)
;;   (define-key icomplete-minibuffer-map (kbd "<left>") 'icomplete-backward-completions))
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

;; set frame-title to file path
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; CLOJURE
(use-package clojure-mode
  :mode ("\\.clj\\'" . clojure-mode))

(use-package inf-clojure
  :commands (inf-clojure)
  :hook (clojure-mode-hook . inf-clojure-mode))



;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 1000))
