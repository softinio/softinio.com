{
  description = "Softinio's Zola website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    theme = { 
      url = "github:welpo/tabi/7fa208a2a5dffbc83dd2b71de1e804c2f2eaad01";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, theme }: 
  let
    themeName = ((builtins.fromTOML (builtins.readFile "${theme}/theme.toml")).name);
    allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs allSystems;
    nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in
  {
    packages = forAllSystems (system: 
        let
          pkgs = nixpkgsFor.${system};
        in  {
          default = pkgs.stdenv.mkDerivation rec {
            name = "softinio-${system}";
            version = "0.1";
            src = ./.;
            nativeBuildInputs = with pkgs; [ nodePackages_latest.wrangler zola ];
            configurePhase = ''
              mkdir -p themes
              ln -snf "${theme}" "themes/${themeName}"
            '';
            buildPhase = ''
              zola build 
            '';
            installPhase = ''
              mkdir -p $out
              cp -r public/* $out 
            '';
          };
    });

    devShells = forAllSystems (system: 
        let
          pkgs = nixpkgsFor.${system};
        in  {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ nodePackages_latest.wrangler zola ];
            shellHook = ''
              mkdir -p themes
              ln -snf "${theme}" "themes/${themeName}"
            '';
          };
    });
  };
}
