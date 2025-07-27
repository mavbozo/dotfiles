# Readme

## config.nix

Installation command (works for me):
```sh
nix-env -iA nixpkgs.myPackages
```

## env.nix

Full rebuilt

```sh
nix-env -irf env.nix
``

Just update

```sh
nix-env -if env.nix
``





## Possible speedup using Cachix

Use cache.

Install instruction
with nix installed

`nix-env -iA cachix -f https://cachix.org/api/v1/install`

then

nix-community cache

`cachix use nix-community`
