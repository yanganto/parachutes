{ lib, pkgs, PROMPT ? "", ... }:
let 
  publish-crate = pkgs.writeShellScriptBin "publish-crate" (lib.readFile ../scripts/publish-crate.sh);
in
pkgs.mkShell {
  name = "ci";
  shellHook = ''
    export DEVSHELL=ci
    ${PROMPT}
  '';

  nativeBuildInputs = with pkgs; [
    rustup
    cargo
    publish-crate
  ];
}
