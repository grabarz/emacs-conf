; konfig gnusa

(setq gnus-select-method '(nnimap "gmail"
  (nnimap-address "imap.gmail.com")
  (nnimap-server-port 993)
  (nnimap-stream ssl)))


(defvar smtp-accounts
'((ssl "grabarz@gmail.com" "smtp.gmail.com" 587 "key" nil)
(ssl "mymail@otherserver.com" "smtp.otherserver.com" 25 "key" nil)))

(require 'smtpmail)
(setq send-mail-function 'smtpmail-send-it
message-send-mail-function 'smtpmail-send-it
mail-from-style nil
user-full-name "Piotr Grabowski"
user-mail-address "grabarz@gmail.com"
message-signature-file "~/.emacs/signature"
smtpmail-debug-info t
smtpmail-debug-verb t)

(setq gnus-large-newsgroup 'nil)
(setq gnus-ignored-newsgroups "")
;(setq gnus-group-line-format "%P%M%St%(%g%) (%y)n")

; http://www.cataclysmicmutation.com/2010/11/multiple-gmail-accounts-in-gnus/#more-12
(setq gnus-parameters
  '(("INBOX"
    (display . all)
    (posting-style
    (name "Piotr Grabowski")
    (address "grabarz@gmail.com")
    (organization "MON")
    (signature-file "~/.emacs.d/signature"))
   ; (expiry-target . delete) 
    (expiry-wait . never))))

(setq-default
  gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f  %B%s%)\n"
  gnus-user-date-format-alist '((t . "%Y-%m-%d %H:%M"))
  gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
  gnus-sum-thread-tree-false-root ""
  gnus-sum-thread-tree-indent ""
  gnus-sum-thread-tree-leaf-with-other "-> "
  gnus-sum-thread-tree-root ""
  gnus-sum-thread-tree-single-leaf "|_ "
  gnus-sum-thread-tree-vertical "|")

;(setq gnus-summary-line-format "%U%R%z %(%&user-date;  %-15,15f  %B%s%)\n")
;(setq gnus-summary-line-forma
;  "%1{%U%R%z: %}%2{%d%}%5{ %[%4i%] %}%4{%-24,24n%}%6{%-4,4ur%}%5{| %}%(%1{%B%}%s%)n")

;(setq gnus-summary-line-format "%ua%U%R%[%&user-date;: %-15,15f%] %B%s\n")

; wyświetlanie maili html'owych przez w3m
(setq mm-text-html-renderer 'w3m)
(setq mm-inline-text-html-with-images t)
(setq mm-inline-text-html-with-w3m-keymap nil)

; nowe maile na samej górze
(setq gnus-thread-sort-functions
  '(lambda (t1 t2) (not (gnus-thread-sort-by-date t1 t2))))
