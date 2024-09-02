{
  description = "My Awesome Flake with Named Outputs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages = {
        myPackage = pkgs.hello;
      };

      devShells = {
        myDevShell = pkgs.mkShell {
          buildInputs = [
            pkgs.fish
          ];
        };
      };
    };
}

