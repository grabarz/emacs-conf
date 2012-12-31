; todo
; - tagi (global do c/c++ a do objc etags(?);
; - autouzupelnianie z clangiem;
; - jakis fajny diff do cvs i git;
; - zrobic przadek z backupfiles;
;

; pluginy
(add-to-list 'load-path "~/.emacs.d/lisp/")

(defvar windowsp (string-match "windows" (symbol-name system-type)))

; ustawienie rozmiarow okienka
(if windowsp
    (setq initial-frame-alist `((left . 0) (top . 0) (width . 232) (height . 63)))
    (setq initial-frame-alist `((left . 0) (top . 0) (width . 210) (height . 62))))

; ustawienie czcionki
(if windowsp
    (add-to-list 'default-frame-alist '(font . "Monaco-7"))
    (add-to-list 'default-frame-alist '(font . "Monaco-9")))

(global-font-lock-mode t)

; ustawienie menu i status bara
(if (not window-system) (menu-bar-mode -1))
(when (functionp 'tool-bar-mode) (tool-bar-mode -1))
(when (functionp 'scroll-bar-mode) (scroll-bar-mode -1))

; ibuffer zamias buffer-menut
(defalias 'list-buffers 'ibuffer)
(add-hook 'ibuffer-hook 'hl-line-mode)

; themesy
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'zenburn t)

; funkcja odpalajaca zamiennik cmd.exe w windowsie
(defun run-cmd-exe()
  (interactive)
  (let ((proc (start-process "console" nil "console.exe" "/C" "start" "console.exe")))
	(set-process-query-on-exit-flag proc nil)))

; przebindowanie klawiszy
(windmove-default-keybindings) ; poruszanie sie po oknach
(global-set-key (kbd "C-c g") 'goto-line)
(global-set-key (kbd "C-c a") 'ack)
(global-set-key (kbd "C-c d") 'find-name-dired)
(global-set-key (kbd "C-<tab>") 'other-window)
(global-set-key (kbd "C-;") 'shrink-window-horizontally)
(global-set-key (kbd "C-'") 'enlarge-window-horizontally)
(global-set-key (kbd "C-:") 'shrink-window)
(global-set-key (kbd "C-\"") 'enlarge-window)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)
(if windowsp
  (global-set-key (kbd "<f2>") 'run-cmd-exe)
  (global-set-key (kbd "<f2>") 'eshell))
(global-set-key (kbd "<f3>") 'dired-jump)
(global-set-key (kbd "<f4>") '(lambda ()
  (interactive)
  (if (string-equal "*Ibuffer*" (buffer-name (current-buffer)))
    (kill-buffer "*Ibuffer*")
    (ibuffer))))

; podmapowanie f-ow pod cmd-n
;(when (and (eq system-type 'darwin) (eq window-system 'ns))
;  (global-set-key (kbd "s-2") (key-binding (kbd "<f2>")))
;  (global-set-key (kbd "s-3") (key-binding (kbd "<f3>")))
;  (global-set-key (kbd "s-4") (key-binding (kbd "<f4>"))))

; winner do zapamietywania ustawienia okienek
(when (fboundp 'winner-mode)
  (winner-mode 1))

; usuwamy welcome screen
(setq inhibit-splash-screen t)

; ido-mode
(ido-mode 1)

; zmiana yes/no na y/n
(fset 'yes-or-no-p 'y-or-n-p)

; domyslny katalog
(if windowsp
  (setq default-directory "c:\projekty")
  (setq default-directory "~/"))

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
  (prefer-coding-system 'cp1250))

; ustawienia ls-lisp zamiast systemowego ls
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)
(setq ls-lisp-dirs-first t)

; ustawienie direda
(add-hook 'dired-mode-hook 'hl-line-mode)
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))
(setq dired-dwim-target t)
(require 'dired+)
(if windowsp
   (setq dired-listing-switches "-lahgo")
   (setq dired-listing-switches "-lBha"))

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

; vc - zostawienie tylko gita i hg
(setq vc-cvs-stay-local nil)
(setq vc-handled-backends ('Git 'Hg))

; magit
(add-to-list 'load-path "~/.emacs.d/magit")
(require 'magit)
