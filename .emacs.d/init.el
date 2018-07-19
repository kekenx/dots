(setq load-path (cons"~/.emacs.d/elisp" load-path))
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)
(defun ensure-package-installed (&rest packages)
    "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
    (mapcar
     (lambda (package)
       ;; (package-installed-p 'evil)
       (if (package-installed-p package)
	   nil
	 (if (y-or-n-p (format "Package %s is missing. Install it? " package))
	     (package-install package)
	   package)))
     packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(ensure-package-installed 'go-mode 'python-mode 'auto-complete 'rjsx-mode 'matlab-mode 'typescript-mode 'ag 'company 'company-go 'helm 'helm-ag)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes (quote (manoj-dark)))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (ag helm-ag helm matlab-mode rjsx-mode typescript-mode python-mode go-mode auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:stipple nil :background "black" :foreground "white" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :family "Inconsolata")))))

(setq backup-inhibited t)
(setq auto-save-default nil)

(put 'downcase-region 'disabled nil)

(require 'auto-complete)
(require 'auto-complete-config) 
(global-auto-complete-mode t)

(menu-bar-mode -1)

(which-function-mode 1)

;; full path to this file
(setq frame-title-format "%f")

;; (require 'install-elisp)
;; (setq install-elisp-repository-directory "~/.emacs.d/elisp/")

;; disable case sensitive when searching for a file
(setq completion-ignore-case t)

;; auto reload for buffer
(global-auto-revert-mode 1)

;; (defface hlline-face
;;   '((((class color)
;;       (background dark))
;;      (:background "darkslate gray"))
;;     (((class color)
;;       (background light))
;;      (:background "#FFFFFFF"))
;;     (t
;;      ()))
;;   "*Face used by hl-line.")
;; (setq hl-line-face 'hlline-face)
;; (global-hl-line-mode)

(defun split-window-vertically-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-vertically)
    (progn
      (split-window-vertically
       (- (window-height) (/ (window-height) num_wins)))
      (split-window-vertically-n (- num_wins 1)))))
(defun split-window-horizontally-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-horizontally)
    (progn
      (split-window-horizontally
       (- (window-width) (/ (window-width) num_wins)))
      (split-window-horizontally-n (- num_wins 1)))))

(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (if (>= (window-body-width) 270)
        (split-window-horizontally-n 3)
      (split-window-horizontally)))
  (other-window 1))

(global-set-key (kbd "C-t") 'other-window-or-split)

(require 'typescript-mode)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

(global-set-key (kbd "C-z") 'eshell)

;; rjsx-mode configuration
(add-to-list 'auto-mode-alist '(".*\\.js\\'" . rjsx-mode))

;; golang configuration
;;; Setup

(require 'company)                                   ; load company mode
(require 'company-go)                                ; load company mode go backend

;;; Possible improvements

(setq company-tooltip-limit 20)                      ; bigger popup window
(setq company-idle-delay .3)                         ; decrease delay before autocompletion popup shows
(setq company-echo-delay 0)                          ; remove annoying blinking
(setq company-begin-commands '(self-insert-command)) ; start autocompletion only after typing

;;; Only use company-mode with company-go in go-mode

;; (add-hook 'go-mode-hook (lambda ()
;;                           (set (make-local-variable 'company-backends) '(company-go))
;;                           (company-mode)))

;; ;;; Color customization

;; (custom-set-faces
;;  '(company-preview
;;    ((t (:foreground "darkgray" :underline t))))
;;  '(company-preview-common
;;    ((t (:inherit company-preview))))
;;  '(company-tooltip
;;    ((t (:background "lightgray" :foreground "black"))))
;;  '(company-tooltip-selection
;;    ((t (:background "steelblue" :foreground "white"))))
;;  '(company-tooltip-common
;;    ((((type x)) (:inherit company-tooltip :weight bold))
;;     (t (:inherit company-tooltip))))
;;  '(company-tooltip-common-selection
;;    ((((type x)) (:inherit company-tooltip-selection :weight bold))
;;     (t (:inherit company-tooltip-selection)))))

;; go
(require 'go-mode)
(require 'company-go)

(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook 'flycheck-mode)
(add-hook 'go-mode-hook (lambda()
           (add-hook 'before-save-hook' 'gofmt-before-save)
           (local-set-key (kbd "M-.") 'godef-jump)
           (set (make-local-variable 'company-backends) '(company-go))
           (company-mode)
           (setq indent-tabs-mode nil)    
           (setq c-basic-offset 8)        
           (setq tab-width 8)))

;; helm
(require 'helm-config)
(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-g") 'helm-do-grep-ag)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
(put 'upcase-region 'disabled nil)

(defun helm-ag-project-root ()
  (interactive)
  (let ((rootdir (helm-ag--project-root)))
    (unless rootdir
      (error "Could not find the project root. Create a git, hg, or svn repository there first. "))
    (helm-ag rootdir)))

(defun helm-ag--project-root ()
  (cl-loop for dir in '(".git/" ".hg/" ".svn/" ".git")
           when (locate-dominating-file default-directory dir)
           return it))
(global-set-key (kbd "M-p") 'helm-ag-project-root)
