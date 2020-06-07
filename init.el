;; Add the melpa package repository
;; Remember to always use HTTPS
;;
(add-to-list 'load-path "~/elisp")
(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

;; Initialize packages;;
(package-initialize)

;; Configure basic startup
(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(customize-set-variable 'menu-bar-mode nil)
;(customize-set-variable 'tool-bar-mode nil)
(customize-set-variable 'scroll-bar-mode nil)

(set-default-font "Menlo 10")

;; basic window setups
(electric-indent-mode 0)
(setq font-lock-maximum-decoration t)
(setq next-line-add-newlines nil)
(cond ((fboundp 'global-font-lock-mode)
              ;; Turn on font-lock in all modes that support it
              (global-font-lock-mode t)
              ;; Maximum colors
              (setq font-lock-maximum-decoration t)))
(require 'auto-complete)
(global-auto-complete-mode t)

(setq vc-follow-symlinks nil);
(setq vc-consult-headers nil);
(fset 'yes-or-no-p 'y-or-n-p)
(setq default-major-mode 'text-mode)

(require 'paren)
(show-paren-mode 1)
(setq show-paren-mode t)
(setq show-paren-style 'parenthesis)

;; keymaps
;;(global-set-key "^H"      'delete-backward-char)

(global-set-key (kbd "<home>") 'beginning-of-line)
(global-set-key (kbd "<end>")  'end-of-line)

(global-set-key [f1]      'delete-other-windows)
(global-set-key [f2]      'save-buffer)
(global-set-key [f3]      'recompile)
(global-set-key [f4]      'next-error)
(global-set-key [f5]      'previous-error)

(global-set-key [f6]      'goto-line)
(global-set-key [f7]      'c-reformat-buffer)

(global-set-key [f8]      'beginning-of-buffer)
(global-set-key [f9]      'end-of-buffer)

(add-to-list 'auto-mode-alist '("\\.ino$" . c-mode))
(add-to-list 'auto-mode-alist '("\\.pl$" . c-mode))
(add-to-list 'auto-mode-alist '("\\.pm$" . c-mode))

(autoload 'scad-mode "scad-mode" "A major mode for editing OpenSCAD code." t)
(add-to-list 'auto-mode-alist '("\\.scad$" . scad-mode))



(add-to-list 'load-path "~/elisp/terraform-mode")
(add-to-list 'load-path "~/elisp/emacs-hcl-mode")
(require 'terraform-mode)
(require 'hcl-mode)
(add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-mode))
(add-hook 'terraform-mode-hook 'terraform-format-on-save-mode)


(add-to-list 'load-path "~/elisp/markdown-mode")
(require 'markdown-mode)
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))





;;(setq auto-mode-alist (append '(("\\.js$" . c-mode)) auto-mode-alist))
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js2-mode-show-strict-warnings nil)

(require 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)


(require 'brightscript-mode)
(add-to-list 'auto-mode-alist '("\\.brs" . brightscript-mode))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml" . yaml-mode))

;; golang stuff
(require 'go-mode)
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq tab-width 4)
            (setq indent-tabs-mode 1)))
(when window-system (set-exec-path-from-shell-PATH))
(add-to-list 'exec-path "~/go/bin")
(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save)
  (setq gofmt-command "goimports")   
  (if (not (string-match "go" compile-command))   ; set compile command default
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))

  ;; Key bindings specific to go-mode
  (local-set-key (kbd "M-.") 'godef-jump)         ; Go to definition
  (local-set-key (kbd "M-*") 'pop-tag-mark)       ; Return from whence you came
  (local-set-key (kbd "M-p") 'compile)            ; Invoke compiler
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  (local-set-key (kbd "<f7>") 'go-indent-function)
  (local-set-key (kbd "<f4>") 'beginning-of-defun)
  (local-set-key (kbd "<f5>") 'end-of-defun)
  
  ;; Misc go stuff
  (auto-complete-mode 1))                         ; Enable auto-complete mode

(add-hook 'go-mode-hook 'my-go-mode-hook)
(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

;(add-hook 'text-mode-hook 'turn-on-auto-fill)
(defconst my-c-style
  '((c-tab-always-indent        . t)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist     . ((substatement-open after)
				   (brace-list-open)))
    (c-hanging-colons-alist     . ((member-init-intro before)
				   (inher-intro)
				   (case-label after)
				   (label after)
				   (access-label after)))
    (c-cleanup-list             . (scope-operator
				   empty-defun-braces
				   defun-close-semi))
    (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
				   (substatement-open . 0)
				   (case-label        . 2)
				   (block-open        . 0)
				   (knr-argdecl-intro . -)))
    (c-echo-syntactic-information-p . t)
    )
  )

(defun my-c-mode-common-hook ()
  ;; add my personal style and set it for the current buffer
  (require 'cc-mode)
  (c-add-style "PERSONAL" my-c-style t)
  ;; offset customizations not in my-c-style
  (c-set-offset 'member-init-intro '++)
  (setq c-basic-offset 2)
  (setq-default c-basic-offset 2 c-default-style "linux")

  ;; other customizations
  (setq tab-width 2
	;; this will make sure spaces are used instead of tabs
	indent-tabs-mode nil)
  (c-toggle-auto-hungry-state 1)
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (add-hook 'c-mode-common-hook '(lambda () (c-toggle-auto-state 1)))
  (define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c-mode-common-hook '(lambda () (font-lock-mode 1)))


(defun c-reformat-buffer()
    (interactive)
    (save-buffer)
    (setq sh-indent-command (concat
                             "indent -st -bad --blank-lines-after-procedures "
                             "-bli0 -i4 -l79 -ncs -npcs -nut -npsl -fca "
                             "-lc79 -fc1 -cli4 -bap -sob -ci4 -nlp "
                             buffer-file-name
                             )
          )
    (mark-whole-buffer)
    (universal-argument)
    (shell-command-on-region
     (point-min)
     (point-max)
     sh-indent-command     (buffer-name)
     )
    (save-buffer)
    )

;;(define-key c-mode-base-map [f7] 'c-reformat-buffer)





;;
(add-hook 'yaml-mode-hook
	  (lambda ()
	    (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

(require 'auto-complete)
(global-auto-complete-mode t)

(defun go-indent-function ()
  "Find and mark the function boundaries and indent the region."
  (interactive)
  (re-search-backward "^func" )
  (setq start (point))
  (re-search-forward "^}" )
  (indent-region start (point) nil)
)

(defun c-indent-function ()
  "Find and mark the function boundaries and indent the region."
  (interactive)
  (re-search-backward ") {$" )
  (setq start (point))
  (re-search-forward "^}" )
  (indent-region start (point) nil)
)


(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))








