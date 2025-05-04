+++
title =  "Using Stable And Unstable Nix/NixOS Channels Together"
date =  2025-05-03

[taxonomies]
tags = ["Nix", "NixOS"]
categories = [ "TIL" ]

[extra]
toc = true
keywords = ["Nix", "NixOS"]
+++

For one of my servers that is running NixOS I have been using the stable channel for all packages. However I wanted for one package to use the version of the package that the unstable channel had and had to learn how to do it.

I am using flakes and this is what I originally had as my input:

```nix
inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
  };
```

I added the unstable channel as an input:

```nix
inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };
    nixpkgs-unstable = { # <-- added this !
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };
```

I changed my output to make sure my system is configured with both channels as follows (see comments in code snippet for what I added):

```nix
outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable, # <--- added this
    }:
    let
      system = "x86_64-linux";

      # Define the pkgs from both stable and unstable channels
      pkgs = import nixpkgs {
        inherit system;
      };

      unstablePkgs = import nixpkgs-unstable {
        inherit system;
      };
    in
    {
      nixosConfigurations = {
        myserver = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
          ];
          specialArgs = {
            inherit pkgs unstablePkgs;   # <--- inheriting both!
          };
        };
      };
    };
```

Now where ever I define a nix function I include both `pkgs` and `unstablePkgs` as arguments and am able to chose what package from which channel to use.

For example when choosing what system packages I want to install:

```nix
environment.systemPackages = with pkgs; [
    eza
    unstablePkgs.ripgrep
];
```

Happy Days!
