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

; http://www.cataclysmicmutation.com/2010/11/multiple-gmail-accounts-in-gnus/#more-12
(setq gnus-parameters
      '(("INBOX"
         (display . all)
         (posting-style
         (name "Deon Garrett")
         (address "me@myworkaddress.com")
         (organization "My Employer")
         (signature-file "~/.signature-work"))
        ; (expiry-target . delete) 
         (expiry-wait . never))))
