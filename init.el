; todo
; - tagi (global do c/c++ a do objc etags(?);
; - autouzupelnianie z clangiem;
; - jakis fajny diff do cvs i git;
; - zrobic przadek z backupfiles;
;

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
(if (not window-system) (menu-bar-mode -1))
(when (functionp 'tool-bar-mode) (tool-bar-mode -1))
(when (functionp 'scroll-bar-mode) (scroll-bar-mode -1))

; themesy
(add-to-list 'custom-theme-load-path "~/.emacs.d/solarized-theme")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'zenburn t)

; funkcja odpalajaca zamiennik cmd.exe w windowsie
(defun run-cmd-exe()
  (interactive)
  (let ((proc (start-process "console" nil "console.exe" "/C" "start" "console.exe")))
	(set-process-query-on-exit-flag proc nil)))

; przebindowanie klawiszy
(global-set-key (kbd "C-c g") 'goto-line)
(global-set-key (kbd "C-<tab>") 'next-multiframe-window)
(global-set-key (kbd "C-;") 'shrink-window-horizontally)
(global-set-key (kbd "C-'") 'enlarge-window-horizontally)
(global-set-key (kbd "C-:") 'shrink-window)
(global-set-key (kbd "C-\"") 'enlarge-window)
(windmove-default-keybindings) ; poruszanie sie po oknach
(if windowsp
  (global-set-key (kbd "<f2>") 'run-cmd-exe)
  (global-set-key (kbd "<f2>") 'eshell))

; ibuffer zamias buffer-menut
(defalias 'list-buffers 'ibuffer)

; usuwamy welcome screen
(setq inhibit-splash-screen t)

; ido-mode
(ido-mode 1)

; zmiana yes/no na y/n
(fset 'yes-or-no-p 'y-or-n-p)

; domyslny katalog
(setq default-directory "~/" )

; natychmiastowe pokazywanie domkniec
(setq show-paren-delay 0)
(show-paren-mode t)

; nie potrzebuje nowej lini na koncu pliku
(setq require-final-newline nil)

; ustawienia aspell'a
(setq ispell-program-name "/opt/local/bin/aspell")

; ustawienia cc-mode
(setq c-default-style "bsd" c-basic-offset 4)
(setq-default c-basic-offset 4 tab-width 4 indent-tabs-mode t)
(if windowsp
   (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)))

; dodanie przelaczania sie pomiedzy naglowkiem/implementacja
(add-hook 'c-mode-common-hook
  (lambda() 
    (local-set-key (kbd "C-c o") 'ff-find-other-file)))

; domyslny input mode dla lokalizacji
(custom-set-variables
 '(default-input-method "polish-slash"))

; kodowanie latin2 tylko dla windy
(when windowsp
   (setq locale-coding-system 'cp1250)
   (set-terminal-coding-system 'cp1250)
   (set-keyboard-coding-system 'cp1250)
   (set-selection-coding-system 'cp1250)
   (prefer-coding-system 'cp1250)
)

; pluginy
(add-to-list 'load-path "~/.emacs.d/lisp/")

; ustawienie direda
(add-hook 'dired-mode-hook 'hl-line-mode)
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))
(setq dired-dwim-target t)
(require 'dired+)
(if windowsp
   (setq dired-listing-switches "-lahgo")
   (setq dired-listing-switches "-lBha"))

; switch window do przelaczania okienek
(if window-system
	(require 'switch-window))

; emacs-nav
(require 'nav)
(nav-disable-overeager-window-splitting) 

; global
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-ignore-case nil)
(add-hook 'c-mode-common-hook '(lambda() (gtags-mode t)))
(add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key (kbd "C-c t") 'gtags-find-tag)
    (local-set-key (kbd "C-c b") 'gtags-pop-stack)
    (local-set-key (kbd "C-c s") 'gtags-find-symbol)
    (local-set-key (kbd "C-c f") 'gtags-find-file)))
(add-hook 'gtags-select-mode-hook 'hl-line-mode)

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

(setq jabber-account-list
  '(("grabarz@gmail.com" 
     (:network-server . "talk.google.com")
        (:connection-type . ssl))))

; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
;(setq yas/snippet-dirs '("~/.emacs.d/snippets"))
(yas/reload-all)
(add-hook 'c-mode-common-hook
   '(lambda ()
      (yas/minor-mode)))
