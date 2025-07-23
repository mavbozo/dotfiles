self: super:
let
  # current emacs 30
  emacs-overlay = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
  });

  rawOverlay = emacs-overlay self super;
  
in
{
  emacs-unstable = rawOverlay.emacs-unstable.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [];
  });
}
