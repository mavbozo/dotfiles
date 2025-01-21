;;;; ORG MODE

(defun mavbozo/org-mode-setup ()
  (visual-line-mode 1))


(defvar mavbozo-org-mode-keymap (make-keymap) "mavbozo-org-mode keymap.")
(define-key mavbozo-org-mode-keymap (kbd "M-j c l") 'org-insert-link)
(define-key mavbozo-org-mode-keymap (kbd "M-j c o") 'org-open-at-point)
(define-key mavbozo-org-mode-keymap (kbd "M-j c c") 'org-capture)
(define-key mavbozo-org-mode-keymap (kbd "M-j c ,") 'org-insert-structure-template)
(define-key mavbozo-org-mode-keymap (kbd "M-j c -") 'org-ctrl-c-minus)
(define-key mavbozo-org-mode-keymap (kbd "M-j c c") 'org-ctrl-c-ctrl-c) ;; set tag in heading
(define-key mavbozo-org-mode-keymap (kbd "M-j c w") 'org-refile)
(define-key mavbozo-org-mode-keymap (kbd "M-j p t") 'mavbozo-org/insert-custom-project-template)
(define-key mavbozo-org-mode-keymap (kbd "M-j c x e") 'org-set-effort)


(define-minor-mode mavbozo-org-mode
  "Get your foos in the right places."
  :lighter "mavbozo-org-mode"
  :keymap mavbozo-org-mode-keymap)


(use-package org
  :pin org
  :hook (org-mode . mavbozo/org-mode-setup)
  (org-mode . mavbozo-org-mode)
  :config
  
  (setq org-src-fontify-natively t))

(setq org-agenda-hide-tags-regexp ".")
(setq org-agenda-prefix-format
  '((agenda . " %i %-12:c%?-12t% s")
     (todo   . " ")
     (tags   . " %i %-12:c")
     (search . " %i %-12:c")))


(and mavbozo-personal-files-dir
  (setq org-directory (concat mavbozo-personal-files-dir "/Archive/A/org")))

;; Files
(setq org-agenda-files 
  (mapcar (lambda (f)
	    (concat org-directory "/" f)) 
    '("inbox.org" "agenda.org" "notes.org" "projects.org")))


;; Capture

;; (setq org-default-notes-file "/home/mavbozo/personal-files/Archive/A/org/capture.org")
;; (setq org-default-notes-file "/home/mavbozo/personal-files/Archive/A/org/inbox.org")
(setq org-capture-templates
  `(("i" "Inbox" entry  (file "inbox.org")
      "* TODO %^{Brief Description} %^g\n%?\nAdded: %U\n")
     ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
       ,(concat "* %? :meeting:\n" "<%<%Y-%m-%d %a %H:00>>"))
     ("n" "Note" entry  (file "notes.org")
       ,(concat "* Note (%a)\n"
          "/Entered on/ %U\n" "\n" "%?"))
    ;; ("t" "Todo" entry (file+headline "/home/mavbozo/personal-files/Archive/A/org/gtd.org" "Tasks")
    ;;    "* TODO %^{Brief Description} %^g\n%?\nAdded: %U\n")
    ;; ("j" "Journal" entry (file+datetree "/home/mavbozo/personal-files/Archive/A/org/journal.org")
    ;;   "* %?\nEntered on %U\n  %i\n  %a")
     ))

(defun org-capture-inbox ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "i"))

;;; Use full window for org-capture
(add-hook 'org-capture-mode-hook 'delete-other-windows)

;; Refile
(setq org-refile-targets
  '(("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)

;; Save the corresponding buffers
(defun gtd-save-org-buffers ()
  "Save `org-agenda-files' buffers without user confirmation.
See also `org-save-all-org-buffers'"
  (interactive)
  (message "Saving org-agenda-files buffers...")
  (save-some-buffers t (lambda () 
             (when (member (buffer-file-name) org-agenda-files) 
               t)))
  (message "Saving org-agenda-files buffers... done"))

;; Add it after refile
(advice-add 'org-refile :after
        (lambda (&rest _)
          (gtd-save-org-buffers)))

;; TODO
(setq org-todo-keywords
  '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)")))

(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))

(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

;; ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
;;  ,(concat "* %? :meeting:\n"
;;          "<%<%Y-%m-%d %a %H:00>>"))

;; (setq org-capture-templates
;;       `(("i" "Inbox" entry  (file "inbox.org")
;;         ,(concat "* TODO %?\n"
;;                  "/Entered on/ %U"))
;;         ("@" "Inbox [mu4e]" entry (file "inbox.org")
;;         ,(concat "* TODO Reply to \"%a\" %?\n"
;;                  "/Entered on/ %U"))))


;; (setq org-agenda-custom-commands
;;       '(("H" "Home Lists"
;; 	 ((agenda)
;;           (tags-todo "HOME")))
;; 	("O" "Office Lists"
;; 	 ((agenda)
;;           (tags-todo "OFFICE")))
;; 	("D" "Daily Action List"
;; 	 ((agenda "" ((org-agenda-ndays 1)
;;                       (org-agenda-sorting-strategy
;;                        (quote ((agenda time-up priority-down tag-up) )))
;;                       (org-deadline-warning-days 0)
;;                       ))))))

(setq org-agenda-custom-commands
      '(("g" "Get Things Done (GTD)"
         ((agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-deadline-warning-days 0)))
          (todo "NEXT"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format "  %i %-12:c [%e] ")
                 (org-agenda-overriding-header "\nTasks\n")))
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                   (org-agenda-format-date "")
                   (org-deadline-warning-days 7)
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                   (org-agenda-overriding-header "\nDeadlines")))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "  %?-12t% s")
                      (org-agenda-overriding-header "\nInbox\n")))
          (tags "CLOSED>=\"<today>\""
            ((org-agenda-overriding-header "\nCompleted today\n")))))))


;; (setq org-agenda-custom-commands
;;   '(("n" "Agenda and all TODOs"
;;       ((agenda "")
;; 	(alltodo "")))))



;; log time when done
(setq org-log-done 'time)

;; insert custom project template
(defun mavbozo-org/insert-custom-project-template (s)
  "insert custom project template with name s on cursor"
  (interactive "sEnter project name: ")
  (insert (format "** %s [/]                                                   
:PROPERTIES:
:CATEGORY: Project
:VISIBILITY: hide
:COOKIE_DATA: recursive todo
:END:
*** Information                                                      :info:
:PROPERTIES:
:VISIBILITY: hide
:END:
*** Notes                                                           :notes:
:PROPERTIES:
:VISIBILITY: hide
:END:
*** Tasks                                                           :tasks:
:PROPERTIES:
:VISIBILITY: content
:END:
" s)))


(defun mavbozo-org/insert-default-title (s)
  "insert org file title with name s on cursor"
  (interactive "sEnter document name: ")
  (insert (format "#+title: %s
#+author: Avi" s)))


(setq holiday-other-holidays
  '((holiday-fixed 1 1 "Tahun Baru")
     (holiday-fixed 8 17 "17 Agustusan")
     (holiday-fixed 9 16 "Maulid Nabi")
     (holiday-fixed 12 25 "Natal")
     (holiday-fixed 12 26 "Cuti Bersama Natal")))
