# Hyprshot

This is a fork from [Gustash/Hyprshot](https://github.com/Gustash/Hyprshot) that fixes the border visibility issue without removing the animations. 

## Installation (NixOS Only)
This fork is only available via Nix flakes:
1. Add the url to your `flake.nix` input
```nix
hyprshot.url = "github:udontur/hyprshot";
```
2. Add the package in `environment.systemPackages`
```nix
inputs.hyprshot.packages."${system}".default
```
3. Rebuild your configuration with nix flakes enabled.

## Usage
Take a regional screen shot with a frozen screen, copy without saving
```conf
hyprshot -m region -z --clipboard-only
```

> [!NOTE]
> Make sure to remove the `hyprshot` package from nixpkgs
