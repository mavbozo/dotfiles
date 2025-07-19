(use-package nix-mode
  :mode "\\.nix\\'")

(setq mavbozo/default-base-shell-nix "
let
  nixpkgs = fetchTarball {
    # nix 25.05
    url = \"https://github.com/NixOS/nixpkgs/archive/7a732ed41ca0dd64b4b71b563ab9805a80a7d693.tar.gz\";
    sha256 = \"0c4zz64ddgrnhcbcivl4gflgpad0c1x01fsxlm7p2kjxvjz9pfxv\";
  };
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
  ];
}
")

(defun mavbozo/nix-insert-base-shell-dot-nix ()
  (interactive)
  (insert mavbozo/default-base-shell-nix))
