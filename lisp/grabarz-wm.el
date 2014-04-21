;;
;; grabarz-wm - prosty manager okienek dodajacy konsolke gdzie wyswietlane sa wybrane bufory.
;;
;; TODO:
;; - poprawic przeskok do nastepnego buforu.
;;

(require 'cl)

(defcustom grabarz-wm-console-window nil
  "*Okno konsoli. Jezeli rowne nil to okno nie istnieje.")

(defvar grabarz-wm-console-window-tmp nil
  "Tymczasowa zmienna.")

(defvar grabarz-wm-current-window-tmp nil
  "Tymczasowa zmienna.")

(defvar grabarz-wm-old-set-window-buffer nil
  "Stara wersja funkcji.")

(defcustom grabarz-wm-console-window-height 33
  "*Wysokosc konsoli w %.")

(defcustom grabarz-wm-console-regexp nil
  "*Regexpy okreslajace okna ktore powinny zostac wyswietlone w konsoli.")

(defun grabarz-wm-check-regexp (regexps token)
  "Sprawdza czy ktorys z token pasuje do ktoregos regexpa."
  (catch 'found
	(while regexps
	  (when (string-match (car regexps) token)
		  (throw 'found t))
	  (setq regexps (cdr regexps)))
	nil))

(defun grabarz-wm-console-window-make ()
  "Tworzy okno konsoli w zmiennej globalnej."
  (let* ((th (float (window-total-height (frame-root-window))))
         (wh (round (* (/ (- 100 (float grabarz-wm-console-window-height)) 100) th))))
    (setq grabarz-wm-console-window (split-window (frame-root-window) wh nil))))

(defun grabarz-wm-display-buffer-function (buffer-or-name &optional not-this-window)
  "Funcja tworzaca okno i umieszczajaca tam bufor."
  (let ((bname (buffer-name buffer-or-name))
        win)
    (if (grabarz-wm-check-regexp grabarz-wm-console-regexp bname)
        (progn
          (when (not (window-live-p grabarz-wm-console-window))
            (grabarz-wm-console-window-make))
          (setq win grabarz-wm-console-window))
      (if not-this-window
          (progn
            (setq win (next-window))
            (when (equal grabarz-wm-console-window win)
              (setq win (next-window win 0))))
        (setq win (selected-window))))
    (ad-disable-advice 'set-window-buffer 'around 'grabarz-wm-ad)
    (set-window-buffer win buffer-or-name)
    (ad-enable-advice 'set-window-buffer 'around 'grabarz-wm-ad)
    (message "display-buffer")
    win))


;; todo dorobic zamykanie konsoli 
;; (defadvice set-window-buffer (around
;;                               grabarz-wm-ad
;;                               (win buf &optional km))
;;   (let ((bname (if (bufferp buf) (buffer-name buf) buf)))
;;     (if (grabarz-wm-check-regexp grabarz-wm-console-regexp bname)
;;         (progn
;;           (when (not (window-live-p grabarz-wm-console-window))
;;             (grabarz-wm-console-window-make))
;;           (setq win grabarz-wm-console-window))
;;       (when (equal grabarz-wm-console-window (selected-window))
;;         (setq win (next-window (selected-window) 0))))
;;     (message "set-window-buffer")
;;     ad-do-it))

(defadvice set-window-buffer (around
                              grabarz-wm-ad
                              (win buf &optional km))
  (let ((bname (if (bufferp buf) (buffer-name buf) buf)))
    (if (grabarz-wm-check-regexp grabarz-wm-console-regexp bname)
        (progn
          (when (not (window-live-p grabarz-wm-console-window))
            (grabarz-wm-console-window-make))
          (setq win grabarz-wm-console-window))
      (if (equal grabarz-wm-console-window (selected-window))
        (setq win (next-window (selected-window) 0))))
    ad-do-it))


; interfejs

(defun grabarz-wm-other-window (num)
  "*Przeskakuje do nastepnego okna ktore nie jest konsola"
  (interactive "P")
  (other-window num)
  (when (equal (selected-window) grabarz-wm-console-window)
	  (other-window num)))

(defun grabarz-wm-console-activate-hide ()
   "*Pokazuje konsole z pierwszym pasujacym buforem."
   (interactive)
   (if (equal (selected-window) grabarz-wm-console-window)
	   (delete-window grabarz-wm-console-window)
	 (when (window-live-p grabarz-wm-console-window)
		 (select-window grabarz-wm-console-window))))

(defun grabarz-wm ()
  "*Runs grabarz-wm - window manager for emacs."
  (interactive)                                                     
  (setq grabarz-wm-old-set-window-buffer 'set-window-buffer)
  (setq display-buffer-function 'grabarz-wm-display-buffer-function)
  (ad-activate 'set-window-buffer t)                                
  (add-hook 'minibuffer-setup-hook
            '(lambda ()
               (setq grabarz-wm-current-window-tmp (selected-window))
               (setq grabarz-wm-console-window-tmp grabarz-wm-console-window)))
  (add-hook 'minibuffer-exit-hook
            '(lambda () (setq grabarz-wm-console-window grabarz-wm-console-window-tmp))))

(defun grabarz-wm-quit ()
  "*Stops grabarz-wm."
  (interactive)
  (setq display-buffer-function nil)
  (ad-deactivate 'set-window-buffer)
  (ad-deactivate 'current-window-configuration)
  (ad-deactivate 'set-window-configuration))

(provide 'grabarz-wm)
