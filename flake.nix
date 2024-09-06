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

        bash tool-selection.bash
        exit
      '';
      FLAKE = "$HOME/nixconf";
      green = ''\033[1;32m'';
      cyan = ''\033[1;36m'';
      red = ''\033[1;31m'';
      noColor = ''\033[0m'';
    };
  };
}
