;; ijl20 custom emacs config

(add-to-list 'load-path "~/.emacs.d/web-mode/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")


(global-linum-mode t)
(menu-bar-mode -1)
(define-key global-map [select] 'end-of-line)
(cua-mode)

(setq scroll-step 1)
(setq standard-indent 4)
(mouse-wheel-mode t)
(setq-default indent-tabs-mode nil)
(setq tab-stop-list (number-sequence 4 120 4))
(global-set-key (kbd "C-r") 'query-replace-regexp)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)

;; Highlight matching parenthesis
(show-paren-mode 1)

;; HTML with embedded css and javascript

;; stop the really fucking broken auto-indent crapola
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))
;;
(defadvice show-paren-function
   (after show-matching-paren-offscreen activate)
   "If the matching paren is offscreen, show the matching line in the
    echo area. Has no effect if the character before point is not of
    the syntax class ')'."
   (interactive)
   (let* ((cb (char-before (point)))
         (matching-text (and cb
             (char-equal (char-syntax cb) ?\) )
                (blink-matching-open))))
                  (when matching-text (message matching-text))))
;; initial window
;;(setq initial-frame-alist
;;      '(
;;        (width . 132) ; character
;;        (height . 54) ; lines
;;        ))

;; default/sebsequent window
;;(setq default-frame-alist
;;      '(
;;        (width . 130) ; character
;;        (height . 52) ; lines
;;        ))

;;; It's kind of sad this doesn't exist normally...
(defun indent-rigidly-n (n)
      "Indent the region, or otherwise the current line, by N spaces."
      (let* ((use-region (and transient-mark-mode mark-active))
             (rstart (if use-region (region-beginning) (point-at-bol)))
             (rend   (if use-region (region-end)       (point-at-eol)))
             (deactivate-mark "irrelevant")) ; avoid deactivating mark
        (indent-rigidly rstart rend n)))
(defun indent-rigidly-4 ()
      "Indent the region, or otherwise the current line, by 4 spaces."
      (interactive)
      (indent-rigidly-n 4))
(defun outdent-rigidly-4 ()
      "Indent the region, or otherwise the current line, by -4 spaces."
      (interactive)
      (indent-rigidly-n -4))
(global-set-key (kbd "<tab>") 'indent-rigidly-4)
(global-set-key (kbd "<backtab>") 'outdent-rigidly-4)
;;(global-set-key (kbd "RET") 'newline-and-indent)
(setq-default major-mode 'text-mode)
;; example of binding keys only when text-mode is active

(defun my-mode-keys ()
    "Modify keymaps."
    (global-set-key (kbd "<tab>") 'indent-rigidly-4)
    (local-set-key (kbd "<tab>") 'indent-rigidly-4)
    (define-key text-mode-map (kbd "<tab>") 'indent-rigidly-4)
    (global-set-key "\t" 'indent-rigidly-4)
    (global-set-key (kbd "<backtab>") 'outdent-rigidly-4)
    (global-set-key (kbd "RET") 'newline-and-indent)
 )

;; add to hook
(add-hook 'text-mode-hook 'my-mode-keys)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (github-modern)))
 '(custom-safe-themes
   (quote
    ("b3db1a2efd0acbb136a8f701ae7f366f964f5358a93678402415464426986fe3" default)))
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-comment-face ((t (:foreground "color-243"))))
 '(font-lock-keyword-face ((t (:foreground "yellow"))))
 '(font-lock-string-face ((t (:foreground "green"))))
 '(font-lock-variable-name-face ((t (:foreground "brightcyan"))))
 '(minibuffer-prompt ((t (:foreground "green")))))

;;(setq auto-mode-alist
;;    (cons '("\\.html$" . javascript-mode) auto-mode-alist))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
