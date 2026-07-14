# Demo PATTERNS (presentation vocabulary)

**Optional building blocks, NOT a checklist.** A demo picks only the techniques that fit what it's saying; you may also invent new ones. Anything you build — reused or new — must obey `STYLE.md` (that's what keeps it consistent). The **only mandatory element is the closing end card** (§ Fixed, below).

Each entry: what it's *for* · how it's built (in brief) · which reference-demo frame to copy structure from. Colors named below (e.g. "brand accent") resolve to the brand-kit's own palette.

---

## Beat-level techniques (compose per demo)

### Hero headline build
- **For:** opening statement / section title / the one line that matters.
- **How:** big **display type, lowercase, negative tracking**; words rise in staggered (`y: 18/44/84 → 0`, `power3.out`). Optional brand-accent keyword underline/glow on the focal word.
- **Source:** opening / section-title / CTA headlines.

### Scattered / chaos field
- **For:** a "things are a mess / fragmented / too many tools" problem beat.
- **How:** several tilted, overlapping surfaces (windows/cards) crash onto the grid ground with tangled dashed connectors (muted stroke, progressive dash reveal); a darting cursor; camera slight unease.
- **Source:** scattered/problem beat.

### Notification / activity storm
- **For:** "can't keep up", alerts, incoming volume.
- **How:** toasts slam in from edges (`power4.out`), ticking mono values, camera micro-shake (shake proxy separate from blur proxy), then suck-into-center to hand off.
- **Source:** catching-up beat.

### Reveal-from-seed
- **For:** introducing the product / a unified surface out of nothing.
- **How:** brand-accent seed dot → wireframe → UI shell fills in. Great as a transition INTO the main surface.
- **Source:** hub-intro beat.

### Main surface walkthrough
- **For:** showing the actual product working (the core of most feature demos).
- **How:** build the surface per STYLE §4.1 recipe; live cursor performs a real interaction (click → ripple → state change). Reconstruct the *specific* feature UI the user supplies here.
- **Source:** main-surface / developer-surface beats.

### Choose / compare grid
- **For:** options, integrations, model/framework choice, "compare".
- **How:** card grid over a dimmed+blurred backdrop; brand-accent selection ring; descriptions crossfade per selection.
- **Source:** selection-modal beat.

### Diff / code / runtime panel
- **For:** developer angle — changes, reviews, programmability.
- **How:** slide-in right panel (`-22px 0 60px …` shadow), tabs, diff cards (add/del mono rows), runtime cards with brand-accent progress bars; optional rising terminal with colored mono logs + blinking caret.
- **Source:** developer-surface beat.

### Filmstrip / rack-focus pan
- **For:** touring several capabilities or surfaces ("works everywhere", multi-part feature).
- **How:** glass cards laid horizontally; virtual camera pans between them; focused card `blur0/op1/sc1`, receded `blur4/op0.5/sc0.92`.
- **Source:** anywhere/tour beat.

### Node mesh / flow (incl. A2A)
- **For:** connections, agent-to-agent, networks, data flow.
- **How:** nodes wired by glowing brand-accent SVG mesh with **traveling particles**; status pills; activity log. Agent-to-agent demos start here.
- **Source:** mesh/flow card.

### Connector hub
- **For:** integrations / channels.
- **How:** central brand hub, connector chips (real logos: Slack/Discord/Telegram/GitHub/Cloudflare) wired via SVG lines with join-glow pulses.
- **Source:** connector-hub card.

### Comparison chart (optional)
- **For:** data proof — only when there's a real number to show.
- **How:** editorial rails; **winner in brand accent vs baseline in neutral grey** bars; count-ups (tabular-nums); winner glow; dashed ceiling guide; callout. Chart NOT guaranteed in a demo.
- **Source:** chart beat.

### CTA moment (optional)
- **For:** a call to action before the close.
- **How:** claim headline (ink-collapse particle field optional) → brand-accent pill button (radius 52) with glow + macro-click ripple.
- **Source:** CTA beat (first half). *The pill/claim are per-demo and optional — the logo card after them is not.*

---

## Cross-frame transitions (the connective tissue)

Pick per cut; the ground color MUST stay continuous under all of them (prevents 断层):
- **recede + erupt** — outgoing scales down + blurs while incoming erupts `1.02→1`.
- **zoom-through / suck-into-seed** — outgoing scales up + blurs out; incoming emerges from a small blurred seed.
- **match-dissolve** — when the next scene's backdrop *is* the same surface; focus shifts rather than cuts.
- **modal-dismiss → sharpen** — overlay fades/scales out; the layer beneath sharpens from blur.
- **reframe** — x-shift + slight scale to move attention.
- **whip-pan** — fast x-translate + heavy blur out, mirror in.
- **clear + rise** — content fades; next rises up (used into the close).

Durations 0.36–0.5s; eases `power3.in` (out) / `power3.out` (in). SFX: whoosh on section cuts, riser on builds (STYLE §6).

---

## Fixed — the closing brand-logo end card  (MANDATORY, every demo)

The one guaranteed beat. Every demo closes on a **brand end-card** built from three parts:
1. the brand-kit's **`brandMark`** (light or dark variant per the ground), centered with a soft radial glow on the brand ground;
2. a **mono UPPERCASE seal line** beneath (letter-spaced), tagline swappable;
3. a **resolve animation** that settles the mark, blooms the glow, fades the seal up, and holds the final frame.

The **specific** mark asset, accent color, tagline, seal styling, and resolve easing are defined in the **BRAND's own `PATTERNS.md` / `STYLE.md` §4.4** — each brand-kit carries its own copy, which is the authority. Copy the end-card structure from the brand-kit's reference demo.

This is the signature sign-off — it makes any demo unmistakably that brand, regardless of what came before.
