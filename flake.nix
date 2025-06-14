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

# {
#   description = "A best script!";
#   inputs.flake-utils.url = "github:numtide/flake-utils";
#   outputs =
#     {
#       self,
#       nixpkgs,
#       flake-utils,
#     }:
#     flake-utils.lib.eachDefaultSystem (
#       system:
#       let
#         pkgs = import nixpkgs { inherit system; };
#         "hyprshot" = "hyprshot";
#         my-buildInputs = with pkgs; [
#           slurp
#           grim
#           libnotify
#         ];
#         my-script = (pkgs.writeScriptBin "hyprshot" (builtins.readFile ./hyprshot)).overrideAttrs (old: {
#           buildCommand = "${old.buildCommand}\n patchShebangs $out";
#         });
#       in
#       rec {
#         defaultPackage = packages.my-script;
#         packages.my-script = pkgs.symlinkJoin {
#           name = "hyprshot";
#           paths = [ my-script ] ++ my-buildInputs;
#           buildInputs = [ pkgs.makeWrapper ];
#           postBuild = "wrapProgram $out/bin/${"hyprshot"} --prefix PATH : $out/bin";
#         };
#       }
#     );
# }
