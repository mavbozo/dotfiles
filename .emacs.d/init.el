
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

;;(setq initial-buffer-choice "~/SpiderOak/Archive/T/todo.txt")

;;(setq org-agenda-files (list "~/SpiderOak/Archive/T/todo.txt"))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; set a default font
(when (member "DejaVu Sans Mono" (font-family-list))
  (set-face-attribute 'default nil :font "DejaVu Sans Mono 10"))

;; install required packages
(require 'package)
 ;; (add-to-list 'package-archives
 ;;              '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
            '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)

;; Install package when not installed
(when (not package-archive-contents)
  (package-refresh-contents))

;; My default package
;; (defvar my-packages '(yaml-mode markdown-mode emmet-mode php-mode)	
;;   "A list of packages to ensure are installed at launch.")

(defvar my-packages '(
		      ;; undo-tree
		      base16-theme which-key cider magit company rainbow-delimiters web-mode sublimity yasnippet yasnippet-snippets nginx-mode php-mode json-mode markdown-mode smartparens)	
  "A list of packages to ensure are installed at launch.")

;; Install those default packages if not yet installed
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; set undo
;;(require 'undo-tree)
;;(global-undo-tree-mode 1)
;;(defalias 'redo 'undo-tree-redo)

;; setup xah-fly-keys
(add-to-list 'load-path "~/dotfiles/submodules/xah-fly-keys")
(require 'xah-fly-keys)
(xah-fly-keys-set-layout "qwerty")
(xah-fly-keys 1)

;; remove auto save when moving to command-mode
(remove-hook 'xah-fly-command-mode-activate-hook 'xah-fly-save-buffer-if-file)

(global-set-key (kbd "<end>") 'xah-fly-insert-mode-activate)

;; setup emacs custom file 
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)


;; visual line mode
(global-visual-line-mode 1)

;; zenburn theme
;; (add-to-list 'custom-theme-load-path "~/dotfiles/submodules/zenburn-emacs")
(load-theme 'base16-default-dark t)

;; load tabbar
;; (add-to-list 'load-path "~/dotfiles/submodules/tabbar")
;; (require 'tabbar)


;; (setq tabbar-ruler-global-tabbar t) ; If you want tabbar
;; (setq tabbar-ruler-global-ruler nil) ; if you want a global ruler
;; (setq tabbar-ruler-popup-menu nil) ; If you want a popup menu.
;; (setq tabbar-ruler-popup-toolbar nil) ; If you want a popup toolbar
;; (setq tabbar-ruler-popup-scrollbar nil) ; If you want to only show the
                                        ; scroll bar when your mouse is moving.

;; (require 'tabbar)
;; (require 'tabbar-ruler)



;; ;; start tabbar
;; (tabbar-mode t)

;; disable emacs toolbar
(tool-bar-mode -1)

;; Add a buffer modification state indicator in the tab label, and place a
;; space around the label to make it looks less crowd.

;; (defadvice tabbar-buffer-tab-label (after fixup_tab_label_space_and_flag activate)
;;   (setq ad-return-value
;; 	(if (and (buffer-modified-p (tabbar-tab-value tab))
;; 		 (buffer-file-name (tabbar-tab-value tab)))
;; 	    (concat " + " (concat ad-return-value " "))
;; 	  (concat " " (concat ad-return-value " ")))))

;; Called each time the modification state of the buffer changed.

;; (defun ztl-modification-state-change ()
;;   (tabbar-set-template tabbar-current-tabset nil)
;;   (tabbar-display-update))

;; First-change-hook is called BEFORE the change is made.

;; (defun ztl-on-buffer-modification ()
;;   (set-buffer-modified-p t)
;;   (ztl-modification-state-change))
;; (add-hook 'after-save-hook 'ztl-modification-state-change)


;; This doesn't work for revert, I don't know.
;;(add-hook 'after-revert-hook 'ztl-modification-state-change)

;; (add-hook 'first-change-hook 'ztl-on-buffer-modification)


;; emacs completion mode
(add-hook 'after-init-hook 'global-company-mode)

;; clojure mode customizations
(add-hook 'clojure-mode-hook 'subword-mode)

(add-hook 'clojure-mode-hook #'yas-minor-mode)

(defun mavbozo--clojure-mode-indentation-hook ()
  ""
  ;; indentation for om or fulcro's dom
  (define-clojure-indent
    (dom/div '1)
    (dom/form '1)
    (dom/p '1)
    (dom/button '1)
    (dom/span '1)
    (dom/section '1)
    (dom/label '1)
    (dom/h1 '1)
    (dom/h2 '1)
    (dom/h3 '1)
    (dom/h4 '1)
    (dom/ul '1)
    (dom/li '1)
    ;; otplike
    (proc-defn :defn)
    (proc-fn :defn)
    (match :defn))

  (define-clojure-indent
    (defmutation '(2 :form :form (1)))
    (defquery-root '(1 :form :form (1))))
  )

(add-hook 'clojure-mode-hook #'mavbozo--clojure-mode-indentation-hook)



;; inferior clojure hook
;; (add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)

;; rainbow delimiters for all programming mode
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; CIDER setup
(load (xah-get-fullpath "sub-init/cider.el"))

;; highlight matching paren
(show-paren-mode 1)


;; UNIQUIFY
(require 'uniquify)

(setq uniquify-buffer-name-style 'post-forward
      uniquify-separator ":")


(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.htm\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))


(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(add-hook 'web-mode-hook 'my-web-mode-hook)

;; emmet-mode hook to other mode
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; line number
(global-linum-mode t)

;; markdown customization

;; (require 'mmm-mode)
;;; mmm-mode disabled and uninstalled because it made my emacs hang

;; (setq mmm-global-mode 'maybe)

;; clojure in markdown
;; (mmm-add-classes
;;  '((markdown-clojure
;;    :submode clojure-mode
;;    :front "^```clojure[\n\r]+"
;;    :back "^```$")))

;; (mmm-add-mode-ext-class 'markdown-mode nil 'markdown-clojure)

;; (setq mmm-parse-when-idle 't)

;; org-mode customization
(setq org-src-fontify-natively t)


;; keyboard quit setting
;;; esc always quits
;;(define-key minibuffer-local-map [f6] 'minibuffer-keyboard-quit)
;;(define-key minibuffer-local-ns-map [f6] 'minibuffer-keyboard-quit)
;;(define-key minibuffer-local-completion-map [f6] 'minibuffer-keyboard-quit)
;;(define-key minibuffer-local-must-match-map [f6] 'minibuffer-keyboard-quit)
;;(define-key minibuffer-local-isearch-map [f6] 'minibuffer-keyboard-quit)
;; (global-set-key [f6] 'keyboard-escape-quit)

(define-key key-translation-map (kbd "ESC") (kbd "C-g"))


;; tramp setting
(setq tramp-default-method "ssh")
(put 'narrow-to-region 'disabled nil)


;; make buffer switch command auto suggestions, also for find-file command
(ido-mode 1)

(require 'ido)

;; make ido display choices vertically
(setq ido-separator "\n")

;; display any item that contains the chars you typed
(setq ido-enable-flex-matching t)

(setq max-mini-window-height 0.5)

;; stop ido suggestion when doing a save-as
(define-key (cdr ido-minor-mode-map-entry) [remap write-file] nil)

;; set frame-title to file path
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; disable all custom themes
;; (mapcar #'disable-theme custom-enabled-themes)

(which-key-mode 1)


(require 'projectile)
(projectile-mode +1)
(require 'helm-projectile)
(helm-projectile-on)


;; UNDO REDO

(defun mavbozo-use-y-caps-as-redo ()
  (interactive)
  (xah-fly--define-keys
   xah-fly-key-map
   '(("Y" . redo))))


(defun mavbozo-use-y-regular-in-insert-mode ()
  (interactive)
  (xah-fly--define-keys
   xah-fly-key-map
   '(("Y" . nil))))

;; automatic save buffer when switching to command mode
(add-hook 'xah-fly-command-mode-activate-hook 'mavbozo-use-y-caps-as-redo)

(add-hook 'xah-fly-insert-mode-activate-hook 'mavbozo-use-y-regular-in-insert-mode)


(defun mavbozo-tramp-quit ()
  (interactive)
  (tramp-cleanup-all-buffers)
  (tramp-cleanup-all-connections)
  (message "Tramp connections and buffers cleaned up"))


(defun mavbozo-disable-all-themes ()
  (interactive)
  (mapcar #'disable-theme custom-enabled-themes)
  (message "all custom theme disabled"))


(add-to-list 'load-path "~/.emacs.d/command-frequency/")
(require 'command-frequency)
(command-frequency-mode 1)


(require 'sublimity)

(require 'sublimity-attractive)
(sublimity-attractive-hide-bars)
(sublimity-attractive-hide-fringes)
(sublimity-attractive-hide-vertical-border)

;;


;; (load (expand-file-name "~/quicklisp/slime-helper.el"))
  ;; Replace "sbcl" with the path to your implementation
;; (setq inferior-lisp-program "sbcl")

;;(when (fboundp 'slime-mode)

  ;;(defun my-slime-mode-config ()
    "For use in `slime-mode-hook'."
    ;;(local-unset-key (kbd "SPC"))
    ;; more stuff here
    ;;)

  ;;(add-hook 'slime-mode-hook 'my-slime-mode-config)

  ;;)

;;(progn
  ;; remove space from slime-autodoc-mode-map
  ;;(define-key slime-autodoc-mode-map (kbd "SPC") nil )

  ;;(define-key slime-mode-indirect-map (kbd "SPC") nil )

  ;;(define-key slime-repl-mode-map (kbd "SPC") nil )
  ;;(define-key slime-repl-mode-map (kbd ",") nil )

  ;;(define-key slime-editing-map (kbd "SPC") nil )

  
  
  ;;)


;; mavbozo major mode custom 
(load (xah-get-fullpath "sub-init/major.el"))
