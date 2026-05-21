#!/bin/bash
# Generates PNG variants of every SVG asset for download.
# Uses qlmanage (macOS QuickLook) for SVG rendering, sips for resizing.

set -e

ROOT="/Users/danielgirmay/rankonmaps-brand"
DOWNLOADS="$ROOT/downloads"
LOGO_PNG="$DOWNLOADS/logo-png"
TEMPLATE_PNG="$DOWNLOADS/templates-png"
TMP="/tmp/rom-asset-gen"

rm -rf "$DOWNLOADS" "$TMP"
mkdir -p "$LOGO_PNG" "$TEMPLATE_PNG" "$TMP"

# ─── LOGO MARKS · 256 / 512 / 1024 / 2048 ──────────────────────────────────
for f in logo-mark-ink logo-mark-paper logo-mark-sage; do
  echo "→ logo: $f"
  qlmanage -t -s 2048 -o "$TMP" "$ROOT/logo/$f.svg" >/dev/null 2>&1
  cp "$TMP/$f.svg.png" "$LOGO_PNG/${f}-2048.png"
  for size in 1024 512 256; do
    sips -z "$size" "$size" "$LOGO_PNG/${f}-2048.png" --out "$LOGO_PNG/${f}-${size}.png" >/dev/null
  done
done

# ─── APP ICONS · 1024 / 512 (iOS sizes) ────────────────────────────────────
for f in app-icon app-icon-light; do
  echo "→ app icon: $f"
  qlmanage -t -s 1024 -o "$TMP" "$ROOT/logo/$f.svg" >/dev/null 2>&1
  cp "$TMP/$f.svg.png" "$LOGO_PNG/${f}-1024.png"
  sips -z 512 512 "$LOGO_PNG/${f}-1024.png" --out "$LOGO_PNG/${f}-512.png" >/dev/null
done

# ─── TEMPLATES · native resolution ─────────────────────────────────────────
# 9:16 templates render at -s 1920 (longest side); produces 1080×1920
# 16:9 templates render at -s 1920 (longest side); produces 1920×1080
for f in 9x16-safezone caption-style podcast-clip quote-card; do
  echo "→ 9:16 template: $f"
  qlmanage -t -s 1920 -o "$TMP" "$ROOT/templates/$f.svg" >/dev/null 2>&1
  cp "$TMP/$f.svg.png" "$TEMPLATE_PNG/$f.png"
done
for f in title-card-16x9 end-card-16x9 lower-third; do
  echo "→ 16:9 template: $f"
  qlmanage -t -s 1920 -o "$TMP" "$ROOT/templates/$f.svg" >/dev/null 2>&1
  cp "$TMP/$f.svg.png" "$TEMPLATE_PNG/$f.png"
done

# ─── BUNDLE EVERYTHING INTO ONE ZIP ────────────────────────────────────────
cd "$ROOT"
ZIP_PATH="$DOWNLOADS/rom-brand-kit-assets.zip"
rm -f "$ZIP_PATH"
zip -r -q "$ZIP_PATH" \
  logo \
  templates \
  fonts \
  downloads/logo-png \
  downloads/templates-png \
  -x "*.DS_Store"
echo "→ ZIP: $ZIP_PATH ($(du -h "$ZIP_PATH" | cut -f1))"

# ─── CLEAN UP ──────────────────────────────────────────────────────────────
rm -rf "$TMP"
echo ""
echo "✓ Assets generated."
ls -1 "$LOGO_PNG" | wc -l | xargs echo "  Logo PNGs:"
ls -1 "$TEMPLATE_PNG" | wc -l | xargs echo "  Template PNGs:"
echo "  ZIP: $(du -h "$ZIP_PATH" | cut -f1)"
