{ lib, stdenv, fetchFromGitHub, hyprland, lua5_4, pkg-config, cmake }:

stdenv.mkDerivation rec {
  pname = "hyprlua";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "cacarico";
    repo = "hyprlua";
    rev = "v${version}";
    hash =
      "sha256-Jlej55hRuUhL7gknvyGbynTQ0axTWcyu/jnQ+p4AWlk="; # Update with: nix-prefetch-github cacarico hyprlua --rev v0.0.2
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ hyprland lua5_4 ];

  # Build using the Makefile
  buildPhase = ''
    make build
  '';

  installPhase = ''
    mkdir -p $out/lib/hyprland/plugins
    cp build/libhyprlua.so $out/lib/hyprland/plugins/

    mkdir -p $out/share/hyprlua/modules
    cp -r runtime/* $out/share/hyprlua/modules/ || true
  '';

  meta = with lib; {
    description =
      "A Hyprland plugin that embeds a Lua 5.4 runtime for configuration";
    homepage = "https://github.com/cacarico/hyprlua";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
