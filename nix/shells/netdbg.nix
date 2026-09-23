{
  lib,
  pkgs,
  plotnetcfg,
  PROMPT ? "",
  ...
}:
let
  topo = pkgs.writeShellScriptBin "topo" ''
    exec ${pkgs.python3}/bin/python3 ${../scripts/topo.py} "$@"
  '';
in
pkgs.mkShell {
  name = "netdbg";
  shellHook = ''
    export DEVSHELL=netdbg
    ${PROMPT}
  '';

  nativeBuildInputs = with pkgs; [
    plotnetcfg
    graphviz

    # Scripts
    topo
  ];
}
