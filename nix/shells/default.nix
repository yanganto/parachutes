{
  perSystem =
    {
      config,
      inputs',
      lib,
      pkgs,
      ...
    }:
    {
      devShells = {
        default = config.devShells.middle;
        middle = import ./middle.nix { inherit lib pkgs; };
        nettest = import ./nettest.nix { inherit lib pkgs; };
        netdbg = import ./netdbg.nix {
          inherit pkgs;
          plotnetcfg = inputs'.plotnetcfg.packages.plotnetcfg;
        };
        ci = import ./ci.nix { inherit lib pkgs; };
      };
      formatter = pkgs.nixfmt-rfc-style;
    };
}
