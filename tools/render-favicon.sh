#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_svg="$repo_root/favicon.source.svg"
output_svg="$repo_root/favicon.svg"
output_png="$repo_root/favicon.png"
output_ico="$repo_root/favicon.ico"

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$repo_root/.cache}"
mkdir -p "$XDG_CACHE_HOME"

if ! fc-match "Montserrat:style=Bold" | grep -qi "Montserrat"; then
  cat >&2 <<'EOF'
Montserrat Bold is not visible to fontconfig.

Run this from the Nix shell:

  nix-shell --run ./tools/render-favicon.sh

Or install the NixOS font package:

  fonts.packages = with pkgs; [ montserrat ];
EOF
  exit 1
fi

cat > "$source_svg" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
  width="256"
  height="256"
  viewBox="0 0 256 256"
  version="1.1"
  xmlns="http://www.w3.org/2000/svg">
  <text
    id="catena-favicon-letter"
    x="128"
    y="192"
    text-anchor="middle"
    fill="#ffffff"
    font-family="Montserrat"
    font-size="180"
    font-weight="700">C</text>
</svg>
EOF

inkscape "$source_svg" \
  --actions="select-all;object-to-path;export-filename:$output_svg;export-do" >/dev/null

perl -0pi -e '
  my ($d) = /<path\b[^>]*\bd="([^"]+)"/s;
  die "Inkscape did not produce a path\n" unless defined $d;

  $_ = qq{<svg xmlns="http://www.w3.org/2000/svg" width="256" height="256" viewBox="0 0 256 256" role="img" aria-labelledby="catena-favicon-title">\n}
     . qq{  <title id="catena-favicon-title">CATENA</title>\n}
     . qq{  <rect width="256" height="256" rx="36" fill="#090909"/>\n}
     . qq{  <path id="catena-favicon-letter" d="$d" fill="#ffffff"/>\n}
     . qq{</svg>\n};
' "$output_svg"

inkscape "$output_svg" \
  --export-type=png \
  --export-width=256 \
  --export-height=256 \
  --export-filename="$output_png" >/dev/null

magick "$output_png" -define icon:auto-resize=64,48,32,16 "$output_ico"

rm -f "$source_svg"
