with import <nixpkgs> {}; [
  emacs-unstable # from overlay

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

  
]
