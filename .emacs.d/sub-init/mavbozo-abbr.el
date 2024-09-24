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

(define-abbrev-table 'global-abbrev-table
  '(
    ;; MIT License
    ("mitlicensereadme" "## License

Copyright (c) {{now/year}} {{developer}}

This project is licensed under the MIT License. This means you are free to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
software, under the following conditions:

- The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
- The software is provided \"as is\", without warranty of any kind, express or
  implied.

For the full license text, see the [LICENSE.txt](LICENSE.txt) file in the repository.
")
    ("mitlicenseperfile" "Copyright (c) 2024 Avicenna
This source code is licensed under the MIT license found in the
LICENSE.txt file in the root directory of this source tree.")))

;; define abbrev for specific major mode
;; the first part of the name should be the value of the variable major-mode of that mode
;; e.g. for go-mode, name should be go-mode-abbrev-table
(when (boundp 'clojure-mode-abbrev-table)
  (clear-abbrev-table clojure-mode-abbrev-table))

(define-abbrev-table 'clojure-mode-abbrev-table
  '(
    ("comment" "(comment
#_ comment-start

#_ comment-end)" )
     ("kindtable" "(kind/table
 {:column-names [:Symbol :Info]
  :row-vectors []})" xah-abbrev-ahf)
     
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


(when (boundp 'org-mode-abbrev-table)
  (clear-abbrev-table org-mode-abbrev-table))

(define-abbrev-table 'org-mode-abbrev-table
  '(
     ("example-project" "** Example [/]                                                   :example:
:PROPERTIES:
:CATEGORY: Example
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
")
    )
  )

(set-default 'abbrev-mode t)

(setq save-abbrevs nil)
