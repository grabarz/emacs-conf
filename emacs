; ustawienie rozmiarow okienka
(setq initial-frame-alist `((left . 0) (top . 0) (width . 207) (height . 65)))

; ustawienie czcionki
(add-to-list 'default-frame-alist '(font . "Consolas-11"))

; przebindowanie klawiszy
(global-set-key "\C-x\C-b" 'buffer-menu)

; usuwamy welcome screen
(setq inhibit-splash-screen t)

; ido-mode
;(ido-mode 1)

; domyslny katalog
(setq default-directory "~/" )

; ustawienia cc-mode
(setq c-default-style "bsd" c-basic-offset 4)
(setq-default c-basic-offset 8 tab-width 8 indent-tabs-mode t)
(setq ispell-program-name "/opt/local/bin/aspell")

; dodanie przelaczania sie pomiedzy naglowkiem/implementacja
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key  (kbd "C-c o") 'ff-find-other-file)))

; domyslny input mode dla lokalizacji
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default-input-method "polish-slash"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; emacs-nav
(add-to-list 'load-path "~/.emacs.d/emacs-nav-49/")
(require 'nav)
(nav-disable-overeager-window-splitting) 

; textmate
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'textmate)
(textmate-mode)

