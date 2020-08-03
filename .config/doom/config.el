(setq user-full-name "Aiden Madaffri"
      user-mail-address "contact@aidenmadaffri.com")

(setq doom-font (font-spec :family "JetbrainsMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "NotoSans Nerd Font" :size 16))

 (let ((alist '(;;  -> -- --> ->> -< -<< --- -~ -|
               (?- . ".\\(?:--\\|[->]>?\\|<<?\\|[~|]\\)")

               ;; // /* /// /= /== />
               ;; /** is not supported - see https://github.com/JetBrains/JetBrainsMono/issues/202
               ;; /* cannot be conditioned on patterns followed by a whitespace,
               ;; because that would require support for lookaheads in regex.
               ;; We cannot just match on /*\s, because the whitespace would be considered
               ;; as part of the match, but the font only specifies the ligature for /* with
               ;; no trailing characters
               ;;
               (?/ . ".\\(?://?\\|==?\\|\\*\\*?\\|[>]\\)")

               ;; */ *** *>
               ;; Prevent grouping of **/ as *(*/) by actively looking for **/
               ;; which consumes the triple but the font does not define a substitution,
               ;; so it's rendered normally
               (?* . ".\\(?:\\*/\\|\\*\\*\\|[>/]\\)")

               ;; <!-- <<- <- <=> <= <| <|| <||| <|> <: <> <-< <<< <=< <<= <== <==>
               ;; <~> << <-| <=| <~~ <~ <$> <$ <+> <+ <*> <* </ </> <->
               (?< . ".\\(?:==>\\|!--\\|~~\\|-[|<]\\||>\\||\\{1,3\\}\\|<[=<-]?\\|=[><|=]?\\|[*+$~/-]>?\\|[:>]\\)")

               ;; := ::= :?> :? :: ::: :< :>
               (?: . ".\\(?:\\?>\\|:?=\\|::?\\|[>?<]\\)")

               ;; == =:= === => =!= =/= ==> =>>
               (?= . ".\\(?:[=>]?>\\|[:=!/]?=\\)")

               ;;  != !== !!
               (?! . ".\\(?:==?\\|!\\)")

               ;; >= >> >] >: >- >>> >>= >>- >=>
               (?> . ".\\(?:=>\\|>[=>-]\\|[]=:>-]\\)")

               ;; && &&&
               (?& . ".&&?")

               ;; || |> ||> |||> |] |} |-> |=> |- ||- |= ||=
               (?| . ".\\(?:||?>\\||[=-]\\|[=-]>\\|[]>}|=-]\\)")

               ;; ... .. .? .= .- ..<
               (?. . ".\\(?:\\.[.<]?\\|[.?=-]\\)")

               ;; ++ +++ +>
               (?+ . ".\\(?:\\+\\+?\\|>\\)")

               ;; [| [< [||]
               (?\[ . ".\\(?:|\\(?:|]\\)?\\|<\\)")

               ;; {|
               (?{ . ".|")

               ;; ?: ?. ?? ?=
               (?? . ".[:.?=]")

               ;; ## ### #### #{ #[ #( #? #_ #_( #: #! #=
               (?# . ".\\(?:#\\{1,3\\}\\|_(?\\|[{[(?:=!]\\)")

               ;; ;;
               (?\; . ".;")

               ;; __ _|_
               (?_ . ".|?_")

               ;; ~~ ~~> ~> ~= ~- ~@
               (?~ . ".\\(?:~>\\|[>@=~-]\\)")

               ;; $>
               (?$ . ".>")

               ;; ^=
               (?^ . ".=")

               ;; ]#
               (?\] . ".#")
               )))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

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
