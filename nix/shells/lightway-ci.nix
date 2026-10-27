{
  pkgs,
  ...
}:
pkgs.myMkShell {
  name = "lightway-ci";
  myScripts = [ ];
  nativeBuildInputs = with pkgs; [
    earthly
  ];
  DOCKER_HOST = "unix:///var/run/docker.sock";
}
