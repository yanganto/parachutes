{
  packageOverrides = pkgs: rec {
    nix-folder2channel = pkgs.callPackage ./nix-folder2channel { };
    # nvidia-xrun = pkgs.callPackage ./nvidia-xrun {
    #   inherit (pkgs.linuxPackages) nvidia_x11 bbswitch;
    #   inherit (pkgs.xorg) xinit xrandr;
    # };

    wrapNeovimUnstable = pkgs.callPackage ./neovim/wrapper.nix { };
    wrapNeovim = neovim-unwrapped: pkgs.makeOverridable (neovimUtils.legacyWrapper neovim-unwrapped);
    neovim-unwrapped = pkgs.callPackage ./neovim {
      lua = pkgs.lua5_1;
    };
    neovimUtils = pkgs.callPackage ./neovim/utils.nix { };
    neovim = pkgs.wrapNeovim neovim-unwrapped { };

    # Some note for building Rust packages
    # rust_1_46 = pkgs.callPackage ./rust_146.nix {
    #   inherit (pkgs.darwin.apple_sdk.frameworks) CoreFoundation Security;
    # };
    # bat = pkgs.callPackage /tmp/new_bat/default.nix {
    #   inherit (rust_1_46.packages.stable) rustPlatform;
    #   # rustPlatform = rust_1_46.packages.stable.rustPlatform;
    # };
  };
  allowUnsupportedSystem = true;
  allowBroken = true;
  allowUnfree = true;
}
