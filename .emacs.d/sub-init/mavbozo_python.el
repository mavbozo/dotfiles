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

