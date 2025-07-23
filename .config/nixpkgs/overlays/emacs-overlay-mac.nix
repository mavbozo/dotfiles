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
    # patches for emacs 30
    patches = old.patches ++ [
      # system appearance patch
      (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-30/system-appearance.patch";
        sha256 = "1dkx8xc3v2zgnh6fpx29cf6kc5h18f9misxsdvwvy980cj0cxcwy"; # nix-prefetch-url --unpack https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-30/system-appearance.patch
      })
      # round-undecorated-frame.patch
      (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-30/round-undecorated-frame.patch";
        sha256 = "0x187xvjakm2730d1wcqbz2sny07238mabh5d97fah4qal7zhlbl"; # nix-prefetch-url --unpack <url>
      })
      # fix window role 
      (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/refs/heads/master/patches/emacs-28/fix-window-role.patch";
        sha256 = "0c41rgpi19vr9ai740g09lka3nkjk48ppqyqdnncjrkfgvm2710z"; # nix-prefetch-url --unpack <url>
      })
    ];
    
    buildInputs = old.buildInputs ++ [
      self.darwin.apple_sdk.frameworks.WebKit
      self.darwin.apple_sdk.frameworks.Cocoa
    ];
    configureFlags = old.configureFlags ++ ["--with-xwidgets"];
  });
}
