{
  lib,
  pkgs,
  ...
}:
let
  varying_data = pkgs.writeShellScriptBin "varying_data" (lib.readFile ../scripts/varying_data.sh);
  varying_mtu = pkgs.writeShellScriptBin "varying_mtu" (lib.readFile ../scripts/varying_mtu.sh);
in
pkgs.myMkShell {
  name = "nettest";
  myScripts = [
    varying_data
    varying_mtu
  ];
}
