(package! eaf
  :recipe (:host github
           :repo "emacs-eaf/emacs-application-framework"
           :files (:defaults "*" "*/*" "*/*/*" "*/*/*/*")))

(package! eaf-video-player
  :recipe (:host github
           :repo "emacs-eaf/eaf-video-player"
           :files (:defaults "*" "*/*" "*/*/*" "*/*/*/*")))

(package! eaf-file-manager
  :recipe (:host github
           :repo "emacs-eaf/eaf-file-manager"
           :files (:defaults "*" "*/*" "*/*/*" "*/*/*/*")))

(package! eaf-image-viewer
  :recipe (:host github
           :repo "emacs-eaf/eaf-image-viewer"
           :files (:defaults "*" "*/*" "*/*/*" "*/*/*/*")))

(package! base16-theme)
