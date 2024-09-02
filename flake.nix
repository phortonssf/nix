# in flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # 👇 we have a new input!
    flake-utils.url = "github:numtide/flake-utils";
  };
  #      it's destructured here 👇
  outputs = { self, nixpkgs, flake-utils }:
   #nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });
    # calling a function from `flake-utils` that takes a lambda
    # that takes the system we're targetting
    flake-utils.lib.eachDefaultSystem (system:
      let
        # no need to define `system` anymore
        name = "simple";
        src = ./.;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # `eachDefaultSystem` transforms the input, our output set
        # now simply has `packages.default` which gets turned into
        # `packages.${system}.default` (for each system)
        packages.bash = derivation {
          inherit system name src;
          builder = with pkgs; "${bash}/bin/bash";
          args = [ "-c" "echo foo > $out" ];
        };
  # nix build .#hello
        packages.hello = pkgs.hello;
        #packages.test = pkgs.hello;
        # nix build
        defaultPackage = self.packages.${system}.hello;

        # nix develop .#hello or nix shell .#hello
        devShells.hello = pkgs.mkShell { buildInputs = [ pkgs.hello pkgs.cowsay pkgs.fish ]; };
        
        devShells.test = pkgs.mkShell { buildInputs = [ pkgs.hello ]; };
        #devShells.test = pkgs.mkShell { buildInputs = [ pkgs.hello pkgs.cowsay ]; };
        # nix develop or nix shell
        devShell = self.devShells.${system}.hello;
        #devShell = self.devShells.${system}.test;

      });
}
