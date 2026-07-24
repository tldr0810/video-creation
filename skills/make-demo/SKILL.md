---
name: make-demo
description: Use when making an on-brand demo/promo video with the human × Claude × HyperFrames workflow. Scaffolds a project into the central demo library and runs the 7-gate collaboration protocol (scope → script → storyboard → build → self-critique → draft → taste A/B → lock). The brand-kit supplies all brand values; with a single installed brand-kit it is selected automatically.
---

# Make a Demo Video

This skill runs the **same workflow** for every demo so output looks like the same brand, same hands. The engine (this skill) is brand-agnostic; brand style/assets/taboos come from a **brand-kit** in the central library.

## 0. Prerequisites (verify once)
If any of these are missing on this runtime, STOP and tell the user what to install (see the repo README for details) — the workflow can still plan script/storyboard without them, but cannot render.
- HyperFrames CLI available (`npx hyperframes`).
- Offline TTS: `HYPERFRAMES_PYTHON=~/.hyperframes/venv/bin/python npx hyperframes tts "<line>" -v <voice> -o assets/voice/NN.wav`
- BGM is mandatory and pre-wired in the skeleton — never ship a music-less render.
- Time to **measured** cues: `ffmpeg -i NN.wav -af silencedetect=noise=-32dB:d=0.10 -f null -` (not slot lengths).

## 1. Scaffold (one command)
`<SKILL_DIR>` = this skill's base directory (announced when the skill launches; e.g. `~/.claude/skills/make-demo` when installed as a personal skill, or the plugin's `skills/make-demo` when installed as a plugin).
`<LIBRARY>` = the resolved demo library: `$DEMO_LIB` if set → else `~/demos` if it exists → else `~/manyfold-demos` if it exists (back-compat) → else `~/demos` is created.
```bash
bash "<SKILL_DIR>/scripts/new-demo.sh" <slug> [--brand <brand>]
```
**First run?** If `<LIBRARY>/brand-kits/` is empty or missing, do NOT scaffold a demo yet — create the user's brand-kit first (§5), then come back.
Creates `<LIBRARY>/<slug>/` with skeleton + the brand-kit's assets + BGM pre-wired + a working snapshot of the brand `STYLE.md` + the brand's shared closing end card (`compositions/frames/90-end-card.html`). If `--brand` is omitted and `<LIBRARY>/brand-kits/` holds exactly one brand-kit, that one is selected automatically; with multiple, the script errors and lists them.

## 2. Read the brand-kit before authoring
Read `<LIBRARY>/brand-kits/<brand>/brand-kit.json`, its `STYLE.md` (§0 禁用清單 first), and `PATTERNS.md`. Reconstruct any new UI in-style per STYLE §4 recipes — do not re-derive style.

## 3. The 7 gates (collaboration protocol)
| Gate | | Who |
|---|---|---|
| 0 | Brief & scope — restate + request the feature's UI/screens | ⏸ user |
| 1 | `SCRIPT.md` — VO lines + timing + tone | ⏸ user |
| 2 | `STORYBOARD.md` — beats + techniques (from PATTERNS) | ⏸ user |
| 3 | Build — TTS → author frames → render | ✅ Claude |
| 4 | Self-critique vs STYLE §8 (incl. **BGM present**) | ✅ Claude |
| 5 | Draft review (sound muxed) | ⏸ user |
| 6 | Taste forks → A/B, never decide alone | ⏸ user |
| 7 | Lock + capture learnings back into the brand-kit | ✅ Claude |

See `references/PLAYBOOK.md` for the full gate detail and standing conventions.

## 4. Learning loop (Gate 7 — do this every time)
- Approved new rule → append a positive rule to `<LIBRARY>/brand-kits/<brand>/STYLE.md`.
- "Don't use X" → add to that STYLE's **§0 禁用清單** + write a cross-session memory.
Because `new-demo.sh` snapshots the brand STYLE into each project, future demos inherit every rule/taboo automatically.

## 5. Adding a new brand (phase B)
```bash
bash "<SKILL_DIR>/scripts/new-brand.sh" <brand-name>
```
Creates `<LIBRARY>/brand-kits/<brand-name>/` with a template `brand-kit.json`, a `STYLE.md` seeded from `references/STYLE-FRAME.md` (fill §0–§8 with the brand's values), and a `PATTERNS.md` stub (directs the brand to build its `components/end-card/`). Fill the REPLACE values (colors.ground and bgm are required by the scaffolder), drop in fonts/logos/BGM, then scaffold demos with `--brand <brand-name>`.

## References
- `references/PLAYBOOK.md` — gate detail + conventions.
- `references/PATTERNS.md` — technique vocabulary + the one fixed closing end-card.
- `references/STYLE-FRAME.md` — the generic method guide a new brand's STYLE.md starts from.
