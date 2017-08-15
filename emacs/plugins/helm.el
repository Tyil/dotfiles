(use-package 'helm-config)

(global-set-key "\M-x" 'helm-M-x)
(global-set-key "\C-x\C-f" 'helm-find-files)
(global-set-key "\C-x\C-b" 'helm-buffers-list)
(global-set-key "\C-x\C-r" 'helm-recentf)

(helm-mode 1)
