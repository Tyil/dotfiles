(setq evil-want-C-u-scroll t)

(use-package evil)

(evil-mode 1)

;; Custom keybinds
; Buffers
(define-key evil-normal-state-map (kbd "SPC w -") 'split-window-below)
(define-key evil-normal-state-map (kbd "SPC w /") 'split-window-right)
(define-key evil-normal-state-map (kbd "SPC w x") 'evil-window-delete)
(define-key evil-normal-state-map (kbd "SPC w h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "SPC w j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "SPC w k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "SPC w l") 'evil-window-right)
(define-key evil-normal-state-map (kbd "SPC w w") 'evil-window-prev)
(define-key evil-normal-state-map (kbd "SPC w <") 'evil-window-decrease-width)
(define-key evil-normal-state-map (kbd "SPC w >") 'evil-window-increase-width)
(define-key evil-normal-state-map (kbd "SPC w -") 'evil-window-decrease-height)
(define-key evil-normal-state-map (kbd "SPC w +") 'evil-window-increase-height)

; Elscreen
(define-key evil-normal-state-map (kbd "SPC w c") 'elscreen-create)
(define-key evil-normal-state-map (kbd "SPC w x") 'elscreen-kill)
(define-key evil-normal-state-map (kbd "g t") 'elscreen-next)
(define-key evil-normal-state-map (kbd "SPC w n") 'elscreen-next)
(define-key evil-normal-state-map (kbd "g T") 'elscreen-previous)
(define-key evil-normal-state-map (kbd "SPC w p") 'elscreen-previous)

; Files
(define-key evil-normal-state-map (kbd "SPC f f") 'dired)
(define-key evil-normal-state-map (kbd "SPC f r") 'recentf-open-files)
(define-key evil-normal-state-map (kbd "SPC f t") (lambda ()
                                                    (interactive)
                                                    (elscreen-create)
                                                    (dired)
                                                    ))
; Projectile
(define-key evil-normal-state-map (kbd "SPC p f") 'helm-projectile)

; Git-gutter+
(define-key evil-normal-state-map (kbd "SPC v a") 'git-gutter+-stage-hunk)
(define-key evil-normal-state-map (kbd "SPC v c") 'git-gutter+-commit)
