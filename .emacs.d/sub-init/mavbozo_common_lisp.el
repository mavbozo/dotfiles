;; common lisp

(defun mavbozo/slime-mode-hook-fn ()
  (interactive)
  (progn
    ;; create a keymap
    (define-prefix-command 'mavbozo/slime-leader-map)
    (define-key mavbozo/slime-leader-map (kbd "c ;") 'mavbozo/slime-eval-defun-to-comment)
    (define-key mavbozo/slime-leader-map (kbd "c x h") 'mavbozo/slime-set-default-to-buffer-connection)
    (define-key mavbozo/slime-leader-map (kbd "z") 'slime-switch-to-output-buffer)
    (define-key mavbozo/slime-leader-map (kbd "d d") 'slime-documentation)
    (define-key mavbozo/slime-leader-map (kbd "d l") 'slime-documentation-lookup)
    (define-key mavbozo/slime-leader-map (kbd "i e") 'slime-eval-last-expression-to-temp-buffer)
    )
  (define-key slime-mode-map (kbd "M-j") mavbozo/slime-leader-map)
  )

(setq slime-repo-path (xah-get-fullpath "../ext-packages/slime"))

(use-package slime
  :load-path slime-repo-path
  :config
  (setq inferior-lisp-program "sbcl")
  (define-key slime-mode-map [remap eval-last-sexp] 'slime-eval-last-expression)
  (define-key slime-mode-map [remap eval-buffer] 'slime-eval-buffer)
  (define-key slime-mode-map [remap eval-region] 'slime-eval-region)
  (require 'slime-autoloads)
  (setq slime-contribs '(slime-fancy slime-mrepl slime-indentation ;; slime-company
			  ))
  (slime-setup '(slime-fancy ;; slime-company
		  ))
  (setq lisp-indent-function 'common-lisp-indent-function)
  (setq common-lisp-style-default "sbcl")
  (add-hook 'slime-mode-hook 'mavbozo/slime-mode-hook-fn))

(use-package common-lisp-snippets
  :after (slime))


(defun mavbozo/slime-eval-defun-to-comment ()
  "Evaluate the top-level form and insert the result as a comment on a new line."
  (interactive)
  (let* ((form (slime-defun-at-point))
         (result (slime-eval `(swank:eval-and-grab-output ,form)))
	 (dreg (slime-region-for-defun-at-point))
	 (end-pos (- (cadr dreg) 1)))
    (cl-destructuring-bind (output value) result
      (progn;; save-excursion
	(end-of-defun)
	(insert (format ";; => %s" value))
	(newline)
	(goto-char end-pos)))))


(defun mavbozo/slime-set-default-to-buffer-connection ()
  "Make the default connection to be the current connection for the current buffer."
  (interactive)
  (make-local-variable 'slime-buffer-connection)
  (setq slime-buffer-connection slime-default-connection))


(defun mb1 (n)
  ;; change the name of slime connection number n
  (interactive "nConnection number:")
  (message "Connection number %d" n))

;; (use-package slime-company
;;   :after (slime company)
;;   :config (setq slime-company-completion 'fuzzy
;;                 slime-company-after-completion 'slime-company-just-one-space))

;; Setup load-path, autoloads and your lisp system
;; Not needed if you install SLIME via MELPA
;; (add-to-list 'load-path "/home/mavbozo/yolo/slime")
;; (require 'slime-autoloads)
;; (setq inferior-lisp-program "sbcl")
;; (setq slime-contribs '(slime-fancy slime-company))
;; (slime-setup '(slime-fancy slime-company))

(defun slime-eval-last-expression-to-temp-buffer ()
  "Evaluate the last expression, put its result in a temporary buffer named \"*slime-inspect-result*\"."
  (interactive)
  (let* ((expr (slime-last-expression)))
    (slime-eval-async `(swank:eval-and-grab-output ,expr)
      (lambda (result)
	(cl-destructuring-bind (output value) result
          (let* ((temp-buffer-name "*slime-inspect-result*")
		  (_ (if (get-buffer temp-buffer-name)
		       (kill-buffer temp-buffer-name)))
		  (buf (get-buffer-create temp-buffer-name)))
	    (with-current-buffer buf
	      (insert output value)
	      (lisp-mode))
	    (pop-to-buffer buf)))))))
