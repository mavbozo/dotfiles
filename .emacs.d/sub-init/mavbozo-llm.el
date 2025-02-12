;;;; authinfo
(setq auth-sources
  '((:source "~/.authinfo.gpg")))

;;;; Claude
;;; Fetch API token from `auth-source` (e.g. .authinfo.gpg)
(setq gptel-anthropic-api-token (lambda () (auth-source-pick-first-password :host "api.anthropic.com")))

(setq gptel-openai-api-token (lambda () (auth-source-pick-first-password :host "api.openai.com")))

(setq gptel-openrouter-api-token (lambda () (auth-source-pick-first-password :host "openrouter.ai")))

(gptel-make-openai "openai"
  :stream t
  :key gptel-openai-api-token)

(gptel-make-anthropic "anthropic"
  :stream t
  :key gptel-anthropic-api-token)

;; OpenRouter offers an OpenAI compatible API
(gptel-make-openai "OpenRouter"               ;Any name you want
  :host "openrouter.ai"
  :endpoint "/api/v1/chat/completions"
  :stream t
  :key gptel-openrouter-api-token                   ;can be a function that returns the key
  :models '(openai/gpt-3.5-turbo
            mistralai/mixtral-8x7b-instruct
            meta-llama/codellama-34b-instruct
            codellama/codellama-70b-instruct
            google/palm-2-codechat-bison-32k
            google/gemini-pro))

(use-package gptel)

(define-prefix-command 'mavbozo/llm-keymap)
(define-key global-map (kbd "M-l") 'mavbozo/llm-keymap)
(define-key mavbozo/llm-keymap (kbd "l") 'gptel-send)
(define-key mavbozo/llm-keymap (kbd "b") 'gptel)
(define-key mavbozo/llm-keymap (kbd "m") 'gptel-menu)
(define-key mavbozo/llm-keymap (kbd "r") 'gptel-rewrite)


;; (use-package shell-maker
;;   :load-path "/home/mavbozo/.emacs.d/ext-packages/chatgpt-shell")

;; (load "/home/mavbozo/dotfiles/.emacs.d/ext-packages/claude-shell/claude-shell-fontifier.el")
;; (load "/home/mavbozo/dotfiles/.emacs.d/ext-packages/claude-shell/claude-shell.el")
