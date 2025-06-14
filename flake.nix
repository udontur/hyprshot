# {
#   description = "github:udontur/hyprshot Nix flake (fork fix)";
#   inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
#   outputs =
#     { self, nixpkgs }:
#     let
#       supportedSystems = [
#         "x86_64-linux"
#         "aarch64-linux"
#         "x86_64-darwin"
#         "aarch64-darwin"
#       ];
#       forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
#     in
#     {
#       packages = forAllSystems (
#         system:
#         let
#           pkgs = nixpkgs.legacyPackages.${system};
#         in
#         {
#           default = pkgs.stdenv.mkDerivation {
#             # Meta Data
#             pname = "hyprshot";
#             version = "nightly";

#             src = self;

#             propagatedBuildInputs = with pkgs; [
#               # Libraries
#               slurp
#               grim
#               libnotify
#             ];

#             # Build
#             buildPhase = ''
#               chmod +x hyprshot
#             '';

#             #Install
#             installPhase = ''
#               runHook preInstall

#               mkdir -p $out/bin
#               install -Dm775 ./hyprshot $out/bin/hyprshot

#               runHook postInstall
#             '';
#           };
#         }
#       );
#     };
# }

{
  description = "A best script!";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        my-name = "hyprshot";
        my-buildInputs = with pkgs; [
          slurp
          grim
          libnotify
        ];
        my-script = (pkgs.writeScriptBin my-name (builtins.readFile ./hyprshot)).overrideAttrs (old: {
          buildCommand = "${old.buildCommand}\n patchShebangs $out";
        });
      in
      rec {
        defaultPackage = packages.my-script;
        packages.my-script = pkgs.symlinkJoin {
          name = my-name;
          paths = [ my-script ] ++ my-buildInputs;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
        };
      }
    );
}
