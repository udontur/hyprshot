{
  description = "github:udontur/hyprshot Nix flake (fork fix)";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          my-script = (pkgs.writeScriptBin "hyprshot" (builtins.readFile ./hyprshot)).overrideAttrs (old: {
            buildCommand = "${old.buildCommand}\n patchShebangs $out";
          });
        in
        {
          default = pkgs.symlinkJoin {
            name = "hyprshot";
            paths =
              [ my-script ]
              ++ [
                pkgs.slurp
                pkgs.grim
                pkgs.libnotify
              ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = "wrapProgram $out/bin/hyprshot --prefix PATH : $out/bin";
          };
        }
      );
    };
}
