;; INSTALL PACKAGES 
;; -------------------------------

(require 'package) 
(package-initialize) 
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages
  '(aggressive-indent
    rainbow-mode
    rainbow-delimiters
    yasnippet
    auto-complete
    flycheck
    rtags
    company
    rust-mode
    flycheck-rust
    cargo
    racer 
    cider
    ac-cider
    lispy
    multiple-cursors
    magit))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      my-packages)

;; AUTOMATICALLY ADDED
;; ------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (lispy aggressive-indent racer cargo flycheck-rust rust-mode ## anaconda-mode rainbow-mode rainbow-delimiters auto-complete flycheck rtags company))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; BASIC CUSTOMIZATION
;; ------------------------------
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)
(setq inhibit-startup-message t)
(global-linum-mode t)
(ido-mode 1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'hc-zenburn t)

(global-aggressive-indent-mode 1)

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; SETUP PYTHON
;; ------------------------------
;;(load-file "~/.emacs.d/emacs-for-python/epy-init.el")
;;(require 'epy-setup)
;;(require 'epy-python)
;;(require 'epy-completion)
;;(require 'epy-editing)

;; Setup helm
;;(require 'helm-config)			
;;(global-set-key (kbd "M-x") 'helm-M-x)

;; Setup Rainbow
(require 'rainbow-delimiters)

;; Setup Company
(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0)

;; Setup rtags
(require 'rtags)
(require 'company-rtags)
(setq rtags-completions-enabled t)
(eval-after-load 'company
  '(add-to-list
    'company-backends 'company-rtags))
(setq rtags-autostart-diagnostics t)
(rtags-enable-standard-keybindings)

;; Setup flycheck
(require 'flycheck-rtags)

;; Integrate rtags + flycheck
(defun my-flycheck-rtags-setup ()
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
  (setq-local flycheck-check-syntax-automatically nil))
(add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)

;; My customized C++ Mode Hook
(defun my-cpp-mode-hook ()
  (auto-fill-mode)
  (c-toggle-auto-hungry-state 1)
  (flycheck-mode))

(add-hook 'c++-mode-hook 'my-cpp-mode-hook)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(add-hook 'python-mode-hook 'anaconda-mode)


;; Setup Rust


(add-hook 'rust-mode-hook
	  (lambda ()
            (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))

(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "~/SourceCodes/rust/src") ;; Rust source code PATH


(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook 'racer-mode)
(add-hook 'rust-mode-hook 'flycheck-mode)
(add-hook 'racer-mode-hook 'eldoc-mode)
(add-hook 'racer-mode-hook 'company-mode)
(add-hook 'flycheck-mode-hook 'flycheck-rust-setup)
(add-hook 'rust-mode-hook (lambda () (local-set-key (kbd "C-c <tab>") 'rust-format-buffer)))

(yas-global-mode 1)

;;(define-key yas-keymap (kbd "<backtab>") 'yas-prev-field)
(define-key yas-minor-mode-map (kbd "<backtab>") 'yas-prev-field)

;; Customize Clojure
(add-hook 'clojure-mode-hook 'enable-paredit-mode)
(add-hook 'clojure-mode-hook 'subword-mode)

;; nREPL customizations
(setq nrepl-hide-special-buffers t)       ; Don't show buffers like connection or server
(setq nrepl-popup-on-error nil)           ; Don't popup new buffer for errors (show in nrepl buffer)
(setq nrepl-popup-stacktraces-in-repl t)                          ; Display stacktrace inline
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode) 
(add-hook 'nrepl-mode-hook 'paredit-mode)                         
(add-to-list 'same-window-buffer-names "*nrepl*")               ; Make C-c C-z switch to *nrepl*

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
					;(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
					;(add-hook 'clojure-mode-hook          #'enable-paredit-mode)
					;(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
(add-hook 'clojure-mode-hook    (lambda () (lispy-mode 1)))
