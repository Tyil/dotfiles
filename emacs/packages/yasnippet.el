(use-package yasnippet)
(use-package yasnippet-snippets)

(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        "~/.emacs.d/elpa/yasnippet-snippets-*/snippets"
        ))

(yas-global-mode 1)
