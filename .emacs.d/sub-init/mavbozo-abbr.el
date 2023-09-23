;; -*- coding: utf-8; lexical-binding: t; -*-

(defun xah-abbrev-ahf ()
  "Abbrev hook function, used for `define-abbrev'.
 Our use is to prevent inserting the char that triggered expansion. Experimental.
 the “ahf” stand for abbrev hook function.
Version 2016-10-24"
  t)

(put 'xah-abbrev-ahf 'no-self-insert t)

;; sample use of abbrev

(clear-abbrev-table global-abbrev-table)

;; define abbrev for specific major mode
;; the first part of the name should be the value of the variable major-mode of that mode
;; e.g. for go-mode, name should be go-mode-abbrev-table
(when (boundp 'clojure-mode-abbrev-table)
  (clear-abbrev-table clojure-mode-abbrev-table))

(define-abbrev-table 'clojure-mode-abbrev-table
  '(
    ("require" "(:require [])" xah-abbrev-ahf)
    ("import" "(:import ())")
    ("prl" "(println \"\")")
    ("defn" "(defn foo
  \"\"
  []
  )" xah-abbrev-ahf)
    ("def" "(def foo")
    ("defrecord" "(defrecord Foo [])")

    ("interceptor" "(interceptor
 {:name :name
  :enter
  (fn [{:keys [request response] :as ctx}]
    ctx)})")

    ("comment" "(comment
;; comment start




;; comment end
)" xah-abbrev-ahf)
    )
  
  )


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
