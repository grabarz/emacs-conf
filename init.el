;;
;; todo
;; - zrobic przadek z backupfiles;
;;

;; pluginy
(add-to-list 'load-path "~/.emacs.d/lisp/")

(defvar windowsp (string-match "windows" (symbol-name system-type)))

;; ustawienia sciezek specjalnie dla ns
(if (not windowsp)
    (let ((grabarz-path
           '("/bin"
             "/sbin"
             "/usr/bin"
             "/usr/sbin"
             "/usr/local/bin"
             "/opt/local/bin"
             "/opt/local/sbin")))
      (setq exec-path (append exec-path grabarz-path))
      (setenv "PATH" (mapconcat 'identity grabarz-path ":"))))

;; ustawienie rozmiarow okienka
(if windowsp
    (setq initial-frame-alist `((left . 0) (top . 0) (width . 232) (height . 63)))
  (setq initial-frame-alist `((left . 0) (top . 0) (width . 251) (height . 74))))

;; ustawienie czcionki
(if windowsp
    (add-to-list 'default-frame-alist '(font . "Consolas-8"))
  (add-to-list 'default-frame-alist '(font . "Consolas-10")))

;; fonty - zeby sie nie mulilo
(global-font-lock-mode t)
(setq jit-lock-defer-time 0.06)

;; ustawienie menu i status bara
(if (not window-system)
    (menu-bar-mode -1))
(when (functionp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (functionp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; ibuffer zamias buffer-menut
(defalias 'list-buffers 'ibuffer)
(add-hook 'ibuffer-hook 'hl-line-mode)

;; themesy
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'zenburn t)
;(load-theme 'inkpot t)

;; funkcja odpalajaca zamiennik cmd.exe w windowsie
(defun run-cmd-exe()
  (interactive)
  (let ((proc (start-process "console" nil "console.exe" "/C" "start" "console.exe")))
    (set-process-query-on-exit-flag proc nil)))

;; ansi-term i funkcja odpalająca
(require 'term) ; do bindowania potrzebne

(defadvice ansi-term (after advise-ansi-term-coding-system)
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))
(ad-activate 'ansi-term)

(defun grabarz-run-ansi-term ()
  (interactive)
  (let ((term-str "*ansi-term*"))
    (if (string-equal term-str (buffer-name (current-buffer)))
        (previous-buffer)
      (if (term-check-proc term-str)
          (switch-to-buffer term-str)
        (progn
          (if (get-buffer term-str)
              (kill-buffer term-str))
          (ansi-term "/bin/bash"))))))

;(require 'eshell)

(defun grabarz-run-eshell ()
  (interactive)
  (if (string-equal "*eshell*" (buffer-name (current-buffer)))
      (previous-buffer)
    (eshell)))

;; ack
(require 'ack)

;; usuwamy welcome screen
(setq inhibit-splash-screen t)

;; ido-mode
(ido-mode 1)
(setq ido-enable-last-directory-history nil)

;; zmiana yes/no na y/n
(fset 'yes-or-no-p 'y-or-n-p)

;; domyslny katalog
(if windowsp
  (setq default-directory "c:\projekty")
  (setq default-directory "~/"))

;; natychmiastowe pokazywanie domkniec
(setq show-paren-delay 0)
(show-paren-mode t)

;; nie potrzebuje nowej lini na koncu pliku
(setq require-final-newline nil)

;; ustawienia aspell'a
(setq ispell-program-name "/opt/local/bin/aspell")

;; ustawienie lisp i slime mode
(add-hook 'lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)))

;; ustawienia cc-mode
(defun grabarz-c-indent-setup ()
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-cont-nonempty '+)
  (c-set-offset 'case-label '+)
  (define-key c-mode-base-map (kbd "RET") 'newline-and-indent)
  (when windowsp
    (c-set-offset 'innamespace '-)))

(setq c-default-style "bsd" c-basic-offset 4 )
(setq-default c-basic-offset 4 tab-width 4 indent-tabs-mode t c-argdecl-indent 0)
(if windowsp
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)))

; dodanie przelaczania sie pomiedzy naglowkiem/implementacja
(add-hook 'c-mode-common-hook
          (lambda() 
            (local-set-key (kbd "C-c o") 'ff-find-other-file)))

(add-hook 'c-mode-common-hook 'grabarz-c-indent-setup)

;; funkcja kopiujaca nazwe edytowanego pliku
(defun grabarz-copy-file-name ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename
         (if (equal major-mode 'dired-mode)
             default-directory
           (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))

;; domyslny input mode dla lokalizacji
;(custom-set-variables
; '(default-input-method "polish-slash"))

;; kodowanie latin2 tylko dla windy
(when windowsp
  (setq locale-coding-system 'cp1250)
  (set-terminal-coding-system 'cp1250)
  (set-keyboard-coding-system 'cp1250)
  (set-selection-coding-system 'cp1250)
  (prefer-coding-system 'cp1250))

(when (not windowsp)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (prefer-coding-system 'utf-8))

;; ustawienia ls-lisp zamiast systemowego ls
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)
(setq ls-lisp-dirs-first t)

;; ustawienie direda
(add-hook 'dired-mode-hook 'hl-line-mode)
(setq dired-recursive-copies (quote always))
(setq dired-recursive-deletes (quote top))
(setq dired-dwim-target t)
(require 'dired+)
(if windowsp
   (setq dired-listing-switches "-lahgo")
   (setq dired-listing-switches "-lBha"))

(defun dired-ediff-marked-files ()
  "Run ediff on marked ediff files."
  (interactive)
  (set 'marked-files (dired-get-marked-files))
  (when (= (safe-length marked-files) 2)
    (ediff-files (nth 0 marked-files) (nth 1 marked-files)))
  (when (= (safe-length marked-files) 3)
    (ediff3 (buffer-file-name (nth 0 marked-files))
            (buffer-file-name (nth 1 marked-files)) 
            (buffer-file-name (nth 2 marked-files)))))

(add-hook 'dired-mode-hook
  (lambda()
    (local-set-key (kbd "C-d") 'dired-ediff-marked-files)))

(add-hook 'dired-mode-hook 'dired-rename-buffer)
(defun dired-rename-buffer ()
  "change buffer name to begin with *D"
  (let ((name (buffer-name)))
    (if (not (string-match "*D: $" name))
        (rename-buffer (concat "*D: " name) t))))

;; ediff
(defvar grabarz-ediff-bwin-config nil "Window configuration before ediff.")
(defcustom grabarz-ediff-bwin-reg ?b
  "*Register to be set up to hold `grabarz-ediff-bwin-config'
    configuration.")

(defun grabarz-ediff-bsh ()
  (remove-hook 'ediff-quit-hook 'ediff-cleanup-mess)
  (window-configuration-to-register grabarz-ediff-bwin-reg))

(defun grabarz-ediff-aswh ()
  (remove-hook 'ediff-quit-hook 'ediff-cleanup-mess))

(defun grabarz-ediff-qh ()
  (remove-hook 'ediff-quit-hook 'ediff-cleanup-mess)
  (ediff-cleanup-mess)
  (jump-to-register grabarz-ediff-bwin-reg))

(add-hook 'ediff-before-setup-hook 'grabarz-ediff-bsh)
(add-hook 'ediff-after-setup-windows-hook 'grabarz-ediff-aswh);
(add-hook 'ediff-quit-hook 'grabarz-ediff-qh)

(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq ediff-split-window-function 'split-window-horizontally)

;; kompilacja
(setq compilation-read-command nil)

(defun* get-closest-pathname (&optional (file (if windowsp "Makefile.mak" "Makefile")))
  (let ((root (expand-file-name "/")))
    (expand-file-name file
    (loop
      for d = default-directory then (expand-file-name ".." d)
      if (file-exists-p (expand-file-name file d))
      return d
      if (equal d root)
      return nil))))

(defun setup-compilation ()
  (set (make-local-variable 'compile-command)
    (format (if windowsp "fmake -f %s" "gmake -f %s") (get-closest-pathname))))

(add-hook 'dired-mode-hook 'setup-compilation)
(add-hook 'c-mode-common-hook 'setup-compilation)

;; auto-complete
(add-to-list 'load-path "~/.emacs.d/auto-complete")
(require 'auto-complete-config)
(ac-config-default)
(setq ac-auto-start nil)
(define-key ac-completing-map "\e" 'ac-stop)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")

;; clang
(require 'auto-complete-clang)

(defcustom grabarz-include-paths
  '("/usr/clang-ide/lib/c++/v1/"
    "./"
    "./include/"
    "/opt/local/include"
    "/usr/include"
    "../../"
    "../../../")
  "*Customowe includy."
  :group 'grabarz-clang
  :type '(repeat directory))

(setq clang-completion-suppress-error 't)
(setq ac-clang-flags
      (mapcar (lambda (item)(concat "-I" item))
              (append grabarz-include-paths)))

(defun grabarz-clang-mode-common-hook()
  (define-key c-mode-base-map (kbd "M-/") 'ac-complete-clang))
(add-hook 'c-mode-common-hook 'grabarz-clang-mode-common-hook)

;; global
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

;; find-file-in-repository
(require 'find-file-in-repository)
(global-set-key (kbd "C-c f") 'find-file-in-repository)

;; jabber.el
(add-to-list 'load-path "~/.emacs.d/jabber/")
(require 'jabber-autoloads)

(setq jabber-account-list
  '(("grabarz@gmail.com" 
     (:network-server . "talk.google.com")
        (:connection-type . ssl))))

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
;(setq yas/snippet-dirs '("~/.emacs.d/snippets"))
(yas/reload-all)
(add-hook 'c-mode-common-hook
   '(lambda ()
      (yas/minor-mode)))

;; vc - zostawienie tylko gita i hg
(setq vc-cvs-stay-local nil)
(setq vc-handled-backends (quote (Git Hg)))

;; magit
(add-to-list 'load-path "~/.emacs.d/magit")
(require 'magit)
(require 'magit-blame)

;; slime
(add-to-list 'load-path "~/.emacs.d/slime/")
(setq inferior-lisp-program "/opt/local/bin/sbcl")
(require 'slime)
(slime-setup)

;; generowanie guidow
(defun grabarz-random-guid ()
  "Insert a UUID. This uses a simple hashing of variable data."
  (interactive)
  (let ((myStr (md5 (format "%s%s%s%s%s%s%s%s%s%s"
                            (user-uid)
                            (emacs-pid)
                            (system-name)
                            (user-full-name)
                            (current-time)
                            (emacs-uptime)
                            (garbage-collect)
                            (buffer-string)
                            (random)
                            (recent-keys)))))
    
    (insert (format "%s-%s-4%s-a%s-%s"
                    (substring myStr 0 8)
                    (substring myStr 8 12)
                    (substring myStr 13 16)
                    (substring myStr 17 20)
                    (substring myStr 20 32)))))

;; grabarz-wm
(require 'grabarz-wm)
(setq grabarz-wm-console-regexp
      '("*Completions*"
        "*Ido Completions*"
        "*Help*"
        "*grep*"
        "*compilation*"
        "*ansi-term*"
        "*Backtrace*"
        "*eshell*"
        "*inferior-lisp*"))
(grabarz-wm)

;; przebindowanie klawiszy
(windmove-default-keybindings) ; poruszanie sie po oknach
(global-set-key (kbd "C-c g") 'goto-line)
(global-set-key (kbd "C-c C-g") 'grabarz-random-guid)
(global-set-key (kbd "C-c a") 'ack)
(global-set-key (kbd "C-c d") 'find-name-dired)
(global-set-key (kbd "C-c m") 'magit-status)
(global-set-key (kbd "C-c b") 'magit-blame-mode)
(global-set-key (kbd "C-c e") 'vc-version-ediff)
(global-set-key (kbd "C-c p") 'grabarz-copy-file-name)
(global-set-key (kbd "C-%") 'split-window-horizontaly)
(global-set-key (kbd "C-;") 'shrink-window-horizontally)
(global-set-key (kbd "C-'") 'enlarge-window-horizontally)
(global-set-key (kbd "C-:") 'shrink-window)
(global-set-key (kbd "C-\"") 'enlarge-window)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-1") '(lambda () (interactive) (grabarz-wm-other-window -1)))
(global-set-key (kbd "M-2") '(lambda () (interactive) (grabarz-wm-other-window 1)))
(global-set-key (kbd "M-[") 'previous-buffer)
(global-set-key (kbd "M-]") 'next-buffer)
(if windowsp
    (global-set-key (kbd "M-`") 'grabarz-wm-console-activate-hide)
  (global-set-key (kbd "M-§") 'grabarz-wm-console-activate-hide))
(if windowsp
  (global-set-key (kbd "<f2>") 'run-cmd-exe)
  (global-set-key (kbd "<f2>") 'grabarz-run-eshell))

(global-set-key (kbd "<f3>")
                '(lambda ()
                   (interactive)
                   (if (not (dired-jump))
                       (dired default-directory))))
(global-set-key (kbd "<f4>")
                '(lambda ()
                   (interactive)
                   (if (string-equal "*Ibuffer*" (buffer-name (current-buffer)))
                       (kill-buffer "*Ibuffer*")
                     (ibuffer))))
(global-set-key (kbd "<f5>") 'compile) ; dodac opcje przerywania kompilacji

;; podmapowanie f-ow pod cmd-n
(when (and (eq system-type 'darwin) (eq window-system 'ns))
  (global-set-key (kbd "s-§") (key-binding (kbd "M-§")))
  (global-set-key (kbd "s-1") (key-binding (kbd "M-1")))
  (global-set-key (kbd "s-2") (key-binding (kbd "M-2")))
  (setq mac-option-key-is-meta nil)
  (setq mac-command-key-is-meta t)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'alt))


;  (global-set-key (kbd "s-3") (key-binding (kbd "<f3>")))
;  (global-set-key (kbd "s-4") (key-binding (kbd "<f4>"))))

;; poczta
;; (require 'gnus-cite)

;; (setq user-mail-address "grabarz@gmail.com"
;;   user-full-name "Piotr Grabowski"
;;   message-cite-function 'message-cite-original-without-signature)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("967c58175840fcea30b56f2a5a326b232d4939393bed59339d21e46cf4798ecf" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
