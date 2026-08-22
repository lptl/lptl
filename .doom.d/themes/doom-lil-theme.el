;;; ~/.config/doom/themes/doom-lil-theme.el -*- lexical-binding: t; no-byte-compile: t; -*-
(require 'doom-themes)

(def-doom-theme doom-lil
  "A clean minimalist monochrome dark theme with green strings."

  ;; ========================================================
  ;; 1. Color Palette
  ;; ========================================================
  ((bg         '("#151515" "black"   "black"))
   (bg-alt     '("#151515" "black"   "black"))
   (base0      '("#0a0a0a" "black"   "black"))
   (base1      '("#151515" "#151515" "brightblack"))
   (base2      '("#1c1c1c" "#1c1c1c" "brightblack"))
   (base3      '("#282828" "#282828" "brightblack"))
   (base4      '("#3e3a3a" "#3e3a3a" "brightblack"))
   (base5      '("#5e5959" "#5e5959" "brightblack"))
   (base6      '("#7e7979" "#7e7979" "brightblack")) ; comments
   (base7      '("#a8a4a4" "#a8a4a4" "brightblack"))
   (base8      '("#cdc9c9" "#cdc9c9" "white"))       ; main text
   (fg         '("#cdc9c9" "#cdc9c9" "white"))
   (fg-alt     '("#7e7979" "#7e7979" "brightblack"))
   ;; Accent colors
   (grey       base5)
   (red        '("#6ca8ae" "#6ca8ae" "red"))
   (orange     fg)
   (yellow     fg)
   (green      '("#8bad9b" "#8bad9b" "green")) ; Soft muted green for strings
   (teal       green)
   (blue       fg)
   (dark-blue  base7)
   (magenta    fg)
   (violet     fg)
   (cyan       fg)
   (dark-cyan  base7)
   ;; Syntax mappings (Strict monochrome + green strings)
   (builtin        fg)
   (comments       base6)
   (doc-comments   base6)
   (constants      base7)
   (functions      fg)
   (keywords       fg)
   (methods        fg)
   (operators      fg)
   (type           fg)
   (strings        green)
   (variables      fg)
   (numbers        base7)
   ;; Face categories required by doom-themes-base
   (highlight      fg)
   (vertical-bar   base2)
   (current-line   base2)
   (lazy-highlight base3)
   (selection      base3)
   (region         base3)
   (shadow         base5)
   (error          red)
   (warning        yellow)
   (success        green)
   (vc-modified    base7)
   (vc-added       green)
   (vc-deleted     red)
   ;; Modeline
   (modeline-fg     fg)
   (modeline-fg-alt base5)
   (modeline-bg     bg)
   (modeline-bg-l   bg)
   (modeline-bg-inactive   bg)
   (modeline-bg-inactive-l bg))

  ;; ========================================================
  ;; 2. Face Overrides
  ;; ========================================================
  ((default                  :background bg :foreground fg)
   (fringe                   :background bg)
   (treemacs-window-background-face :background bg)
   ;; Line Numbers
   (line-number              :background bg :foreground base5)
   (line-number-current-line :background bg :foreground fg :weight 'bold)
   ;; Current line highlight & Selection
   (hl-line                  :background current-line)
   (region                   :background region)
   ;; Modeline borders
   (mode-line          :background bg :foreground fg    :box '(:line-width 1 :color "#222222"))
   (mode-line-inactive :background bg :foreground base5 :box '(:line-width 1 :color "#1a1a1a"))
   ;; Minibuffer / Completion
   (vertico-current          :background base3 :foreground fg)
   ;; Italic comments
   (font-lock-comment-face           :foreground comments :slant 'italic)
   (font-lock-comment-delimiter-face :foreground comments :slant 'italic)))

(provide-theme 'doom-lil)
;;; doom-lil-theme.el ends here
