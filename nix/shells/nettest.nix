{ lib, pkgs, PROMPT ? "", ... }:
let 
  varying_data = pkgs.writeShellScriptBin "varying_data" (lib.readFile ../scripts/varying_data.sh);
  varying_mtu = pkgs.writeShellScriptBin "varying_mtu" (lib.readFile ../scripts/varying_mtu.sh);
in
pkgs.mkShell {
  name = "nettest";
  shellHook = ''
    export DEVSHELL=nettest
    ${PROMPT}
  '';

  nativeBuildInputs = with pkgs; [
    # Scripts
    varying_data 
    varying_mtu 
  ];
}
