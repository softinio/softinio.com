{
  description = "Softinio's Hugo website: www.softinio.com";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      allSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs allSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            name = "softinio-${system}";
            version = "0.1";
            src = ./.;
            nativeBuildInputs = [
              pkgs.hugo
              pkgs.pagefind
            ];
            buildPhase = ''
              hugo --minify
              pagefind --site public
            '';
            installPhase = ''
              mkdir -p $out
              cp -r public/* $out
            '';
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default = pkgs.mkShell {
            buildInputs = [
              pkgs.git
              pkgs.hugo
              pkgs.pagefind
            ];
          };
        }
      );
    };
}
