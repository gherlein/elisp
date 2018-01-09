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

(global-set-key [f6]      'goto-line)
(global-set-key [f8]      'beginning-of-buffer)
(global-set-key [f9]      'end-of-buffer)

(add-to-list 'auto-mode-alist '("\\.ino$" . c-mode))
(add-to-list 'auto-mode-alist '("\\.pl$" . c-mode))
(add-to-list 'auto-mode-alist '("\\.pm$" . c-mode))

(autoload 'scad-mode "scad-mode" "A major mode for editing OpenSCAD code." t)
(add-to-list 'auto-mode-alist '("\\.scad$" . scad-mode))
(setq auto-mode-alist (append '(("\\.js$" . c-mode)) auto-mode-alist))

(require 'brightscript-mode)
(add-to-list 'auto-mode-alist '("\\.brs" . brightscript-mode))

;; golang stuff
(require 'go-mode)
(add-hook 'before-save-hook 'gofmt-before-save)
(when window-system (set-exec-path-from-shell-PATH))
(add-to-list 'exec-path "~/go/bin")
(defun my-go-mode-hook ()
  (add-hook 'before-save-hook 'gofmt-before-save)
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  (local-set-key (kbd "<f7>") 'go-indent-function)
  (local-set-key (kbd "<f4>") 'beginning-of-defun)
  (local-set-key (kbd "<f5>") 'end-of-defun)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)
(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

(add-hook 'text-mode-hook 'turn-on-auto-fill)
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
  (c-add-style "PERSONAL" my-c-style t)
  ;; offset customizations not in my-c-style
  (c-set-offset 'member-init-intro '++)
  (setq c-basic-offset 2)
  (setq-default c-basic-offset 2 c-default-style "linux")

  ;; other customizations
  (setq tab-width 2
	;; this will make sure spaces are used instead of tabs
	indent-tabs-mode nil)
  ;; we like auto-newline and hungry-delete
  (c-toggle-auto-hungry-state 1)
  ;; keybindings for all supported languages.  We can put these in
  ;; c-mode-base-map because c-mode-map, c++-mode-map, objc-mode-map,
  ;; java-mode-map, and idl-mode-map inherit from it.
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  (define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
  (local-set-key (kbd "<f7>") 'c-indent-function)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c-mode-common-hook '(lambda () (font-lock-mode 1)))
(setq c-basic-offset 2)

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








