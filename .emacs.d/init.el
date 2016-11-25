(setq default-directory (getenv "HOME"))  ;; set default directory
(setq make-backup-files nil) ; stop creating those backup~ files
(setq auto-save-default nil) ; stop creating those #auto-save# files

(setq initial-buffer-choice "~/SpiderOak/Archive/T/todo.txt")

(setq org-agenda-files (list "~/SpiderOak/Archive/T/todo.txt"))
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
            '("melpa-stable" . "http://stable.melpa.org/packages/"))
(package-initialize)

;; Install package when not installed
(when (not package-archive-contents)
  (package-refresh-contents))

;; My default package
(defvar my-packages '(helm clojure-mode company magit dash rainbow-delimiters cider inf-clojure yaml-mode markdown-mode emmet-mode php-mode web-mode s undo-tree yasnippet nginx-mode base16-theme)
  "A list of packages to ensure are installed at launch.")

;; Install those default packages if not yet installed
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; yasnippet
(require 'yasnippet)

(setq yas-snippet-dirs
      '("~/dotfiles/submodules/yasnippet-snippets"))

(yas-reload-all)


;; set undo
(require 'undo-tree)
(global-undo-tree-mode 1)
(defalias 'redo 'undo-tree-redo)

;; setup xah-fly-keys
(add-to-list 'load-path "~/dotfiles/submodules/xah-fly-keys")
(require 'xah-fly-keys)
(xah-fly-keys 1)

;; (global-set-key (kbd "<end>") 'xah-fly-insert-mode-activate)

;; setup emacs custom file 
(setq custom-file "~/.emacs.d/custom.el")
;;(load custom-file)


;; visual line mode
(global-visual-line-mode 1)

;; zenburn theme
;; (add-to-list 'custom-theme-load-path "~/dotfiles/submodules/zenburn-emacs")
(load-theme 'base16-default-dark t)

;; load tabbar
;; (add-to-list 'load-path "~/dotfiles/submodules/tabbar")
;; (require 'tabbar)


(setq tabbar-ruler-global-tabbar t) ; If you want tabbar
(setq tabbar-ruler-global-ruler nil) ; if you want a global ruler
(setq tabbar-ruler-popup-menu nil) ; If you want a popup menu.
(setq tabbar-ruler-popup-toolbar nil) ; If you want a popup toolbar
(setq tabbar-ruler-popup-scrollbar nil) ; If you want to only show the
                                        ; scroll bar when your mouse is moving.
(require 'tabbar-ruler)



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

;; inferior clojure hook
;; (add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)

;; rainbow delimiters for all programming mode
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; CIDER setup
(add-hook 'cider-repl-mode-hook 'subword-mode)

(add-hook 'cider-repl-mode-hook 'rainbow-delimiters-mode)

(setq cider-auto-select-error-buffer nil)

(setq cider-refresh-before-fn "dev/stop"
      cider-refresh-after-fn "dev/go")


(setq cider-repl-prompt-function 'cider-repl-prompt-abbreviated)

(defun cider-dev>reset ()
  "dev>(reset). convenient function to reset my clojure development system"
  (interactive)
  (cider-switch-to-repl-buffer)
  (insert "(dev/reset)")
  (cider-repl-return)
  (cider-switch-to-last-clojure-buffer))


(defun cider-dev>c.t.n.repl/refresh ()
  "dev>(reset). convenient function to reset my clojure development system"
  (interactive)
  (cider-switch-to-repl-buffer)
  (insert "(clojure.tools.namespace.repl/refresh)")
  (cider-repl-return)
  (cider-switch-to-last-clojure-buffer))



;; for cider-jack-in-clojurescript
(setq cider-cljs-lein-repl
      "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")


;; manually start figwheel server & repl
(defun cider-figwheel-repl ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(require 'figwheel-sidecar.repl-api)
             (figwheel-sidecar.repl-api/start-figwheel!) ; idempotent
             (figwheel-sidecar.repl-api/cljs-repl)")
    (cider-repl-return)))


;; highlight matching paren
(show-paren-mode 1)


;; UNIQUIFY
(require 'uniquify)

(setq uniquify-buffer-name-style 'post-forward
      uniquify-separator ":")



(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.blade\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode)) (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode)) (add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode)) (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode)) (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode)) (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode)) (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

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
(global-set-key [f6] 'keyboard-escape-quit)

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
