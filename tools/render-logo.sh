#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_svg="$repo_root/catena-logo.source.svg"
output_svg="$repo_root/catena-logo.svg"

export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$repo_root/.cache}"
mkdir -p "$XDG_CACHE_HOME"

if ! fc-match "Montserrat:style=Bold" | grep -qi "Montserrat"; then
  cat >&2 <<'EOF'
Montserrat Bold is not visible to fontconfig.

Run this from the Nix dev shell:

  nix develop
  ./tools/render-logo.sh

Or install the NixOS font package:

  fonts.packages = with pkgs; [ montserrat ];
EOF
  exit 1
fi

cat > "$source_svg" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<svg
  width="1180"
  height="180"
  viewBox="0 0 1180 180"
  version="1.1"
  xmlns="http://www.w3.org/2000/svg">
  <text
    id="catena-wordmark"
    x="590"
    y="128"
    text-anchor="middle"
    fill="#ffffff"
    font-family="Montserrat"
    font-size="140"
    font-weight="700"
    letter-spacing="50">CATENA</text>
</svg>
EOF

inkscape "$source_svg" \
  --actions="select-all;object-to-path;export-filename:$output_svg;export-do" >/dev/null

perl -0pi -e '
  my ($d) = /<path\b[^>]*\bd="([^"]+)"/s;
  die "Inkscape did not produce a path\n" unless defined $d;

  $_ = qq{<svg xmlns="http://www.w3.org/2000/svg" width="1180" height="180" viewBox="0 0 1180 180" role="img" aria-labelledby="catena-logo-title">\n}
     . qq{  <title id="catena-logo-title">CATENA</title>\n}
     . qq{  <path id="catena-wordmark" d="$d" fill="#ffffff"/>\n}
     . qq{</svg>\n};
' "$output_svg"

rm -f "$source_svg"
