{
  description = "Softinio's Zola website: www.softinio.com";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    theme = {
      url = "github:welpo/tabi/2e29782279d8154cb9c6f1df9a2401612ec77948";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      theme,
    }:
    let
      themeName = ((builtins.fromTOML (builtins.readFile "${theme}/theme.toml")).name);
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
          default = pkgs.stdenv.mkDerivation rec {
            name = "softinio-${system}";
            version = "0.1";
            src = ./.;
            nativeBuildInputs = with pkgs; [
              nodePackages_latest.wrangler
              zola
            ];
            configurePhase = ''
              mkdir -p themes
              ln -snf "${theme}" "themes/${themeName}"
            '';
            buildPhase = ''
              if [ -n "$BASE_URL" ]; then
                echo "Building with base URL: $BASE_URL"
                zola build --base-url "$BASE_URL"
              else
                echo "Building with default base URL from config.toml"
                zola build -f
              fi
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
            buildInputs = with pkgs; [
              git
              nodePackages_latest.wrangler
              zola
            ];
            shellHook = ''
              mkdir -p themes
              ln -snf "${theme}" "themes/${themeName}"
            '';
          };
        }
      );
    };
}
