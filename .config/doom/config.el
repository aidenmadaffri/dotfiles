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
(map! :leader
      :desc "Open org index file" "o i" #'org-roam-jump-to-index)
(map! :leader
      :desc "Find or create org-roam file" "o o" #'org-roam-find-file)
(map! :leader
      :desc "Insert org-roam link" "o l" #'org-roam-insert)
(setq org-roam-completion-system 'ivy)

(setq display-line-numbers-type 'relative)
