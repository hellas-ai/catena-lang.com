{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    fontconfig
    imagemagick
    inkscape
    montserrat
    perl
  ];

  shellHook = ''
    export XDG_CACHE_HOME="$PWD/.cache"
    export FONTCONFIG_FILE="$PWD/.fontconfig-local.conf"
    cat > "$FONTCONFIG_FILE" <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <dir>${pkgs.montserrat}/share/fonts</dir>
</fontconfig>
EOF
  '';
}
