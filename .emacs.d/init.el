;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 13)        ; Give some breathing room

(menu-bar-mode -1)          ; Disable the menu bar

(setq visible-bell t)       ; Enable the visual bell

(set-face-attribute 'default nil :font "JetbrainsMono Nerd Font" :height 150)
(set-face-attribute 'fixed-pitch nil :font "JetbrainsMono Nerd Font" :height 150)
(set-face-attribute 'variable-pitch nil :font "NotoSans Nerd Font" :height 175)

(setq display-line-numbers-type 'visual)
(setq display-line-numbers-width-start t)
(setq display-line-numbers-grow-only t)
(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(term-mode-hook
                shell-mode-hook
		    org-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Needed to autotrust theme
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(use-package doom-themes
  :init (load-theme 'doom-gruvbox)
  :custom ((doom-gruvbox-dark-variant "hard")))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package diminish)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :custom ((which-key-idle-delay 0.5)))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         :map ivy-switch-buffer-map
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  :custom ((ivy-initial-inputs-alist nil))) ;; Dosen't start searchs with ^
  
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
    :config
    (counsel-mode 1)
    :bind (:map minibuffer-local-map
           ("C-r" . 'counsel-minibuffer-history)))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  ;; Uncomment the following line to have sorting remembered across sessions!
  (prescient-persist-mode 1)
  (ivy-prescient-mode 1))

;; Make ESC globally quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-delete t)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-Y-yank-to-eol t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion (kbd "<down>") 'evil-next-visual-line)
  (evil-global-set-key 'motion (kbd "<up>")   'evil-previous-visual-line)

  ;; Use C-b to switch buffers
  (evil-global-set-key 'normal (kbd "C-b") 'counsel-switch-buffer)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :config
  (general-create-definer atm/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (atm/leader-keys
    "o"  '(:ignore t :which-key "open")
    "oo" '((lambda () (interactive) (counsel-find-file "~/docs/org/")) :which-key "org files")
    "ot" '((lambda () (interactive) (find-file "~/docs/org/tasks.org")) :which-key "tasks")
    "oa" '((lambda () (interactive) (org-agenda nil "d")) :which-key "agenda")
    "oc" '((lambda () (interactive) (find-file "~/.emacs.d/Emacs.org")) :which-key "config")
    "oq" '(org-capture :which-key "quick capture")
    "m"  '(:ignore t :which-key "org")
    "mt" '(org-todo :which-key "todo")
    "p"  '(:keymap projectile-command-map :package projectile :which-key "projects")
    "l"  '(:keymap lsp-command-map :package lsp-mode :which-key "lsp")))

(use-package no-littering)

;; no-littering doesn't set this by default so we must place
;; auto save files in the same path as it uses for sessions
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(use-package super-save
  :ensure t
  :custom ((super-save-auto-save-when-idle t))
  :config
  (super-save-mode +1))

(use-package mixed-pitch)

(defun atm/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (mixed-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . atm/org-mode-setup)
  :config

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
	'("~/docs/org/tasks.org"))

  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "STRT(s)" "|" "DONE(d!)")))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
	'(("d" "Dashboard"
	((agenda "" ((org-deadline-warning-days 7)))
	(todo "NEXT"
	((org-agenda-overriding-header "Next Tasks")))))

  ("n" "Next Tasks"
	((todo "NEXT"
	((org-agenda-overriding-header "Next Tasks")))))))

  ;; Save Org buffers after refiling
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-ellipsis " ▾"))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode)
  :custom ((org-hide-leading-stars t)))

(setq inhibit-compacting-font-caches t) ; Eliminates possible performance issues

(defun atm/org-mode-visual-fill ()
  (setq visual-fill-column-width 200
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . atm/org-mode-visual-fill))

;; Make sure to enter insert mode
(add-hook 'org-capture-mode-hook 'evil-insert-state)

(setq org-capture-templates
  `(("t" "Task" entry (file+olp "~/docs/org/tasks.org" "Inbox")
  "* TODO %?\nSCHEDULED: %t")
    ("j" "Journal" entry (file+olp+datetree "~/docs/org/journal.org")
        "\n* %<%I:%M %p> - Journal :journal:\n\nToday I am grateful %?\n\n"
        :clock-in :clock-resume)))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(defun atm/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/Emacs.org"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'atm/org-babel-tangle-config)))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-ivy)

(use-package lsp-java
  :config
  (add-hook 'java-mode-hook 'lsp))

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/repo")
    (setq projectile-project-search-path '("~/repo")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package evil-magit
  :after magit)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))