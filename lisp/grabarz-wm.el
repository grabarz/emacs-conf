;
; proste ide
;
; zalozenia:
; - dolne okienko na bufory '*...*' pod f-*
; - boczny panel z nav (f-*) albo dired w pojedynczym buforem;
; - przeskakiwanie do pliku z bufora obok w nav;
; - M-[ i M-] poprzedni i nastepny bufor. Pomija *buferlist*
; - M-1/2/3/4 aktywowanie okienek w managerze (C-c M-1 - znalezienie biezacego pliku w nav/dired)
;
; Prawdopodobnie bedzie trzeba przedefiniowac kilka standardowych funkcji.
;
; Dodac znacznik czy okno pojawilo sie przez klikniecie manualne lub poprzez pojawienie sie jak
; np *Completion*
; Dzialanie:
; 1) tworzenie okien na podstawie konfiguracji;
;

(defcustom grabarz-wm-window-tree nil
  "*Tree definition.")

(defcustom grabarz-wm-window-choose-func nil
  "*Function returning window for given buffer name.")

(defun grabarz-wm ()
  "*Runs grabarz-wm - window manager for emacs."
  (interactive "cWrite something: ")
  (message "Jaj"))

(provide 'grabarz-wm)
