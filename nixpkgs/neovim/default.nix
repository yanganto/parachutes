{ stdenv
, fetchFromGitHub
, cmake
, gettext
, msgpack
, libtermkey
, libiconv
, libuv
, lua
, ncurses
, pkgconfig
, unibilium
, xsel
, gperf
, libvterm-neovim
, tree-sitter
, glibcLocales ? null
, procps ? null

  # now defaults to false because some tests can be flaky (clipboard etc)
, doCheck ? false
, nodejs ? null
, fish ? null
, python ? null
}:

with stdenv.lib;
let
  neovimLuaEnv = lua.withPackages (ps:
    (with ps; [ lpeg luabitop mpack ]
      ++ optionals doCheck [
      nvim-client
      luv
      coxpcall
      busted
      luafilesystem
      penlight
      inspect
    ]
    ));

  pyEnv = python.withPackages (ps: [ ps.pynvim ps.msgpack ]);

  # FIXME: this is very messy and strange.
  # see https://github.com/NixOS/nixpkgs/pull/80528
  luv = lua.pkgs.luv;
  luvpath = with builtins ; if stdenv.isDarwin
  then "${luv.libluv}/lib/lua/${lua.luaversion}/libluv.${head (match "([0-9.]+).*" luv.version)}.dylib"
  else "${luv}/lib/lua/${lua.luaversion}/luv.so";

in
stdenv.mkDerivation rec {
  pname = "neovim-unwrapped";
  version = "unstable-0.5.0";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "master";
    sha256 = "0fffyspflnchry1gnxzad57nlddzc964383p7i0x8qxh3c8ki58s";
  };

  patches = [
    # introduce a system-wide rplugin.vim in addition to the user one
    # necessary so that nix can handle `UpdateRemotePlugins` for the plugins
    # it installs. See https://github.com/neovim/neovim/issues/9413.
    ./system_rplugin_manifest.patch
  ];

  dontFixCmake = true;
  enableParallelBuilding = true;

  buildInputs = [
    gperf
    libtermkey
    libuv
    libvterm-neovim
    luv.libluv
    msgpack
    ncurses
    neovimLuaEnv
    unibilium
    tree-sitter
  ] ++ optional stdenv.isDarwin libiconv
  ++ optionals doCheck [ glibcLocales procps ]
  ;

  inherit doCheck;

  # to be exhaustive, one could run
  # make oldtests too
  checkPhase = ''
    make functionaltest
  '';

  nativeBuildInputs = [
    cmake
    gettext
    pkgconfig
  ];

  # extra programs test via `make functionaltest`
  checkInputs = [
    fish
    nodejs
    pyEnv # for src/clint.py
  ];


  # nvim --version output retains compilation flags and references to build tools
  postPatch = ''
    substituteInPlace src/nvim/version.c --replace NVIM_VERSION_CFLAGS "";
  '';
  # check that the above patching actually works
  disallowedReferences = [ stdenv.cc ];

  cmakeFlags = [
    "-DGPERF_PRG=${gperf}/bin/gperf"
    "-DLUA_PRG=${neovimLuaEnv.interpreter}"
    "-DLIBLUV_LIBRARY=${luvpath}"
  ]
  ++ optional doCheck "-DBUSTED_PRG=${neovimLuaEnv}/bin/busted"
  ++ optional (!lua.pkgs.isLuaJIT) "-DPREFER_LUA=ON"
  ;

  # triggers on buffer overflow bug while running tests
  hardeningDisable = [ "fortify" ];

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
  '';

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i -e "s|'xsel|'${xsel}/bin/xsel|g" $out/share/nvim/runtime/autoload/provider/clipboard.vim
  '';

  # export PATH=$PWD/build/bin:${PATH}
  shellHook = ''
    export VIMRUNTIME=$PWD/runtime
  '';

  meta = {
    description = "Vim text editor fork focused on extensibility and agility";
    longDescription = ''
      Neovim is a project that seeks to aggressively refactor Vim in order to:
      - Simplify maintenance and encourage contributions
      - Split the work between multiple developers
      - Enable the implementation of new/modern user interfaces without any
        modifications to the core source
      - Improve extensibility with a new plugin architecture
    '';
    homepage = "https://www.neovim.io";
    # "Contributions committed before b17d96 by authors who did not sign the
    # Contributor License Agreement (CLA) remain under the Vim license.
    # Contributions committed after b17d96 are licensed under Apache 2.0 unless
    # those contributions were copied from Vim (identified in the commit logs
    # by the vim-patch token). See LICENSE for details."
    license = with licenses; [ asl20 vim ];
    maintainers = with maintainers; [ manveru rvolosatovs ma27 ];
    platforms = platforms.unix;
  };
}
