{
  description = "github:udontur/hyprshot Nix flake (fork fix)";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in{
      packages = forAllSystems(system:
        let 
          pkgs = nixpkgs.legacyPackages.${system};
        in{
          default =
            pkgs.stdenv.mkDerivation {
              # Meta Data
              pname = "hyprshot";
              version = "nightly";
              
              src = self;
              
              propagatedBuildInputs = with pkgs;[
                # Libraries
                slurp
                grim
                libnotify
              ];

              # Build
              buildPhase = ''
                chmod +x hyprshot
              '';

              #Install
              installPhase = ''
                runHook preInstall

                mkdir -p $out/bin
                install -Dm775 ./hyprshot $out/bin/hyprshot

                runHook postInstall
              '';
            };
        }
      );
    };
}