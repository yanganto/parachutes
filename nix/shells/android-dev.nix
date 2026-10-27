{
  pkgs,
  ...
}:
pkgs.myMkShell {
  name = "android-dev";
  nativeBuildInputs = with pkgs; [
    android-tools
  ];
}
