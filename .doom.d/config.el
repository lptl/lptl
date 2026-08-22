;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'base16-black-metal-mayhem)
(setq doom-theme 'doom-lil)
;; 1. Make `SPC SPC` open the buffer switcher
(map! :leader
      :desc "Switch buffer"
      "SPC" #'switch-to-buffer)

;; 1. Enable disabled horizontal scroll commands (still correct/needed)
(put 'scroll-left 'disabled nil)
(put 'scroll-right 'disabled nil)

;; 2. Let Emacs's built-in mouse-wheel-mode handle tilt/trackpad scroll
(setq mouse-wheel-tilt-scroll t
      mouse-wheel-flip-direction nil  ; flip to t only if direction feels backwards
      mouse-wheel-scroll-amount-horizontal 4
      hscroll-step 1
      hscroll-margin 1)

;; 3. Truncate lines instead of wrapping
(setq-default truncate-lines t)
(add-hook 'prog-mode-hook (lambda () (setq truncate-lines t)))
(add-hook 'text-mode-hook (lambda () (setq truncate-lines t)))

;; 2. Make `Ctrl + /` toggle a popup terminal
(map! :g "C-/" #'+vterm/toggle
      :g "C-_" #'+vterm/toggle)  ; C-_ ensures it works in terminal/SSH sessions
(define-key key-translation-map (kbd "C-c") (kbd "C-g"))
(setq doom-font (font-spec :family "Yisk" :size 11 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Helvetica" :size 12)
      doom-big-font (font-spec :family "Yisk" :size 16))
(map! :leader
      :desc "Toggle file tree"
      "e" #'+treemacs/toggle)
;; Map Shift+H and Shift+L in Evil Normal mode to cycle buffers
(map! :n "H" #'previous-buffer
      :n "L" #'next-buffer)
(after! treemacs
  (map! :map treemacs-mode-map
        "<backspace>" #'treemacs-root-up))
(defun +my/evil-delete-blackhole (beg end type &optional _register yank-handler)
  (evil-delete beg end type ?_ yank-handler))

(defun +my/evil-change-blackhole (beg end type &optional _register yank-handler delete-func)
  (evil-change beg end type ?_ yank-handler delete-func))

(after! evil
  ;; 1. Prevent visual paste ('p' in visual mode) from copying replaced text
  (setq evil-kill-on-visual-paste nil)

  ;; 2. Advise delete and change operations to default to the black hole register (?)
  (defun +evil--delete-to-blackhole-a (orig-fn beg end &optional type register &rest args)
    "Direct delete/change to black hole register `_` unless a register is specified."
    (apply orig-fn beg end type (or register ?_) args))

  (advice-add 'evil-delete :around #'+evil--delete-to-blackhole-a)
  (advice-add 'evil-delete-line :around #'+evil--delete-to-blackhole-a)
  (advice-add 'evil-change :around #'+evil--delete-to-blackhole-a)
  (advice-add 'evil-change-line :around #'+evil--delete-to-blackhole-a)
  (advice-add 'evil-delete-char :around #'+evil--delete-to-blackhole-a)
  (advice-add 'evil-substitute :around #'+evil--delete-to-blackhole-a))
;; ----------------------------------------------------
;; 1. Window Splits with SPC | and SPC -
;; ----------------------------------------------------
(map! :leader
      :desc "Split window vertically"   "|" #'evil-window-vsplit
      :desc "Split window horizontally" "-" #'evil-window-split)

;; ----------------------------------------------------
;; 2. Window Movement with Shift + Arrow Keys
;; ----------------------------------------------------
(map! :n "S-<left>"  #'evil-window-left
      :n "S-<down>"  #'evil-window-down
      :n "S-<up>"    #'evil-window-up
      :n "S-<right>" #'evil-window-right)

(use-package! eaf
  :config
  ;; You must require the specific apps you want EAF to register:
  (require 'eaf-video-player nil t)
  (require 'eaf-file-manager)
  (require 'eaf-image-viewer)
  (add-to-list 'auto-mode-alist '("\\.\\(png\\|jpg\\|jpeg\\|gif\\|webp\\)\\'" . eaf-open))
  (add-to-list 'auto-mode-alist '("\\.\\(mp4\\|mkv\\|webm\\|avi\\|mov\\)\\'" . eaf-open))
  )
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; Change the main editor background color
;; (Optional) Customize the prompt text color (e.g., "M-x ", "Find file: ")
(custom-set-faces!
  '(minibuffer-prompt :foreground "#cdc9c9" :weight bold))
(setq evil-normal-state-cursor '(box "#cdc9c9")   ; Blue block in Normal mode
      evil-insert-state-cursor '(box "#5f9ea0")   ; Green block in Insert mode
      evil-visual-state-cursor '(box "#8fbc8f")   ; Orange block in Visual mode
      evil-replace-state-cursor '(box "#ffff00")) ; Red block in Replace mode
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
