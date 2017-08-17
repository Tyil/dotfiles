; Enable packages
(load "package")
(package-initialize)

; Add package repositories
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(setq package-archive-enable-alist '(("melpa" deft magit)))

; Set custom look & feel
(load-theme 'monokai t)
(global-linum-mode t)
(global-hl-line-mode t)
(load "~/.emacs.d/keys.el")

; Enable recent files on startup
(recentf-mode 1)
(setq recentf-max-menu-items 50)
(run-at-time nil (* 5 60) 'recentf-save-list)

; Define function to load entire directories
(defun load-directory (directory)
  "Load recursively all `.el' files in DIRECTORY."
  (dolist (element (directory-files-and-attributes directory nil nil nil))
    (let* ((path (car element))
           (fullpath (concat directory "/" path))
           (isdir (car (cdr element)))
           (ignore-dir (or (string= path ".") (string= path ".."))))
      (cond
       ((and (eq isdir t) (not ignore-dir))
        (load-directory fullpath))
       ((and (eq isdir nil) (string= (substring path -3) ".el"))
        (load (file-name-sans-extension fullpath)))))))

; Make use of use-package to automatically install packages if they're missing
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

; Make use-package auto-install everything
(eval-when-compile
  (require 'use-package)
  (setq use-package-always-ensure t))

; Load directory with all plugin configurations
(load-directory "~/.emacs.d/plugins")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (monokai-theme centered-cursor-mode smartparens yasnippet yasnippet-snippets rainbow-delimiters web-mode evil helm org-evil php-mode)))
 '(show-trailing-whitespace t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
