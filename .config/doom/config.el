(setq user-full-name "Aiden Madaffri"
      user-mail-address "contact@aidenmadaffri.com")

(when (equal (getenv "PC_TYPE") "desktop")
    (setq doom-font (font-spec :family "JetbrainsMono Nerd Font" :size 15)
        doom-variable-pitch-font (font-spec :family "NotoSans Nerd Font" :size 16)))
(when (equal (getenv "PC_TYPE") "laptop")
    (setq doom-font (font-spec :family "JetbrainsMono Nerd Font" :size 22)
        doom-variable-pitch-font (font-spec :family "NotoSans Nerd Font" :size 23)))

(setq doom-theme 'doom-gruvbox)
(setq doom-gruvbox-dark-variant "hard")

(setq org-directory "~/Nextcloud/Documents/org/")
(setq org-roam-directory "~/Nextcloud/Documents/org/")
(setq org-roam-index-file "index.org")
(setq org-roam-completion-system 'ivy)

(defun my:is-end-of-line ()
"Compare point with end of line."
(let* ((pos (current-column))
        (end-pos (save-excursion
                    (evil-end-of-line)
                    (current-column))))
    (eq pos end-pos)))

(defun my:compare-with-end-of-word ()
"Compare point with end of word."
(let* ((pos (current-column))
        (end-pos (save-excursion
                    (evil-backward-word-begin)
                    (evil-forward-word-end)
                    (current-column))))
    (- pos end-pos)))

(defun my:point-is-space ()
"Check if point is whitespace."
(char-equal ?\s (char-after)))

(defun my:insert-after (func)
"Run FUNC after the end of word, ignoring whitespace."
(interactive)
(let ((relative-loc (my:compare-with-end-of-word)))
    (cond ((my:is-end-of-line)
            (end-of-line)
            (call-interactively func))
        ((eq 0 relative-loc)
            (evil-forward-char)
            (call-interactively func))
        ((and (> 0 relative-loc) (not (my:point-is-space)))
            (evil-forward-word-end)
            (if (my:is-end-of-line)
                (end-of-line)
            (evil-forward-char))
            (call-interactively func))
        (t
            (call-interactively func)))))

;; Example usage
(defun my-org-roam-insert ()
"Custom insert to ensure links appear in the correct position."
(interactive)
(insert "")
(my:insert-after 'org-roam-insert))

(map! :leader
      :desc "Open org index file" "o i" #'org-roam-jump-to-index)
(map! :leader
      :desc "Find or create org-roam file" "o o" #'org-roam-find-file)
(map! :leader
      :desc "Insert org-roam link" "o l" #'my-org-roam-insert)

(setq real-auto-save-interval 5) ;; in seconds
(add-hook 'org-mode-hook
          (lambda ()
            (when (s-prefix? (expand-file-name "~/Nextcloud/Documents/org/")
                             (buffer-file-name (current-buffer)))
              (real-auto-save-mode))))

(setq display-line-numbers-type 'relative)
