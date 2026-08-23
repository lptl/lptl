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
;; Enable smooth, pixel-by-pixel window & frame resizing
(setq frame-resize-pixelwise t
      window-resize-pixelwise t)

(setq +doom-dashboard-functions nil)
;; 1. Enable disabled horizontal scroll commands (still correct/needed)
(put 'scroll-left 'disabled nil)
(put 'scroll-right 'disabled nil)

(auto-save-visited-mode +1)
(setq auto-save-visited-interval 5
      auto-save-default nil
      create-lockfiles nil
      make-backup-files nil)

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

(defun my/new-vterm ()
  "Spawn a new vterm in the same window (without splitting or dedication errors)."
  (interactive)
  (require 'vterm)
  (require 'cl-lib)
  (let* ((buf (generate-new-buffer "*vterm*"))
         (vterm-win (cl-find-if (lambda (w)
                                  (with-current-buffer (window-buffer w)
                                    (derived-mode-p 'vterm-mode)))
                                (window-list))))
    ;; Initialize the new vterm buffer
    (with-current-buffer buf
      (vterm-mode))
    (if vterm-win
        ;; If a vterm window is already visible:
        (progn
          ;; 1. Temporarily remove window dedication
          (set-window-dedicated-p vterm-win nil)
          ;; 2. Swap in the new buffer
          (set-window-buffer vterm-win buf)
          ;; 3. Focus the window
          (select-window vterm-win)
          ;; 4. Re-dedicate the window to the new vterm buffer
          (set-window-dedicated-p vterm-win t))
      ;; If no vterm window is open on screen, open a fresh popup
      (pop-to-buffer buf))))

(map! :gnime "C-/" #'my/new-vterm
      :gnime "C-_" #'my/new-vterm)

(define-key key-translation-map (kbd "C-c") (kbd "C-g"))
(setq doom-font (font-spec :family "Yisk" :size 11 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Helvetica" :size 12)
      doom-big-font (font-spec :family "Yisk" :size 16))
(map! :leader
      :desc "Toggle file tree"
      "e" #'+treemacs/toggle)
(after! treemacs
  (map! :map treemacs-mode-map
        "<backspace>" #'treemacs-root-up))

;; Map Shift+H and Shift+L in Evil Normal mode to cycle buffers
(map! :n "H" #'previous-buffer
      :n "L" #'next-buffer)

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


(defun my/yank-current-working-directory ()
  "Copy the current buffer's directory to the clipboard and kill ring."
  (interactive)
  (let ((dir (expand-file-name (if buffer-file-name
                                   (file-name-directory (buffer-file-name))
                                 default-directory))))
    (kill-new dir)
    (message "Copied directory to clipboard: %s" dir)))

(defun my/new-file-in-current-dir ()
  "Create a new file relative to the current buffer's directory.
Automatically creates parent directories if a nested path is entered."
  (interactive)
  (let* ((base-dir (if buffer-file-name
                       (file-name-directory (buffer-file-name))
                     default-directory))
         (file (read-file-name "New file: " base-dir)))
    (when (and file (not (string-empty-p file)))
      ;; Create parent subdirectories if typing something like "utils/helper.py"
      (unless (file-exists-p (file-name-directory file))
        (make-directory (file-name-directory file) t))
      (find-file file))))

(map! :leader
      ;; SPC c y -> Copy current directory path
      :desc "Copy current directory" "c y" #'my/yank-current-working-directory

      ;; SPC f n -> Create new file in current buffer's directory
      :desc "New file in current dir" "f n" #'my/new-file-in-current-dir)

;; (use-package! eaf
;;   :config
;;   ;; You must require the specific apps you want EAF to register:
;;   (require 'eaf-video-player nil t)
;;   (require 'eaf-file-manager)
;;   (require 'eaf-image-viewer)
;;   (add-to-list 'auto-mode-alist '("\\.\\(png\\|jpg\\|jpeg\\|gif\\|webp\\)\\'" . eaf-open))
;;   (add-to-list 'auto-mode-alist '("\\.\\(mp4\\|mkv\\|webm\\|avi\\|mov\\)\\'" . eaf-open))
;;   )
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; Change the main editor background color
;; (Optional) Customize the prompt text color (e.g., "M-x ", "Find file: ")

(setq evil-normal-state-cursor '(box "#cdc9c9")   ; Blue block in Normal mode
      evil-insert-state-cursor '(box "#5f9ea0")   ; Green block in Insert mode
      evil-visual-state-cursor '(box "#8fbc8f")   ; Orange block in Visual mode
      evil-replace-state-cursor '(box "#ffff00")) ; Red block in Replace mode

(defun my/transparent-terminal-background ()
  "Safely set transparent background for all existing faces in terminal."
  (unless (display-graphic-p)
    (dolist (face '(default
                    line-number
                    line-number-current-line
                    fringe
                    hl-line
                    solaire-default-face
                    solaire-line-number-face
                    solaire-fringe-face))
      (when (facep face)
        (set-face-background face "unspecified-bg")))))

(unless (display-graphic-p)
  ;; 1. Enable mouse tracking (clicks, text selection, and wheel) in terminal
  (xterm-mouse-mode 1)

  ;; 2. Configure smooth mouse scrolling
  (setq mouse-wheel-scroll-amount '(3 ((shift) . 1)) ; scroll 3 lines per step
        mouse-wheel-progressive-speed nil            ; disable erratic scroll acceleration
        mouse-wheel-follow-mouse t                   ; scroll the window under cursor
        fast-but-imprecise-scrolling t)

  ;; 3. Ensure mouse click sets the cursor position accurately
  (global-set-key [mouse-1] #'mouse-set-point))

;; Apply on startup and whenever a theme loads
(add-hook 'doom-load-theme-hook #'my/transparent-terminal-background)
(my/transparent-terminal-background)
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
