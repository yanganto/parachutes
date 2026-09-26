{
  lib,
  pkgs,
  ...
}:
let
  publish-crate = pkgs.writeShellScriptBin "publish-crate" (lib.readFile ../scripts/publish-crate.sh);
in
pkgs.myMkShell {
  name = "ci";
  myScripts = [ publish-crate ];
  nativeBuildInputs = with pkgs; [
    rustup
    cargo
  ];
}
