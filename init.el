(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

(setq my-packages '(color-theme-sanityinc-tomorrow
                 company
                 company-ghc
                 evil
                 evil-matchit
                 evil-leader
                 evil-jumper
                 evil-nerd-commenter
                 evil-numbers
                 evil-visualstar
                 ghc
                 git-gutter
                 haskell-mode
                 modeline-posn
                 helm
                 hi2
                 projectile))

(require 'package)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

; http://stackoverflow.com/a/15363401/516188
(dolist (pkg my-packages)
  (when (and (not (package-installed-p pkg))
           (assoc pkg package-archive-contents))
  (package-install pkg)))
  
(defun package-list-unaccounted-packages ()
  "Like `package-list-packages', but shows only the packages that
  are installed and are not in `jpk-packages'.  Useful for
  cleaning out unwanted packages."
  (interactive)
  (package-show-package-list
   (remove-if-not (lambda (x) (and (not (memq x jpk-packages))
                            (not (package-built-in-p x))
                            (package-installed-p x)))
                  (mapcar 'car package-archive-contents))))

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md#keeping-packages-up-to-date
;(let ((my-cabal-path (expand-file-name "~/.cabal/bin")))
;  (setenv "PATH" (concat my-cabal-path ":" (getenv "PATH")))
;  (add-to-list 'exec-path my-cabal-path))
;(autoload 'ghc-init "ghc" nil t)
;(autoload 'ghc-debug "ghc" nil t)
;(add-hook 'haskell-mode-hook (lambda () (ghc-init)))

; https://github.com/cofi/evil-leader
(require 'evil-leader)
(global-evil-leader-mode)

(require 'helm-config)
(helm-mode 1)

(require 'evil)
(evil-mode 1)

(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(load-theme 'sanityinc-tomorrow-night t)

(set-default-font "Droid Sans Mono 10")

(projectile-global-mode)
(setq projectile-completion-system 'helm)

; https://github.com/bbatsov/projectile/issues/184#issuecomment-62940053
; but it doesn't work...
(add-to-list 'projectile-globally-ignored-files "*.png")
(add-to-list 'grep-find-ignored-files "*.png")

;(setq visible-bell t)
(setq ring-bell-function #'ignore)

(global-git-gutter-mode +1)

; no line-wrapping by default
(setq-default truncate-lines 1)

; see this evil bug
; https://bitbucket.org/lyro/evil/issue/42/c-o-across-buffers-after-c-broken
(require 'evil-jumper)

; http://www.emacswiki.org/emacs/SmoothScrolling
; http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/
; For GNU Emacs 24.3.1 I have normal scrolling, and with the “C key” pressed, you have smooth scrolling (1 line up/down)
(global-set-key (kbd "<C-mouse-4>") 'scroll-down-line)
(global-set-key (kbd "<C-mouse-5>") 'scroll-up-line)

(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files

(column-number-mode 1)
(size-indication-mode 1)
(show-paren-mode t)

(require 'modeline-posn)

;; (setq sr-speedbar-width-x 15)
;; (setq sr-speedbar-max-width 15)
;; (require 'sr-speedbar)
;; (setq sr-speedbar-right-side nil)
;; (setq sr-speedbar-width-x 15)
;; (setq sr-speedbar-max-width 15)

; https://github.com/haskell/haskell-mode/wiki/Speedbar
;(speedbar 1)
; (speedbar-add-supported-extension ".hs")

; imenu in the GUI menus
; http://www.emacswiki.org/emacs/ImenuMode
 (defun try-to-add-imenu ()
  (condition-case nil (imenu-add-to-menubar "Navigation") (error nil)))
 (add-hook 'font-lock-mode-hook 'try-to-add-imenu)

; imenu sort by name
(setq imenu-sort-function 'imenu--sort-by-name)

; http://stackoverflow.com/a/25484975/516188
(savehist-mode 1)

; http://stackoverflow.com/a/12334932/516188
(add-to-list 'default-frame-alist '(width . 120)) 

(evil-leader/set-leader ",")
(evil-leader/set-key
  "t" 'projectile-find-file
  "e" 'projectile-recentf
  "m" 'imenu
  "," 'evilnc-comment-operator)

; http://www.emacswiki.org/RecentFiles
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)

; requires 'cabal install hasktags' and hasktags in PATH
;(setq haskell-tags-on-save t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-indent-spaces 4)
 '(haskell-indentation-ifte-offset 4)
 '(haskell-indentation-layout-offset 4)
 '(haskell-indentation-left-offset 4)
 '(haskell-indentation-starter-offset 4)
 '(haskell-indentation-where-post-offset 4)
 '(haskell-indentation-where-pre-offset 4)
 '(inhibit-startup-screen t))

;; Don't wait for any other keys after escape is pressed.
(setq evil-esc-delay 0)

(require 'evil-matchit)
(global-evil-matchit-mode 1)

(setq evilnc-hotkey-comment-operator ",,")
(require 'evil-nerd-commenter)
(evilnc-default-hotkeys)

(require 'evil-numbers)
(define-key evil-normal-state-map (kbd "C-c +") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-c -") 'evil-numbers/dec-at-pt)

; i think it's not working.
(require 'evil-visualstar)

; http://stackoverflow.com/a/1819405/516188
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

(require 'hi2)
(add-hook 'haskell-mode-hook 'turn-on-hi2)
(setq hi2-show-indentations nil)

; https://github.com/serras/emacs-haskell-tutorial/blob/master/tutorial.md#keeping-packages-up-to-date
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
; http://emacs.stackexchange.com/a/3656/2592
(define-key global-map (kbd "C-.") 'company-files)

;(add-to-list 'company-backends 'company-ghc)
;(custom-set-variables '(company-ghc-show-info t))

; SHORTCUTS TO REMEMBER:
; M-/ => quick completion
; C-x b => helm switch to buffer
; C-w s => split horizontal
; C-w v => split vertical
; C-w w => switch split
; C-x 0 => kill split (emacs)
; ,,<motion> => comment
; ,,, => comment line
; C-c p p => projectile switch project
