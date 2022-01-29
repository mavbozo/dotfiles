;; -*- coding: utf-8; lexical-binding: t; -*-
;; sample use of abbrev

(clear-abbrev-table global-abbrev-table)

;; define abbrev for specific major mode
;; the first part of the name should be the value of the variable major-mode of that mode
;; e.g. for go-mode, name should be go-mode-abbrev-table

(when (boundp 'python-mode-abbrev-table)
  (clear-abbrev-table python-mode-abbrev-table))


(define-abbrev-table 'python-mode-abbrev-table
  '(
    ("def"  "def fun ():
  \"\"\"
  \"\"\"
  out = None
  return None
")
    ("logi" "logging.info()")
    ("logd" "logging.debug()")
    ("logw" "logging.warn()")
    ("loge" "logging.error()")
    )
  )

(set-default 'abbrev-mode t)

(setq save-abbrevs nil)
