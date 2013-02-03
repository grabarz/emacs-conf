(require 'cl)

(defcustom grabarz-wm-console-window nil
  "*Okno konsoli. Jezeli rowne nil to okno nie istnieje.")

(defcustom grabarz-wm-console-window-height 33
  "*Wysokosc konsoli w %.")

(defcustom grabarz-wm-console-regexp nil
  "*Regexpy okreslajace okna ktore powinny zostac wyswietlone w konsoli.")

;(defcustom grabarz-wm-console-regexp-exception nil
;  "*Wyjatki wykluczajace okna z pojawienia sie na konsoli.")

(defun grabarz-wm-check-regexp (regexps token)
  "*Sprawdza czy ktorys z token pasuje do ktoregos regexpa."
  (catch 'found
	(while regexps
	  (if (string-match (car regexps) token)
		  (throw 'found t))
	  (setq regexps (cdr regexps)))
	nil))



(defun grabarz-wm-display-buffer-function (buffer-or-name &optional not-this-window)
  "*Funcja tworzaca okno i umieszczajaca tam bufor."
  (let ((bname (buffer-name buffer-or-name)) win)
	(if (grabarz-wm-check-regexp grabarz-wm-console-regexp bname)
		(progn
		  (if (not (window-live-p grabarz-wm-console-window))
			  (let* ((th (float (window-total-height (frame-root-window))))
					 (wh (round (* (/ (- 100 (float grabarz-wm-console-window-height)) 100) th))))
				(setq grabarz-wm-console-window (split-window (frame-root-window) wh nil))))
		  (setq win grabarz-wm-console-window))
	  (if not-this-window
		  (progn
			(setq win (next-window))
			(if (eq win grabarz-wm-console-window)
				(setq win (next-window))))
		(setq win (selected-window))))
	(set-window-buffer win buffer-or-name)
	win))

(defun grabarz-wm ()
  "*Runs grabarz-wm - window manager for emacs."
  (interactive)
  (setq display-buffer-function 'grabarz-wm-display-buffer-function))

(provide 'grabarz-wm)

