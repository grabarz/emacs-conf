; todo
; - tagi (global do c/c++ a do objc etags(?);
; - nawigacja pomiedzy plikami (locate, ack, find);
; - autouzupelnianie z clangiem;
; - kolorki solarized;
; - jabber;
; - jakis fajny diff do cvs i git;
; - bookmarki;

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
 '(default-input-method "polish-slash"))

(add-to-list 'load-path "~/.emacs.d/lisp/")

; emacs-nav
(require 'nav)
(nav-disable-overeager-window-splitting) 

; textmate
(require 'textmate)
(textmate-mode)

; global
(autoload 'gtags-mode "gtags" "" t)
(add-hook 'c-mode-hook '(lambda() (gtags-mode t)))
(add-hook 'c-mode-hook
	(lambda()
		(local-set-key (kbd "C-c t") 'gtags-find-tag)
		(local-set-key (kbd "C-c b") 'gtags-pop-stack)
		(local-set-key (kbd "C-c s") 'gtags-find-symbol)
		(local-set-key (kbd "C-c i") 'gtags-find-file)
	)
)
; - dodac klawisze do tagow C-c t, pop C-c b

; globalff - locate interface
(require 'globalff)
(global-set-key (kbd "C-c l") 'globalff)
(setq globalff-search-delay 0.75)

; find-file-in-repository
(require 'find-file-in-repository)
(global-set-key (kbd "C-c f") 'find-file-in-repository)

