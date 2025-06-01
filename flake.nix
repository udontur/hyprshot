{
  description = " (fork fix) Hyprshot is an utility to easily take screenshots in Hyprland using your mouse. ";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  outputs =
    {
      self,
      nixpkgs
    }:
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
          lib = pkgs.lib;
        in
        {
          default = pkgs.stdenvNoCC.mkDerivation {
            # Meta Data
            pname = "hyprshot";
            version = "nightly";

            src = self;

            nativeBuildInputs = with pkgs; [ makeWrapper ];

            buildInputs = with pkgs; [
              jq
              grim
              slurp
              wl-clipboard
              libnotify

            ];

            installPhase = ''
              runHook preInstall

              install -Dm755 hyprshot -t "$out/bin"
              wrapProgram "$out/bin/hyprshot" \
                --prefix PATH ":" ${
                  lib.makeBinPath (
                    [
                      pkgs.jq
                      pkgs.grim
                      pkgs.slurp
                      pkgs.wl-clipboard
                      pkgs.libnotify
                    ]
                  )
                }

              runHook postInstall
            '';
          };
        }
      );
    };
}
