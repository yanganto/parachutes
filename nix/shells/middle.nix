{ lib, pkgs, PROMPT ? "", ... }:
let 
  enable_ap = pkgs.writeShellScriptBin "enable_ap" (lib.readFile ../scripts/enable_ap.sh);
  dump = pkgs.writeShellScriptBin "dump" (lib.readFile ../scripts/dump.sh);
in
pkgs.mkShell {
  name = "middle";
  shellHook = ''
    export DEVSHELL=middle
    ${PROMPT}
  '';

  nativeBuildInputs = with pkgs; [
    iw
    hostapd
    dnsmasq 
    tcpdump

    # Scripts
    enable_ap
    dump
  ];
}
