;
; proste ide
;
; zalozenia:
; - dolne okienko na bufory '*...*' pod f-*
; - boczny panel z nav (f-*) albo dired w pojedynczym buforem;
; - przeskakiwanie do pliku z bufora obok w nav;
; - M-[ i M-] poprzedni i nastepny bufor dla danego okienka. Pomija *buferlist*
; - M-1/2/3/4 aktywowanie okienek w managerze (C-c M-1 - znalezienie biezacego pliku w nav/dired)
;   ponowne nacisniecie powoduje przejscie do kolejnego podokna
; - C-ESC - zamkniecie okna

; Prawdopodobnie bedzie trzeba przedefiniowac kilka standardowych funkcji.
;
; Dodac znacznik czy okno pojawilo sie przez klikniecie manualne lub poprzez pojawienie sie jak
; np *Completion*
; Dzialanie:
; 1) tworzenie okien na podstawie konfiguracji;
;

(defcustom grabarz-wm-window-buffer-dict nil
  "*Tree definition.")

(defstruct grabarz-wm-window
  split    ; how to split and where to appear
  onparent ; t create on parent(parent), nil create on parent if parent->window == window->parent i sprawdzanie czy parent->window to live czy nie
  size     ; size in percents of the screen
  parent   ; parent grabarz-wm-window (logic parent)
  window   ; window
  config   ; window configuration if parent->window != window->parent then cfg(w->p) else cfg(w)
)

(defstruct grabarz-wm-win
  split
  size
  config
  path)

(defun grabarz-wm-hide-current-window ()
  "*Hides grabarz-wm-window."
  (interactive)
  ; if curent win != grb-win(current-buff)

  ; if gr-win(buffname)->window == currentwindow
  ;   if window->parent != parent->window
  ;     cfg(window->parent)
  ;   else cfg(window)お
  ; else kill-window, grwin->window = currentwindow
  )

(defun grabarz-wm-show-window (grabarz-window)
  "*Shows grabarz-wm-window."
  (if (not (grabarz-window :window))
	  (progn
		(if (grabarz-window :parent)
			(grabarz-wm-show-window (grabarz-window :parent))
		    (

(defun grabarz-wm-show-all-windows ()
  "*Shows whole window structure on current frame."
)

(defun grabarz-wm-window-visible-p ()
  "*Checks if window is visible. If is then returns its grabarz-wm-window structure."
  ; rekurencyjnie buduje okienka
  )

; display-buffer-function - pod to podpinamy ta funkcje
; zrobic tak zeby nie bylo problemow z minibufer-window
; algorytm:
; - po pobraniu bufora
(defun grabarz-wm-display-buffer-function (buffer-or-name &optional not-this-window)
  "*Goes to buffer in certain window."
  (let ()
	))

;(defadvice

(defun grabarz-wm ()
  "*Runs grabarz-wm - window manager for emacs."
  (setq display-buffer-function 'grabarz-wm-display-buffer-function))

(provide 'grabarz-wm)
