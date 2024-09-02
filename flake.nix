{
  description = "My Awesome Flake with Named Outputs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
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

