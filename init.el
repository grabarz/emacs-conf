; todo
; - tagi (global do c/c++ a do objc etags(?);
; - autouzupelnianie z clangiem;
; - jabber;
; - jakis fajny diff do cvs i git;
; - bookmarki;

(defvar windowsp (string-match "windows" (symbol-name system-type)))

; ustawienie rozmiarow okienka
(if windowsp
    (setq initial-frame-alist `((left . 0) (top . 0) (width . 232) (height . 63)))
    (setq initial-frame-alist `((left . 0) (top . 0) (width . 207) (height . 55))))

; ustawienie czcionki
(if windowsp
    (add-to-list 'default-frame-alist '(font . "Monaco-7.5"))
    (add-to-list 'default-frame-alist '(font . "Monaco-10")))

(global-font-lock-mode t)

; ustawienie menu i status bara
(menu-bar-mode -1)
(when (functionp 'tool-bar-mode) (tool-bar-mode -1))
(when (functionp 'scroll-bar-mode) (scroll-bar-mode -1))

; solarized theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/solarized-theme")
(load-theme 'solarized-dark t)

; przebindowanie klawiszy
(global-set-key (kbd "C-x C-b") 'buffer-menu)
(global-set-key (kbd "C-c g") 'goto-line)

; usuwamy welcome screen
(setq inhibit-splash-screen t)

; ido-mode
(ido-mode 1)

; domyslny katalog
(setq default-directory "~/" )

; natychmiastowe pokazywanie domkniec
(setq show-paren-delay 0)
(show-paren-mode t)

; ustawienia aspell'a
(setq ispell-program-name "/opt/local/bin/aspell")

; ustawienia cc-mode
(setq c-default-style "bsd" c-basic-offset 4)
(setq-default c-basic-offset 8 tab-width 8 indent-tabs-mode t)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

; dodanie przelaczania sie pomiedzy naglowkiem/implementacja
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key (kbd "C-c o") 'ff-find-other-file)))

; domyslny input mode dla lokalizacji
(custom-set-variables
 '(default-input-method "polish-slash"))

(add-to-list 'load-path "~/.emacs.d/lisp/")

; emacs-nav
(require 'nav)
(nav-disable-overeager-window-splitting) 

; global
(autoload 'gtags-mode "gtags" "" t)
(add-hook 'c-mode-common-hook '(lambda() (gtags-mode t)))
(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key (kbd "C-c t") 'gtags-find-tag)
    (local-set-key (kbd "C-c b") 'gtags-pop-stack)
    (local-set-key (kbd "C-c s") 'gtags-find-symbol)
    (local-set-key (kbd "C-c f") 'gtags-find-file)))

; globalff - locate interface
(require 'globalff)
(global-set-key (kbd "C-c l") 'globalff)
(setq globalff-search-delay 0.75)

; find-file-in-repository
;(require 'find-file-in-repository)
;(global-set-key (kbd "C-c f") 'find-file-in-repository)

; jabber.el
(add-to-list 'load-path "~/.emacs.d/jabber/")
(require 'jabber-autoloads)
