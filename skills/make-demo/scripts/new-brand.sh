#!/usr/bin/env bash
# new-brand.sh — scaffold a new brand-kit into the central demo library.
# Usage:  new-brand.sh <brand-name>
#
# Library resolution (LIB_DIR):
#   1. $DEMO_LIB (env) if set
#   2. ~/demos            if it exists
#   3. ~/manyfold-demos   if it exists (back-compat)
#   4. else create and use ~/demos
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"   # …/skills/make-demo

# ── Library resolution ──
if [ -n "${DEMO_LIB:-}" ]; then
  LIB_DIR="$DEMO_LIB"
elif [ -d "$HOME/demos" ]; then
  LIB_DIR="$HOME/demos"
elif [ -d "$HOME/manyfold-demos" ]; then
  LIB_DIR="$HOME/manyfold-demos"   # back-compat
else
  LIB_DIR="$HOME/demos"
  mkdir -p "$LIB_DIR"
fi

# ── Parse args ──
BRAND="${1:-}"
if [ -z "$BRAND" ]; then
  echo "usage: new-brand.sh <brand-name>" >&2; exit 1
fi

# ── Sanitize brand (same rule as new-demo.sh) ──
BRAND="$(printf '%s' "$BRAND" | tr '[:upper:]' '[:lower:]')"
if ! printf '%s' "$BRAND" | grep -qE '^[a-z0-9-]+$'; then
  echo "✗ invalid brand name: '$BRAND' (allowed: lowercase letters, digits, hyphens)." >&2; exit 1
fi

KITS_DIR="$LIB_DIR/brand-kits"
BRAND_DIR="$KITS_DIR/$BRAND"

if [ -e "$BRAND_DIR" ]; then
  echo "✗ $BRAND_DIR already exists — pick another brand name or remove it first." >&2; exit 1
fi

echo "◆ Scaffolding $BRAND_DIR…"
mkdir -p "$BRAND_DIR/assets/fonts" "$BRAND_DIR/assets/bgm" "$BRAND_DIR/assets/sfx" "$BRAND_DIR/assets/ui/logos"

# 1) template brand-kit.json
cat > "$BRAND_DIR/brand-kit.json" <<JSON
{
  "brand": "$BRAND",
  "colors": { "ground": "#REPLACE", "surface": "#REPLACE", "ink": "#REPLACE", "accent": "#REPLACE" },
  "fonts": {
    "primary": { "family": "REPLACE", "cssAlias": "REPLACE", "file": "assets/fonts/REPLACE.ttf" },
    "mono": { "family": "REPLACE", "cssAlias": "REPLACE", "file": "assets/fonts/REPLACE.woff2" }
  },
  "logosDir": "assets/ui/logos",
  "brandMark": { "light": "assets/brand-mark-light.svg", "dark": "assets/brand-mark-dark.svg" },
  "bgm": "assets/bgm/REPLACE.wav",
  "sfx": {},
  "voice": "am_michael",
  "styleDoc": "STYLE.md",
  "patternsDoc": "PATTERNS.md"
}
JSON

# 2) STYLE.md — seed from the engine's generic method guide
cp "$SKILL_DIR/references/STYLE-FRAME.md" "$BRAND_DIR/STYLE.md"

# 3) PATTERNS.md — minimal stub
cat > "$BRAND_DIR/PATTERNS.md" <<MD
# $BRAND — PATTERNS

This brand inherits the engine's generic PATTERNS vocabulary (see the \`make-demo\` skill's \`references/PATTERNS.md\` for the full technique list). Add brand-specific techniques here as they're invented. This file **must** define the brand's own closing end-card (mark + seal + resolve animation) — the one mandatory element every demo ends with.
MD

echo "✓ Created $BRAND_DIR"
echo "  library: $LIB_DIR"
echo "  assets:  fonts · bgm · sfx · ui/logos (empty — drop files in)"
echo ""
echo "NEXT STEPS"
echo "  1. Replace every REPLACE value in brand-kit.json — colors.ground and bgm are load-bearing"
echo "     (the scaffolder substitutes __GROUND__ and __BGM__ from them into each new demo)."
echo "  2. Drop font/logo/BGM files into $BRAND_DIR/assets/."
echo "  3. Fill STYLE.md §0–§8 with this brand's real values (extract from a locked reference render)."
echo "  4. Define the brand's closing end-card in PATTERNS.md."
echo "  5. Scaffold a demo: \"$SKILL_DIR/scripts/new-demo.sh\" <slug> --brand $BRAND"
