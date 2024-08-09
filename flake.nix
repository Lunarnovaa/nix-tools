{
  description = "NixOS building flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        git
        nh
        alejandra
        nix-prefetch-scripts
      ];
      shellHook = ''
        git pull # here so that the script does not get changed during run

        export FLAKE="$HOME/nixconf"
        bash tool-selection.bash
        exit
      '';
    };
  };
}
