(add-to-list 'load-path "~/dotfiles/submodules/xah-fly-keys")
(require 'xah-fly-keys)
(xah-fly-keys 1)
;; set key to activate command mode. (regardless what's current mode)
(global-set-key (kbd "<f8>") 'xah-fly-command-mode-activate)
(global-set-key (kbd "<escape>") 'xah-fly-command-mode-activate)
;; toggle xah-fly-keys
(global-set-key (kbd "<f7>") 'xah-fly-keys)

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
(package-initialize)

;; Install package when not installed
(when (not package-archive-contents)
  (package-refresh-contents))

;; My default package
(defvar my-packages '(helm clojure-mode company magit dash rainbow-delimiters cider inf-clojure yaml-mode markdown-mode  php-mode web-mode s)
  "A list of packages to ensure are installed at launch.")

;; Install those default packages if not yet installed
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; setup emacs custom file 
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; visual line mode
(global-visual-line-mode 1)
