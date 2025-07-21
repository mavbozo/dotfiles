{
  allowUnfree = true; # Enable unfree packages if needed
  
  packageOverrides = pkgs: rec {
    nixpkgs-25_05 = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/25.05.tar.gz";
      sha256 = "1915r28xc4znrh2vf4rrjnxldw2imysz819gzhk9qlrkqanmfsxd";
    }) {};

    myPackages = with nixpkgs-25_05; [
      direnv
      git
      multimarkdown
      clojure
      nodejs_24
      nodePackages.prettier
      pandoc
      ripgrep
    ];
  };
}
