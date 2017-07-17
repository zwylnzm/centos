;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)

(add-to-list 'package-archives
      '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults ;; add theme
    elpy ;; add the elpy package
;;    ein ;; emacs ipython notebook
 ;;   flycheck ;; add the flycheck package
    py-autopep8 ;; add the autopep8 package
    material-theme)) ;; theme

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; spell check
;; find aspell automatically
(setq exec-path (append exec-path '("/usr/local/bin")))
(setq ispell-program-name "aspell")
  ;; Please note ispell-extra-args contains ACTUAL parameters passed to aspell
(setq ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))
(defun flyspell-custom ()
  "Custom function to spell check highlighted word"
  (interactive)
  (end-of-buffer)
  (flyspell-buffer)
  (flyspell-check-previous-highlighted-word)
    )
(define-key global-map "\C-cf" 'flyspell-custom) ;; shortcut for enabling spell check

;; elpy setup
(elpy-enable) ;; enable elpy
(pyvenv-activate (expand-file-name "~/anaconda"))
;;(elpy-use-ipython)

;; use flycheck as syntax checking
;;(when (require 'flycheck nil t)
;;  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; use pep8 compliance
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; ein setup
;; (require 'ein)

;; org mode setup
(setq org-startup-indented t) ;; org mode with indent
(define-key global-map "\C-ca" 'org-agenda) ;; shortcut for agenda view
(setq org-log-done 'time) ;; add timestamp for accomplished task
(setq org-agenda-files (list "~/Documents/personal/org/TODO.org" "~/Documents/personal/org/DONE.org"))
(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))
(setq org-todo-keyword-faces
           '(("WAIT" . "yellow")
             ))

;; latex engine
(setq tex-compile-commands '(("xelatex %r")))
(setq tex-command "xelatex")
(setq-default TeX-engine 'xelatex)
(setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin/")) ;; set latex path

;; Use XeLaTeX to export PDF in Org-mode
(setq org-latex-pdf-process
      '("xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"))

;; capture mode
(defun org-get-target-headline (&optional prompt)  ;; define a function to choose headline in a file
    (let* ((target (save-excursion
                     (org-refile-get-location prompt nil nil t)))
           (file (nth 1 target))
           (pos (nth 3 target))
           )
    (with-current-buffer (find-file-noselect file)
        (goto-char pos)
        (org-end-of-subtree)
        (org-return)
    )))
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates ;; define journal
      '(("j" "LOG" plain (file+datetree "~/Documents/personal/org/journal.org")
	 "+ %<[%H:%M]> *~LOGS~*: %?") ;; entry LOG, what I have done and what I am doing
	 ("t" "TODO" entry (file+headline "~/Documents/personal/org/TODO.org" "Tasks")
	 "* TODO %?\nCreated on %U") ;; entry TODO, what I want to do
	 ("m" "Ideas" plain (file+datetree "~/Documents/personal/org/journal.org")
	 "+ %<[%H:%M]> *~MEMO~*: %?") ;; entry memo/ideas, what I want to remember for the future
         ("n" "Notes" entry (file+function "~/Documents/personal/org/handbook.org" org-get-target-headline)
         "* %?") ;; entry notes
         )
)

;; ESS, R
;; (require 'ess-site)

;; babel
(org-babel-do-load-languages
      'org-babel-load-languages
      '((emacs-lisp . t)
        (python . t)      ;; enable python code evaluation
        (sh . t)          ;; shell code
        (latex . t)       ;; latex code
        (R . t)))         ;; R code
(setq org-src-fontify-natively t) ;; colorful source code

;; autofill, line soft wrap 
;; (setq-default fill-column 80)
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
(global-visual-line-mode 1) ;; soft wrap at word boundary. 1 for on, 0 for off.

;; open with menu bar
;; (menu-bar-mode 1)



;; Set to the location of your Org files on your local system
(setq org-directory "~/Documents/personal/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Documents/personal/org/TODO.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")






;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(package-selected-packages (quote (material-theme better-defaults)))
 '(safe-local-variable-values
   (quote
    ((org-todo-keyword-faces
      ("WAIT" . "yellow"))
     (org-todo-keyword-faces
      ("TODO" . "red")
      ("WAIT" . "orange")
      ("DONE" . "green")))))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
