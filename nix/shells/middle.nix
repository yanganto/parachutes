{
  lib,
  pkgs,
  ...
}:
let
  enable_ap = pkgs.writeShellScriptBin "enable_ap" (lib.readFile ../scripts/enable_ap.sh);
  dump = pkgs.writeShellScriptBin "dump" (lib.readFile ../scripts/dump.sh);
in
pkgs.myMkShell {
  name = "middle";
  myScripts = [
    enable_ap
    dump
  ];
  nativeBuildInputs = with pkgs; [
    iw
    hostapd
    dnsmasq
    tcpdump
  ];
}
