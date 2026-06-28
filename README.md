# CATENA website

Static single-page site for `catena-lang.org` / `catena-lang.com`.

## Files

- `index.html` - the site.
- `catena-logo.svg` - CATENA wordmark, generated from Montserrat Bold 700 and converted to paths.
- `favicon.svg`, `favicon.ico`, `favicon.png` - favicon assets generated from a Montserrat Bold 700 `C`.
- `tools/render-logo.sh` - regenerates `catena-logo.svg`.
- `tools/render-favicon.sh` - regenerates favicon assets.
- `shell.nix` - local tooling with `montserrat`, `fontconfig`, `inkscape`, `imagemagick`, and `perl`.

## Editing

Edit `index.html` directly. It is standalone and has no runtime build step.

## Regenerating assets

With Nix:

```sh
nix-shell --run ./tools/render-logo.sh
nix-shell --run ./tools/render-favicon.sh
```
