;  Greg Herlein's .emacs file - collected over the years!
;
; note:  you can get a def of a keypress by using dumpkeys
;

(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
  (progn
    ;; use 180 char wide window for largeish displays
    ;; and smaller 80 column windows for smaller displays
    ;; pick whatever numbers make sense for you
    (if (> (x-display-pixel-width) 1280)
        (add-to-list 'default-frame-alist (cons 'width 120))
      (add-to-list 'default-frame-alist (cons 'width 80)))
    ;; for the height, subtract a couple hundred pixels
    ;; from the screen height (for panels, menubars and
    ;; whatnot), then divide by the height of a char to
    ;; get the height we want
    (add-to-list 'default-frame-alist 
                 (cons 'height (/ (- (x-display-pixel-height) 110) (frame-char-height)))))))
 
(set-frame-size-according-to-resolution)


;; We have CPU to spare; highlight all syntax categories.
(setq font-lock-maximum-decoration t)
(defun ask-user-about-supersession-threat (fn)
  "blatantly ignore files that changed on disk")
(defun ask-user-about-lock (file opponent)
  "always grab lock" t)
(global-auto-revert-mode 1)

;;(set-foreground-color "white")
;;(set-background-color "#708090")
;(delete-selection-mode 1)
(setq vc-follow-symlinks nil);
(setq vc-consult-headers nil);
; Dont show the GNU splash screen
(setq inhibit-startup-message t)
;
(require 'paren)
(add-to-list 'load-path "~/elisp")
;
; Make all "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)
;
;; Open unidentified files in text mode
(setq default-major-mode 'text-mode)
;
;;  (setq any mode-customization variables you want here)
;(autoload 'html-helper-mode "html-helper-mode" "HTMLHelper mode." t)
(autoload 'python-mode "python-mode" "Python Mode." t)
;(add-to-list 'auto-mode-alist '("\\.py\\" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(add-to-list 'auto-mode-alist '("\\.pl$" . c-mode))
(add-to-list 'auto-mode-alist '("\\.pm$" . c-mode))
(add-to-list 'auto-mode-alist '("\\.smil" . xml-mode))

(require 'brightscript-mode)
(add-to-list 'auto-mode-alist '("\\.brs" . brightscript-mode))

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(add-hook 'brightscript-mode-hook 'remove-dos-eol)

(setq auto-mode-alist (append '(("\\.js$" . c-mode)) auto-mode-alist))
(setq html-helper-do-write-file-hooks t)
(setq html-helper-build-new-buffer t)
(line-number-mode 1)
(column-number-mode 1)

;--Disable the menu-bar in console mode for a little more screen space. 
; You can still use F10 to access it in the minibuffer
(menu-bar-mode (if window-system 1 -1)) 

;--Highlight matching parenthesis (lifesaving when coding)
(setq show-paren-mode t)
(setq show-paren-style 'parenthesis)

; don't automatically add new lines when scrolling down at the 
; bottom of a buffer
(setq next-line-add-newlines nil)

;--Scroll just one line when hitting the bottom of the window
(setq scroll-step 1)
;
(cond ((fboundp 'global-font-lock-mode)
              ;; Turn on font-lock in all modes that support it
              (global-font-lock-mode t)
              ;; Maximum colors
              (setq font-lock-maximum-decoration t)))
;
;
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
;
;
(defun my-c-mode-common-hook ()
  ;; add my personal style and set it for the current buffer
  (c-add-style "PERSONAL" my-c-style t)
  ;; offset customizations not in my-c-style
  (c-set-offset 'member-init-intro '++)
  (setq c-basic-offset 2)
  ;;(setq-default c-basic-offset 2 c-default-style "linux")

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
)
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c-mode-common-hook '(lambda () (font-lock-mode 1)))
(setq c-basic-offset 2)

(require 'auto-complete)
(global-auto-complete-mode t)

;(transient-mark-mode t)

;; You can bind to a key like this in ~/.emacs_username:
;;(global-set-key "\C-xw" browse-url-browser-function)
;
(global-set-key ""      'delete-backward-char)
(global-set-key [delete]  'delete-char)
(global-set-key "OD"    'backward-char)              ;left arrow
(global-set-key "OC"    'forward-char)               ;right arrow
(global-set-key "[2~"   'yank)                     ;INS
(global-set-key [home]    'beginning-of-line)         
(global-set-key [end]     'end-of-line)               
(global-set-key ""      'set-mark-command)

(global-set-key [f1]      'delete-other-windows)            
(global-set-key [f2]      'save-buffer)               
(global-set-key [f3]      'compile)                  
(global-set-key [f4]      'next-error)               
(global-set-key [f5]      'visit-tags-table)

(global-set-key [f6]      'goto-line) 
(global-set-key [f7]      'my-indent-function)     
(global-set-key [f8]      'my-pop-mark-ring) 
(global-set-key [f9]     'beginning-of-buffer)      
(global-set-key [f12]     'end-of-buffer)            


;(global-set-key [f8]      'c-beginning-of-defun)    
;(global-set-key [f9]      'c-end-of-defun)          
;(global-set-key [f10]     'dos-unix)          

;(global-set-key [f11]     'beginning-of-buffer)      
;(global-set-key [f12]     'end-of-buffer)            

;(global-set-key [f7]      'c-indent-defun)     
;(global-set-key [f5]      'delete-other-windows)            
;(global-set-key [f8]      'my-pop-mark-ring)                
;(global-set-key [f9]       'dos-unix)          

;;(global-set-key [f9]    'cpp-to-c)          
;(global-set-key [f9]      'c-beginning-of-defun)    
;(global-set-key [f10]     'c-end-of-defun)          
;(global-set-key [f11]    'beginning-of-buffer)      
;(global-set-key [f12]   'end-of-buffer)            
;;(global-set-key "\033[23~" 'beginning-of-buffer)    ; f11
;;(global-set-key "\033[24~" 'end-of-buffer)          ; f12  
;
(defun my-pop-mark-ring ()
  "Jump to mark, and pop a new position for mark off the mark ring."
  (interactive)
  (set-mark-command t))
;
(defun cpp-to-c()
  (interactive)
  (re-search-forward "//")
  (replace-match "/*  ")
  (end-of-line)
  (insert "   */"))    
;
; Select everything
(defun select-all ()
  (interactive)
  (set-mark (point-min))
  (goto-char (point-max)))

; Insert the date
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%a %b %e, %Y %l:%M %p")))

; Convert from DOS > UNIX
(defun dos-unix ()
  (interactive)
    (goto-char (point-min))
      (while (search-forward "\r" nil t) (replace-match "")))
;
; Convert from UNIX > DOS
(defun unix-dos ()
  (interactive)
    (goto-char (point-min))
      (while (search-forward "\n" nil t) (replace-match "\r\n")))

;
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;

(defun my-indent-function ()
  "Find and mark the function boundaries and indent the region."
  (interactive)
  (re-search-backward "^{" )
  (setq start (point))
  (re-search-forward "^}" ) 
  (indent-region start (point) nil)
)

;; When I yank a piece of code ( known as paste in Windows lingo ) into an
;; existing function, I want it to indent itself to the proper level
;; automatically.
(defun smart-paste ()
  "Insert code from kill ring and indent to proper level"
  (interactive)
  (yank)
  (c-indent-defun))


(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(global-font-lock-mode t nil (font-lock))
 '(show-paren-mode t nil (paren))
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

