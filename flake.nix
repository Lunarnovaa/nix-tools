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
        nh
        alejandra
      ];
      shellHook = ''
        export FLAKE="$HOME/nixconf"
        bash build.sh
        exit
      '';
    };
  };
}
