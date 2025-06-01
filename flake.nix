{
  description = " (fork fix) Hyprshot is an utility to easily take screenshots in Hyprland using your mouse. ";
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
              
              buildInputs = with pkgs;[
                # Libraries
                slurp
                grim
                libnotify
              ];

              #Install
              installPhase = ''
                mkdir -p $out/bin
                chmod +x hyprshot
                install -Dm775 ./hyprshot $out/bin/hyprshot
              '';
            };
        }
      );
    };
}

    
