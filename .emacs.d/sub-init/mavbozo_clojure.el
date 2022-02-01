;; CLOJURE
(use-package clojure-mode
  :mode ("\\.clj\\'" . clojure-mode))

(use-package inf-clojure
  :commands (inf-clojure)
  :hook (clojure-mode-hook . inf-clojure-mode)
  :bind ([remap eval-last-sexp] . inf-clojure-eval-last-sexp)  
  ;; :bind  (:map term-mode-map
  ;;        ("M-p" . term-send-up)
  ;;        ("M-n" . term-send-down))

  )

