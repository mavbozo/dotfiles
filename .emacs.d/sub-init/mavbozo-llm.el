;;;; authinfo
(setq auth-sources
  '((:source "~/.authinfo.gpg")))

    

(use-package gptel
  :init
  ;;;; Claude
;;; Fetch API token from `auth-source` (e.g. .authinfo.gpg)
  (setq gptel-anthropic-api-token (lambda () (auth-source-pick-first-password :host "api.anthropic.com")))

  (setq gptel-openai-api-token (lambda () (auth-source-pick-first-password :host "api.openai.com")))

  (setq gptel-openrouter-api-token (lambda () (auth-source-pick-first-password :host "openrouter.ai")))

  :config
  
  ;; backend setup
  (gptel-make-openai "openai"
    :stream t
    :key gptel-openai-api-token)

  (gptel-make-anthropic "anthropic"
    :stream t
    :key gptel-anthropic-api-token
    )

  ;; Default OpenRouter offers an OpenAI compatible API
  (setq gpt-model 'deepseek/deepseek-chat
    gptel-backend (gptel-make-openai "OpenRouter" ;Any name you want
		    :host "openrouter.ai"
		    :endpoint "/api/v1/chat/completions"
		    :stream t
		    :key gptel-openrouter-api-token ;can be a function that returns the key
		    :models '(deepseek/deepseek-r1-0528
			       deepseek/deepseek-chat-v3-0324
			       deepseek/deepseek-r1
			       anthropic/claude-3.7-sonnet:beta
			       anthropic/claude-3.5-sonnet:beta
			       anthropic/claude-3-opus:beta
			       anthropic/claude-3.5-haiku-20241022:beta
			       openai/gpt-4o-2024-11-20
			       openai/o1
			       google/gemini-2.5-pro-preview-03-25
			       z-ai/glm-4.5
			       mistralai/mistral-large
			       qwen/qwen3-14b
			       cognitivecomputations/dolphin-mistral-24b-venice-edition:free
			       )))
  
  ;; setup other keys because xah-fly-keys overshadows the default keys

  (defvar my-gptel-menu-keys-set nil
    "Flag to indicate if gptel-menu keys have been set.")
  
  (defun setup-gptel-menu-keys ()
    (when (and (fboundp 'gptel-menu) (not my-gptel-menu-keys-set))
      (with-eval-after-load 'transient
	(transient-suffix-put 'gptel-menu (kbd "RET") :key "M-RET"))
      (setq my-gptel-menu-keys-set t)))
  
  (advice-add 'gptel-menu :before #'setup-gptel-menu-keys)

  (defvar my-gptel-rewrite-keys-set nil
    "Flag to indicate if gptel-rewrite keys have been set.")

  (defun setup-gptel-rewrite-keys ()
    (when (and (fboundp 'gptel-menu) (not my-gptel-rewrite-keys-set))
      (with-eval-after-load 'transient
	(transient-suffix-put 'gptel-rewrite (kbd "d") :key "M-d")
	(transient-suffix-put 'gptel-rewrite (kbd "r") :key "M-r"))
      (setq my-gptel-rewrite-keys-set t)))

  (advice-add 'gptel-rewrite :before #'setup-gptel-rewrite-keys)
  )


(define-prefix-command 'mavbozo/llm-keymap)
(define-key global-map (kbd "M-l") 'mavbozo/llm-keymap)
(define-key mavbozo/llm-keymap (kbd "l") 'gptel-send)
(define-key mavbozo/llm-keymap (kbd "b") 'gptel)
(define-key mavbozo/llm-keymap (kbd "m") 'gptel-menu)
(define-key mavbozo/llm-keymap (kbd "r") 'gptel-rewrite)
(define-key mavbozo/llm-keymap (kbd "t r") 'mavbozo/remove-gptel-text-property)


;; enable more advanced settings in gptel-menu
(setq gptel-expert-commands 1)

(defun mavbozo/count-prompt-token ()
  (interactive)
  (let ((json-prompt (gptel--create-prompt)))
    (message "%s" json-prompt)))

;; (use-package shell-maker
;;   :load-path "/home/mavbozo/.emacs.d/ext-packages/chatgpt-shell")

;; (load "/home/mavbozo/dotfiles/.emacs.d/ext-packages/claude-shell/claude-shell-fontifier.el")
;; (load "/home/mavbozo/dotfiles/.emacs.d/ext-packages/claude-shell/claude-shell.el")

(defun mavbozo/remove-gptel-text-property ()
  "Remove the `gptel` text property from the selected region."
  (interactive)
  (when (use-region-p)
    (remove-text-properties (region-beginning) (region-end) '(gptel nil))))

(defun call-anthropic-token-count (anthropic-key &optional system-prompt user-prompt)
  (let* ((system-prompt (or system-prompt "You are a scientist"))
          (json-data (json-encode
                       `(("model" . "claude-3-5-sonnet-20241022")
			  ("system" . ,system-prompt)
			  ("messages" . ,(vconcat user-prompt))))))
    ;; pass
    (with-temp-buffer
      (call-process "curl" nil t nil
        "-s"
        "-o" "-"
        "https://api.anthropic.com/v1/messages/count_tokens"
        "-H" (concat "x-api-key: " anthropic-key)
        "-H" "content-type: application/json"
        "-H" "anthropic-version: 2023-06-01"
        "-d" json-data)
      (json-parse-string (buffer-string) :object-type 'alist))))


(defun gptel-get-current-prompt ()
  "Return the system prompt and message list that would be sent by `gptel-send'.
Returns a plist with :system and :messages keys, where
- :system is the system prompt string
- :messages is a list of prompts with alternating user messages and LLM responses."
  (save-excursion
    (gptel--sanitize-model)
    (let* ((directive (gptel--parse-directive gptel--system-message))
           (gptel--system-message
            (if (and gptel-context--alist
                     (eq gptel-use-context 'system)
                     (not (gptel--model-capable-p 'nosystem)))
                (gptel-context--wrap (car directive))
              (car directive)))
           (start-marker (gptel--at-word-end (point-marker)))
           (messages
            (nconc
             (cdr directive)             
             (gptel--create-prompt start-marker))))
      (list :system gptel--system-message
        :messages messages))))

;; I want to call call-anthropic-token-count where the anthropic-key parameter is provided by (funcall gptel-anthropic-api-token), get the system and user-message from calling gptel-get-current-prompt
;;

(defun count-tokens-before-send ()
  (interactive)
  (let* ((prompt-data (gptel-get-current-prompt))
         (system-message (plist-get prompt-data :system))
         (messages (plist-get prompt-data :messages))
         (result (call-anthropic-token-count 
                  (funcall gptel-anthropic-api-token)
                  system-message
                  messages))
         (token-count (cdr (assoc 'input_tokens result))))
    (message "Token count: %s" token-count)))
