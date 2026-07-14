# demo-video-kit

A Claude Code plugin for making **on-brand product demo videos** with a human × Claude × [HyperFrames](https://github.com/hyperframes) workflow.

The core idea: **what's packageable about a brand's videos is consistency, not repetition.** Every demo shows different content, but they should all look like the same brand, same hands. This kit splits that into:

- **The engine (this repo, shared):** the *method* — a 7-gate collaboration protocol, a universal recipe for rebuilding any new UI in-style, motion/audio discipline, an objective self-critique checklist, and a learning loop that turns every human decision into a recorded rule.
- **Your brand-kit (yours, private):** the *values* — your colors, fonts, logos, BGM, and a growing `STYLE.md` of your brand's rules and taboos. Lives outside this repo, on your machine.

Same discipline for everyone; your own look. Nothing brand-specific ships in this engine.

## Prerequisites

- [Claude Code](https://claude.com/claude-code)
- Node.js + the HyperFrames CLI (`npx hyperframes`) — the render pipeline
- `ffmpeg` (VO cue measurement + audio mux)
- TTS: a local [Kokoro](https://github.com/hexgrad/kokoro) Python venv for offline voiceover (set `HYPERFRAMES_PYTHON` to its interpreter), or your own VO wavs

## Install

**As a plugin** (Claude Code with `/plugin` support):

```
/plugin marketplace add tldr0810/video-creation
/plugin install demo-video-kit
```

**As a personal skill** (any Claude Code environment):

```bash
git clone git@github.com:tldr0810/video-creation.git
cp -R video-creation/skills/make-demo ~/.claude/skills/make-demo
```

## Quickstart

1. **Create your brand-kit** (once):
   ```bash
   <skill-dir>/scripts/new-brand.sh <your-brand>
   ```
   This scaffolds `~/demos/brand-kits/<your-brand>/` with a template `brand-kit.json`, a `STYLE.md` seeded from the engine's method guide, and a `PATTERNS.md` stub. Fill in your colors/fonts/logos/BGM (the script prints exact next steps). Best done by extracting values from one finished video you consider canonical for your brand.

2. **Make a demo** — in Claude Code, invoke the `make-demo` skill (e.g. "use make-demo to make a demo of our new feature"). It scaffolds `~/demos/<slug>/` and walks the 7 gates:

   | Gate | | Who |
   |---|---|---|
   | 0 | Brief & scope | ⏸ you |
   | 1 | Script (VO lines + timing) | ⏸ you |
   | 2 | Storyboard (beats + techniques) | ⏸ you |
   | 3 | Build — TTS → frames → render | ✅ Claude |
   | 4 | Self-critique vs your STYLE §8 | ✅ Claude |
   | 5 | Draft review | ⏸ you |
   | 6 | Taste forks → A/B | ⏸ you |
   | 7 | Lock + write learnings back into your brand-kit | ✅ Claude |

3. **The learning loop:** every rule you approve and everything you reject at gate 5/6 is written back into your brand-kit's `STYLE.md` (rules + a growing taboo list). Your next demo inherits all of it automatically.

## Layout

```
skills/make-demo/
  SKILL.md                  # the workflow (entry point)
  references/PLAYBOOK.md    # 7-gate protocol in full
  references/PATTERNS.md    # presentation-technique vocabulary
  references/STYLE-FRAME.md # the method guide your brand STYLE.md starts from
  scripts/new-demo.sh       # scaffold a demo from your brand-kit
  scripts/new-brand.sh      # scaffold a new brand-kit
  skeleton/                 # per-demo project template (BGM pre-wired)
```

Demo library resolution: `$DEMO_LIB` env var → `~/demos` → created on first use.
