{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = [
    pkgs.bashInteractive
  ];
  nativeBuildInputs = with pkgs; [
    openssl
  ];
}
