{ lib, stdenv, fetchFromGitHub, xorgserver, xinit, xrandr, nvidia_x11, mesa, makeWrapper, bbswitch}:

stdenv.mkDerivation rec {
  pname = "nvidia-xrun";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Witko";
    repo = pname;
    rev = "${version}";
    sha256 = "1waay559cnmrxp1qr3cdm63km392rcqp1l65idn08gxw3ndp1zq4";
  };
  buildInputs = [ xorgserver xinit xrandr nvidia_x11 mesa makeWrapper bbswitch];

  installPhase = ''
    mkdir -p "$out/bin"
    install -Dm 644 nvidia-xorg.conf "$out/etc/X11/nvidia-xorg.conf"
    install -Dm 644 nvidia-xinitrc "$out/etc/X11/xinit/nvidia-xinitrc"
    install -Dm 755 nvidia-xrun "$out/bin/nvidia-xrun"
    install -dm 555 "$out/etc/X11/xinit/nvidia-xinitrc.d"
    install -dm 555 "$out/etc/X11/nvidia-xorg.conf.d"
  '';

  postInstall = let
    path = stdenv.lib.makeBinPath [ xinit ];
  in "wrapProgram $out/bin/nvidia-xrun --prefix PATH : ${path}";

  meta = with lib; {
    description = ''These utility scripts aim to make the life easier for nvidia cards users.
      It started with a revelation that bumblebee in current state offers very poor performance.
      This solution offers a bit more complicated procedure but offers a full GPU utilization'';
    homepage = "https://github.com/Witko/nvidia-xrun";
    license = licenses.gpl2;
    maintainers = with maintainers; [ yanganto ];
  };
}
