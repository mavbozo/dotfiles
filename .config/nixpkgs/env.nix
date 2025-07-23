with import <nixpkgs> {}; [

  # nix ;; should we add nix in this?
  
  direnv
  git
  multimarkdown
  clojure
  nodejs_24
  nodePackages.prettier
  pandoc
  ripgrep
  gnupg
  
  emacs-unstable # from overlay

  emacsPackages.use-package
  
  emacsPackages.magit

  emacsPackages.company
  
  emacsPackages.direnv
  
  # prog
  emacsPackages.flycheck

  # clojure
  emacsPackages.flycheck-clj-kondo
  
  # javascript
  emacsPackages.prettier

  # typescript
  emacsPackages.typescript-mode
  emacsPackages.tide

  # nix
  emacsPackages.nix-mode

  emacsPackages.no-littering

  emacsPackages.rainbow-delimiters

  emacsPackages.yasnippet

  emacsPackages.cider

  emacsPackages.markdown-mode
]
