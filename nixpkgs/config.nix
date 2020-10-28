{
  packageOverrides = pkgs: rec {
    find-cursor = pkgs.callPackage ./find-cursor {};
    nix-folder2channel = pkgs.callPackage ./nix-folder2channel {};

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

