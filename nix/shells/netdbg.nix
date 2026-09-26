{
  pkgs,
  plotnetcfg,
  ...
}:
let
  topo = pkgs.writeShellScriptBin "topo" ''
    exec ${pkgs.python3}/bin/python3 ${../scripts/topo.py} "$@"
  '';
in
pkgs.myMkShell {
  name = "netdbg";
  myScripts = [ topo ];
  nativeBuildInputs = with pkgs; [
    plotnetcfg
    graphviz
  ];
}
