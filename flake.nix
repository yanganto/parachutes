{
  description = "parachutes flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05-small";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    plotnetcfg.url = "github:yanganto/plotnetcfg/flake";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
        ./nix/shells/default.nix
      ];

      flake.overlays.myMkShell = import ./nixpkgs/myMkShell/overlay.nix;

      perSystem =
        {
          config,
          pkgs,
          system,
          nativeSuffix,
          ...
        }:
        {
          _module.args = {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ (import ./nixpkgs/myMkShell/overlay.nix) ];
              config.allowUnfree = true;
            };
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt.compiler;
            programs.nixfmt.package = pkgs.nixfmt;
          };
        };
    };
}
