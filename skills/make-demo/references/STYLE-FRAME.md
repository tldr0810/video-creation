# <BRAND> — Style Kit (template)

**This file is your brand's single source of truth for the demo-video visual / motion / audio system.**
The engine (the `make-demo` skill) supplies the *method*; this file supplies the *values*. Together they make every video in a brand read as one world.

How to use this template:

1. **Extract it from a locked reference render, not from taste.** Before filling this in, you should have ONE finished video you consider canonical for the brand. Freeze it (`renders/<name>.mp4`) and derive every value below by inspecting *that* render — fonts actually loaded, hex actually used, margins actually measured. Do not re-derive the style from scratch per project, and do not copy from older pre-canonical folders.
2. **Fill every `<placeholder>`.** Angle-bracket placeholders (`<your-accent-hex>`, `<display-face>`) mark decisions only you can make. A placeholder left unfilled is a bug — the engine cannot guess your brand.
3. **The learning loop appends here.** When the human rejects something at a taste gate (script/draft/lock), or picks an A/B variant, that decision is written back into this file as a new rule (and mirrored to cross-session memory). This file only grows more specific over time.
4. **When a choice isn't covered by a rule, never decide unilaterally.** Render two variants (A/B), let the human pick, then record the winner here as a new rule. That is the core discipline — consistency comes from *recording* decisions, not from re-guessing them.

Set your canvas once and keep it fixed: **`<width>×<height>`** (e.g. `1920×1080`), **`<light|dark>` mode throughout**, single paused master timeline.

---

## 0. 禁用清單 — Don't use (learned taboos)

**Read before building.** This is the list of things the human has explicitly rejected. Never reintroduce any of them without asking.

**It starts empty.** You have no taboos on day one. The list grows through the learning loop: every time the human says "don't use X" at a taste gate, add a bullet here *immediately*, with a one-line reason — and mirror it to Claude's cross-session memory so it survives new conversations.

```
- ❌ <rejected thing> — <one-line reason>.  (added <date>)
```

*(Append new taboos below as they come up. Each entry is a hard constraint, not a suggestion.)*

---

## 1. Typography  (families, alias swaps, scale table)

**Principle:** a brand needs exactly **two type roles** working in tension — a **display/sans face** for names, headlines, and body, and a **mono face** for anything code / path / URL / version / kicker / status / chrome label. Two faces, distinct jobs, no third font. Consistency of *role assignment* is what makes UI you build later feel native.

Define your two faces:

```css
@font-face { font-family: "<display-face>"; font-weight: 100 900; font-display: block;
             src: url("assets/fonts/<display-file>") format("<fmt>"); }
@font-face { font-family: "<mono-face>";    font-weight: 400;     font-display: block;
             src: url("assets/fonts/<mono-file>")    format("<fmt>"); }
```

- **Sans / display / body → `<display-face>`.**
- **Mono / code / labels / chrome → `<mono-face>`.**
- If you alias a font (ship face B under the CSS name of face A for portability), record the mapping here and mark the unused/dead asset so no one references it by accident.

**Scale** — fill in the sizes measured from your reference render:

| Role | Face | Size | Weight | Tracking |
|---|---|---|---|---|
| Hero headline | display | `<px or cqw>` | `<700?>` | `<negative em>` |
| Section title | display | `<px>` | `<weight>` | `<negative em>` |
| Large body / lead | display | `<px>`, lh `<1.5?>` | `<weight>` | `<em>` |
| Standard UI | display | `<px>` | `<weight>` | `<em>` |
| Small label / nav | display | `<px>` | `<weight>` | `0` |
| Code / terminal | mono | `<px>`, lh `<1.6–1.9?>` | 400 | 0 |
| Path / URL | mono | `<px>` | 400 | 0 |
| Kicker / chrome / caption | mono | `<px>`, **UPPERCASE** | 400 | **`<+em>`** (house default) |

**Rules to keep (adapt the numbers, keep the shape):**
- Large display headlines get **negative** tracking (tighter as they grow); pick a case convention (all-lowercase or sentence) and hold it.
- Mono uppercase labels get **positive** tracking — define ONE house chrome default (`<+em>`) and use it everywhere for kickers/rails/seals.
- Numbers in charts/counters use `font-variant-numeric: tabular-nums`.

---

## 2. Color  (token → hex → usage)

**Principle — accent discipline is the whole game.** Choose **ONE saturated accent** and spend it, per frame, on the **single focal element** (the selection, the live dot, the primary action, the winner). Everything else is a calm neutral ramp. Status colors (success/warning/error) are functional, not decorative. A frame with two things fighting for the accent has no focal point — that is the most common brand violation, so guard it.

Define your palette (fill every hex; keep the token names so the engine and later UI recipes resolve them):

| Token | Hex | Role |
|---|---|---|
| `ground` | `<#ground>` | Universal background, full-bleed, **continuous under every cut** |
| `surface` | `<#surface>` | Cards, windows, modals, chips |
| `surface-raised` | `<#raised>` | Sidebars, rails, headers, sub-panels |
| `ink` | `<#ink>` | Primary text / near-black-or-white, headlines, cursor fill |
| `text-2` | `<#text2>` | Secondary text, descriptions |
| `text-3` | `<#text3>` | Tertiary / chrome grey |
| `text-muted` | `<#muted>` | Captions, mono subs, placeholders |
| **`accent`** | **`<your-accent-hex>`** | **The single saturated accent** — one focal use per frame |
| `accent-lt` | `<#accent-lt>` | Gradient end / hover of the accent |
| `accent-tint` | `<#accent-tint>` | Selected / highlight fills (very low-alpha accent) |
| `success` | `<#green>` | Running / success / reachable |
| `warning` | `<#amber>` | Warning / idle |
| `error` | `<#red>` | Error, deletion, revert |
| `border` | `<#border>` | House hairline (windows, cards, grid lines) |
| `border-lt` | `<#border-lt>` | Dividers |

**Locked palette rules (品味規則 — do not violate without asking):**
- The accent is the **only** saturated color. Use it sparingly, for the one thing that matters in a frame.
- Pick your mode (`<light|dark>`) and hold it everywhere. Name any single sanctioned exception surface (e.g. a terminal bar) explicitly here — everything else obeys the mode.
- Shadows that imply "weight off the ground" should use a **tinted** shadow color (a dark version of your accent/ground family), not pure neutral black — record the exact tint: `<rgba tint>`.
- Record chart/data-viz color assignments here once decided (which series is accent, which is drained neutral) so they never drift between videos.

---

## 3. Layout & spacing

**Principle:** define a small set of **repeatable spatial constants** — margins, a radius scale, a border system, and named shadow recipes — and reuse them verbatim. New surfaces built from the same constants look like they were designed together.

Fill these from your reference render:

- **Canvas** `<width>×<height>`; every root fixed, `overflow:hidden`, `container-type:size` (enables `cqw` units).
- **Content margins:** define your house left/right margin(s) — `<margin>` for chrome/charts/CTA, plus any variants for headlines or large cards. Keep alignment to these; nothing drifts.
- **Radii scale:** `<chips>` · `<buttons/rows/cards>` · `<modals/bubbles>` · `<large floating>` · `999/50%` (pills/dots). Always pick from the scale.
- **Borders:** hairline `1px solid <#border>`; accent emphasis `1.5–2px solid <your-accent-hex>`; active-row accent `box-shadow: inset 2–3px 0 0 <your-accent-hex>`.
- **Grid field (optional):** if your brand uses a background grid, record its recipe and cell size here.

**Shadow recipes (define once, copy verbatim everywhere):**
- Window/card rest: `<0 18px 46px rgba(...)>`
- Toast / small float: `<...>`
- Floating / glass card: `<...>`
- Modal: `<...>`
- Slide-in panel: `<...>`
- Accent glow ring: `<0 0 0 4px rgba(accent,0.12), 0 0 26px rgba(accent,0.32)>`

**Signature chrome (optional but recommended):** if your brand has a recurring frame treatment (e.g. editorial top/bottom rails with mono labels), specify its exact geometry and text style here so it reproduces identically. Record anything you *removed* from the reference (corner logos, index tickers) as a "keep out" — mirror those into §0.

---

## 4. Reconstructing UI in-style (RECIPES)

**Read this framing first.** New demos bring **new, deeper product UI that does not exist in your reference frames.** Your job is not to reuse old screens — it is to **rebuild whatever UI the demo needs so it looks like it belongs in the same world.** Any reference frames you have are *examples to mine for structure*, not a required menu.

### 4.1 The universal recipe — how any surface is made to match

Any window / panel / card / modal / row is built from the same primitives (all defined in §1–§3):

- **Fill:** `surface` (primary) or a `surface-raised` tint (sidebars, headers, sub-panels), on the `ground`.
- **Border:** the house hairline. Never a heavier neutral border; for emphasis use the accent border or the inset accent bar.
- **Radius:** pick from the §3 scale — never an off-scale value.
- **Shadow:** pick the matching §3 recipe. "Weight off the ground" uses the tinted shadow, not neutral black.
- **Type inside:** display face for names/labels/body (§1 scale); **mono face** for anything code / path / URL / version / kicker / status.
- **Accent discipline:** the accent is the ONLY saturated color — spend it on the single focal element. Status uses success/warning/error per §2.
- **A live cursor** (§4.3) drives most interactions; real clicks land on real targets.

If a new surface follows the above, it will read as on-brand even though it never appeared before.

### 4.2 Reference examples (mine for structure — adapt, don't assume they reappear)

List the archetypes your reference render established, and when to reach for each. Fill in as you build:

| Example (frame) | What it demonstrates | Reach for it when… |
|---|---|---|
| `<window/app archetype>` | `<structure it shows>` | `<situation>` |
| `<toast / notification>` | `<...>` | showing updates / alerts |
| `<main product surface>` | `<...>` | the product's primary screen |
| `<modal / picker>` | `<...>` | choosing / comparing options |
| `<data-viz / chart>` | `<...>` | data proof / comparison |

### 4.3 The live cursor (used on almost every frame)
Define your cursor: an SVG arrow (~30px) filled `ink`, inverted on dark surfaces. Pair every click with a ripple ring + a press micro-scale (`~0.86–0.95 → back.out`). Movement uses eased darts (§5), never linear.

### 4.4 FIXED TEMPLATE — the closing brand-logo end card
**This is the one element guaranteed in every demo.** Everything *before* it (CTA pill, claim) is per-demo and optional; this card is not. Define it once:

- Centered **brand mark** on the `ground`, recolored to your accent (or your locked finale treatment).
- A soft **radial glow/bloom** behind the mark.
- Below it, a mono **UPPERCASE seal** at your house tracking, in `text-3` — `<YOUR TAGLINE · YOUR-DOMAIN>` (swap the tagline per campaign; keep the form).
- **Resolve animation:** mark settles with your sanctioned overshoot ease; glow blooms; seal fades up; land on a held final frame.
- **Canonical mark asset:** record the official file path(s) and viewBox here, and copy the official SVG into each project's `assets/`.

---

## 5. Motion

**Principle — calm settle, one sanctioned overshoot.** Pick a small ease vocabulary and hold it. Entrances and exits *settle* (ease-out / ease-in); the ONLY bounce/overshoot in the whole system is one sanctioned ease reserved for a few delight moments (clicks, pops, mark resolve). Everything else is calm. A stray overshoot reads as amateur, so it belongs in §8.

Fill in your motion system:

- **Registration:** each frame builds a paused timeline; a master timeline adds cross-frame tweens + a full-span anchor tween so total duration is fixed.
- **Seek-safety (non-negotiable):** deterministic proxies (`ease:"none"` + `onUpdate`), **no `Math.random` / `Date.now`** (use golden-angle spirals / fixed sin-cos jitter), count-ups via `Math.round`, bounded caret blink. The render must be identical on every seek.
- **Eases:** house entrance `<power2/3.out>` · slams `<power4.out>` · recede/exit `<power2/3.in>` · camera drift `<sine/power.inOut>` · **the ONE sanctioned overshoot** `<back.out(1.4–2.4)>` (clicks, pops, mark resolve only).
- **Durations:** micro FX `<0.1–0.3>` · entrances `<0.4–0.7>` · camera `<0.9–3.7>` · cross-frame transitions `<0.36–0.5>`.
- **Cross-frame transition vocabulary:** define a *named* set of the only transitions you allow (e.g. recede+erupt · zoom-through · match-dissolve · reframe · whip-pan · clear+rise). No hard, unmotivated cuts.
- **The seam rule:** the `ground` color stays **continuous under every cut** — never let a dark/empty background flash between frames.
- **Signature moves:** list your recurring bespoke motions (e.g. dashed-stroke draw, count-up bars, per-word headline build) so they recur consistently.

---

## 6. Audio  (BGM, SFX, voice)

**Principle — a fixed three-layer mix.** Every video carries **VO + BGM + SFX** at **fixed relative levels**, so the whole brand sounds the same. BGM is **mandatory** — a bed under everything — and one reused BGM track keeps the brand sonically consistent.

Define your levels and sources (set via `data-volume` in `index.html`):

| Layer | Source | Volume |
|---|---|---|
| Voice (VO) | `assets/voice/NN.wav` | **`<1.0>`** |
| BGM | `assets/bgm/<your-track>` | **`<0.15>`** |
| Riser | `assets/sfx/riser.*` | `<0.26–0.32>` (builds, surges) |
| Whoosh | `assets/sfx/whoosh.*` | `<0.28–0.32>` (section cuts) |
| Click | `assets/sfx/click.*` | `<0.14–0.16>` micro / `<0.4>` CTA |

- **Voice:** record your chosen voice model / preset here so every video uses the same narrator.
- ⚠ **BGM gotcha:** if your pipeline auto-generates BGM only in some modes (e.g. online), an offline render can ship silently music-less. **Add BGM manually and verify it is in the render.** Never assume the pipeline added it.
- **Timing gotcha — the most important audio rule:** the `data-duration` slot on a voice clip is **not** the wav's real spoken length. **Time animations to the *measured* VO cue, not the slot.** Measure real cues before syncing a beat to a spoken word:
  ```
  ffmpeg -i NN.wav -af silencedetect=noise=-32dB:d=0.12 -f null -
  ```

---

## 7. Assets manifest

Keep an inventory here so nothing is re-sourced or referenced by a dead path. Fill in as the brand's asset library grows:

- **Fonts:** `<display-file>` (→ "<display-face>"), `<mono-file>` (→ "<mono-face>"). Mark any dead/aliased asset explicitly.
- **Brand mark:** `<path to official SVG(s)>` + viewBox.
- **Logos / third-party marks** (`assets/ui/logos/`): `<list ready-to-use logos>`.
- **UI screenshots** (`assets/ui/`): `<list — mark which are used vs available/unused>`.
- **SFX:** riser, whoosh, click. **BGM:** `<your-track>`.

---

## 8. Self-critique checklist (run after every render, before showing the user)

Extract key frames from the render and verify each. These are **objective** — an agent can check them without guessing taste. Once §0–§7 are filled, this checklist runs verbatim for your brand.

**Correctness / sync**
- [ ] When the VO says a product / feature / name, is that thing on screen at that moment?
- [ ] Captions / labels match the spoken line; nothing lingers past its beat.
- [ ] No dark/empty seam at any cut — the `ground` stays continuous.
- [ ] No text overflow, clipping, or overlap with chrome/rails.
- [ ] Alignment holds to the house margins (§3); nothing drifts.

**Palette / brand rules**
- [ ] The accent appears on exactly **one focal thing per frame**, not scattered.
- [ ] Mode (§2) holds everywhere except the named sanctioned exception.
- [ ] Data-viz uses the recorded series colors; no off-palette color anywhere.
- [ ] Nothing on the §0 禁用清單 has crept back in.

**Type / motion**
- [ ] Headlines use the display face with the §1 case + negative tracking; mono labels are UPPERCASE at the house tracking.
- [ ] The sanctioned overshoot ease appears ONLY on sanctioned pops; everything else settles on ease-out.
- [ ] Transitions use the §5 named vocabulary; no hard/unmotivated cuts.

**Audio**
- [ ] Mix at the §6 levels (VO / BGM / SFX); **BGM is present** in the actual render.
- [ ] Beat animations land on the **measured** VO cue, not the slot length.

**When a NEW choice isn't covered by a rule above** (a brand-new color, layout, or motion decision): do **not** pick unilaterally. Render 2 variants and present an A/B to the human. Once they choose, record the decision back into this file so it becomes a rule — and add the rejected option to §0.
