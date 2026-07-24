#!/usr/bin/env bash
# new-demo.sh — scaffold a new on-brand demo into the central demo library.
# Usage:  new-demo.sh <slug> [--brand <brand>]
#
# Library resolution (LIB_DIR):
#   1. $DEMO_LIB (env) if set
#   2. ~/demos            if it exists
#   3. ~/manyfold-demos   if it exists (back-compat)
#   4. else create and use ~/demos
#
# Brand resolution:
#   --brand <name> if given; else if the library's brand-kits/ has EXACTLY ONE
#   directory, use it; else error and list available brands.
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
SLUG=""
BRAND=""
while [ $# -gt 0 ]; do
  case "$1" in
    --brand) BRAND="${2:-}"; shift 2 ;;
    *) SLUG="$1"; shift ;;
  esac
done

if [ -z "$SLUG" ]; then
  echo "usage: new-demo.sh <slug> [--brand <brand>]" >&2; exit 1
fi
SLUG="$(printf '%s' "$SLUG" | tr '[:upper:] ' '[:lower:]-' | tr -cd 'a-z0-9-')"

KITS_DIR="$LIB_DIR/brand-kits"

# ── Brand resolution (sole-brand default) ──
if [ -z "$BRAND" ]; then
  if [ ! -d "$KITS_DIR" ]; then
    echo "✗ no brand-kits found in $KITS_DIR" >&2
    echo "  create one first:  bash \"$SKILL_DIR/scripts/new-brand.sh\" <your-brand>" >&2; exit 1
  fi
  # collect immediate subdirectories of brand-kits/
  brands=()
  for d in "$KITS_DIR"/*/; do
    [ -d "$d" ] || continue
    brands+=("$(basename "$d")")
  done
  if [ "${#brands[@]}" -eq 0 ]; then
    echo "✗ no brand-kits found in $KITS_DIR" >&2
    echo "  create one first:  bash \"$SKILL_DIR/scripts/new-brand.sh\" <your-brand>" >&2; exit 1
  elif [ "${#brands[@]}" -eq 1 ]; then
    BRAND="${brands[0]}"
  else
    echo "✗ multiple brand-kits available — pass --brand <brand>." >&2
    echo "  available: ${brands[*]}" >&2
    exit 1
  fi
fi

# ── Sanitize brand (prevents path traversal) ──
BRAND="$(printf '%s' "$BRAND" | tr '[:upper:]' '[:lower:]')"
if ! printf '%s' "$BRAND" | grep -qE '^[a-z0-9-]+$'; then
  echo "✗ invalid brand name: '$BRAND' (allowed: lowercase letters, digits, hyphens)." >&2; exit 1
fi

BRAND_DIR="$KITS_DIR/$BRAND"
DEST="$LIB_DIR/$SLUG"

if [ ! -d "$BRAND_DIR" ]; then
  echo "✗ brand-kit not found: $BRAND_DIR" >&2; exit 1
fi
if [ ! -f "$BRAND_DIR/brand-kit.json" ]; then
  echo "✗ brand-kit.json not found in $BRAND_DIR" >&2; exit 1
fi
if [ -e "$DEST" ]; then
  echo "✗ $DEST already exists — pick another slug or remove it first." >&2; exit 1
fi

echo "◆ Scaffolding $DEST from brand '$BRAND'…"
mkdir -p "$DEST/compositions/frames" "$DEST/assets/voice"

# 1) brand assets (fonts, logos, brand mark, bgm, sfx)
cp -R "$BRAND_DIR/assets/." "$DEST/assets/"

# 2) skeleton config + master template (substitute __SLUG__)
for f in package.json meta.json hyperframes.json index.html; do
  sed "s/__SLUG__/$SLUG/g" "$SKILL_DIR/skeleton/$f" > "$DEST/$f"
done

# 3) brand rule-doc snapshots (learning-loop updates go back to the BRAND-KIT copies)
cp "$BRAND_DIR/STYLE.md" "$BRAND_DIR/PATTERNS.md" "$DEST/"

# 3b) shared closing end card — the one mandatory beat (source of truth lives in the brand-kit)
END_CARD="$BRAND_DIR/components/end-card/compositions/frames/end-card.html"
if [ -f "$END_CARD" ]; then
  cp "$END_CARD" "$DEST/compositions/frames/90-end-card.html"
else
  echo "⚠ brand-kit has no components/end-card — scaffold lacks the closing card." >&2
  echo "  Build one (layout: see an existing brand-kit's components/end-card/ + PATTERNS § Fixed)." >&2
fi

# 4) brand-value substitution in index.html (from brand-kit.json)
python3 - "$BRAND_DIR/brand-kit.json" "$DEST/index.html" <<'PY'
import json, sys, pathlib
kit_path, html_path = sys.argv[1], sys.argv[2]
try:
    kit = json.loads(pathlib.Path(kit_path).read_text())
except FileNotFoundError:
    sys.exit(f"✗ brand-kit.json missing: {kit_path}")
except json.JSONDecodeError as e:
    sys.exit(f"✗ brand-kit.json unparsable: {kit_path} — {e}")
try:
    ground = kit["colors"]["ground"]
    bgm = kit["bgm"]
except KeyError as e:
    sys.exit(f"✗ brand-kit.json missing key {e}: {kit_path}")
p = pathlib.Path(html_path)
html = p.read_text()
html = html.replace("__GROUND__", ground).replace("__BGM__", bgm)
p.write_text(html)
PY

echo "✓ Created $DEST"
echo "  library: $LIB_DIR"
echo "  brand:   $BRAND"
echo "  assets:  fonts · $(ls "$DEST/assets/ui/logos" | wc -l | tr -d ' ') logos · brand-mark · BGM · SFX"
echo "  docs:    STYLE.md · PATTERNS.md (snapshots)"
if [ -f "$DEST/compositions/frames/90-end-card.html" ]; then
  echo "  close:   compositions/frames/90-end-card.html (shared end card — mount as final beat)"
fi
echo "  NEXT — follow the skill's 7 gates (see references/PLAYBOOK.md), starting at Gate 0."
