;;; docker-compose-mode-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from docker-compose-mode.el

(autoload 'docker-compose-mode "docker-compose-mode" "\
Major mode to edit docker-compose files.

(fn)" t)
(add-to-list 'auto-mode-alist '("docker-compose.*.yml\\'" . docker-compose-mode))
(register-definition-prefixes "docker-compose-mode" '("docker-compose-"))

;;; End of scraped data

(provide 'docker-compose-mode-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; docker-compose-mode-autoloads.el ends here
