(require 'cl)

(defcustom grabarz-wm-console-window nil
  "*Okno konsoli. Jezeli rowne nil to okno nie istnieje.")

(defcustom grabarz-wm-console-window-height 33
  "*Wysokosc konsoli w %.")

(defcustom grabarz-wm-console-regexp nil
  "*Regexpy okreslajace okna ktore powinny zostac wyswietlone w konsoli.")

(defun grabarz-wm-check-regexp (regexps token)
  "*Sprawdza czy ktorys z token pasuje do ktoregos regexpa."
  (catch 'found
	(while regexps
	  (if (string-match (car regexps) token)
		  (throw 'found t))
	  (setq regexps (cdr regexps)))
	nil))

(defun grabarz-wm-console-window-make ()
  "*Tworzy okno konsoli w zmiennej globalnej."
  (let* ((th (float (window-total-height (frame-root-window))))
		 (wh (round (* (/ (- 100 (float grabarz-wm-console-window-height)) 100) th))))
	(setq grabarz-wm-console-window (split-window (frame-root-window) wh nil))))

; interfejs

(defun grabarz-wm-display-buffer-function (buffer-or-name &optional not-this-window)
  "*Funcja tworzaca okno i umieszczajaca tam bufor."
  (let ((bname (buffer-name buffer-or-name))
		win)
	(if (grabarz-wm-check-regexp grabarz-wm-console-regexp bname)
		(progn
		  (if (not (window-live-p grabarz-wm-console-window))
			  (grabarz-wm-console-window-make))
		  (setq win grabarz-wm-console-window))
	  (if not-this-window
		  (progn
			(setq win (previous-window))
			(if (equal grabarz-wm-console-window win)
				(setq win (previous-window win))))
		(setq win (selected-window))))
	(set-window-buffer win buffer-or-name)
	(if (equal grabarz-wm-console-window win)
		(set-window-dedicated-p grabarz-wm-console-window 0)) ; tu dodac config
	win))


(defun grabarz-wm-other-window ()
  "*Przeskakuje do nastepnego okna ktore nie jest konsola"
  (interactive)
  (other-window 1)
  (if (equal (selected-window) grabarz-wm-console-window)
	  (other-window 1)))

(defun grabarz-wm-console-activate-hide ()
   "*Pokazuje konsole z pierwszym pasujacym buforem."
   (interactive)
   (if (equal (selected-window) grabarz-wm-console-window)
	   (delete-window grabarz-wm-console-window)
	 (if (window-live-p grabarz-wm-console-window)
		 (select-window grabarz-wm-console-window))))

(defun grabarz-wm ()
  "*Runs grabarz-wm - window manager for emacs."
  (interactive)
  (setq display-buffer-function 'grabarz-wm-display-buffer-function))

(defun grabarz-wm-quit ()
  "*Stops grabarz-wm."
  (interactive)
  (setq display-buffer-function nil))

(provide 'grabarz-wm)

