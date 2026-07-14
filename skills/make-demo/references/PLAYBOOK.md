# Demo PLAYBOOK (collaboration protocol)

**This file defines HOW the user and Claude make a demo together — the constant process, regardless of which video.**
Pair with `STYLE.md` (visual consistency) and `PATTERNS.md` (presentation vocabulary). Follow these gates every time so the rhythm never has to be re-taught.

Guiding split: **Claude owns execution + objective correctness; the user owns scope + taste.** Claude confirms 3× up front (scope → script → storyboard), then builds and self-critiques, then only comes back for taste.

`<LIBRARY>` = the resolved demo library directory (see SKILL.md §1 for how it's resolved).

---

## The 7 gates

### Gate 0 — Brief & scope  ⏸ user confirms
The user gives: the **feature/topic**, the **goal** (what a viewer should feel/do), the **length**, and what **materials** they'll provide.
Claude does:
- Restate the scope in one short paragraph so misunderstanding surfaces now, not at render time.
- **Request exactly what's needed**: which product screens/screenshots/recordings, any feature notes, any specific claims/numbers. New/deeper UI comes from the user — don't invent product screens.
- Confirm which brand tokens apply (default: all of STYLE.md as-is).
→ Do not proceed until the user confirms scope.

### Gate 1 — SCRIPT  ⏸ user confirms
Claude writes `SCRIPT.md`: numbered lines, each with **time window**, **delivery/tone note**, and the exact VO text. Match the house voice (see the brand's reference demo for tone). Voice = the brand-kit's `voice` (Kokoro TTS, offline).
This is the **cheapest, highest-leverage gate** — a wrong script wastes everything downstream.
→ Do not build visuals until the user approves the script.

### Gate 2 — Storyboard / beat plan  ⏸ user confirms
Claude proposes the beat sequence: for each beat — what it shows, which **presentation technique** from PATTERNS (or a new one), and **which of the user's supplied images/assets go where**. Beats are chosen for THIS demo (not a fixed template); the closing brand-logo end card (STYLE §4.4) is always the last beat.
→ Do not build until the user confirms the plan.

### Gate 3 — Build  ✅ Claude
Author the HTML compositions (per STYLE recipes), generate TTS, measure VO cues (`silencedetect`), assemble the `main` timeline, add cross-frame transitions, render. Keep the dev server running in the background for preview. No need to involve the user here.

### Gate 4 — Self-critique (the "B eye")  ✅ Claude
Run **STYLE.md §8 checklist** against the actual render (extract key frames; step transitions frame-by-frame). Fix every **objective** issue found — name/visual sync, `断层` seams, overflow/alignment, palette-rule violations, cue timing. Re-render until the objective checklist passes. Do NOT hand the user something that fails an objective check.

### Gate 5 — Draft review  ⏸ user confirms
Deliver the render **with audio muxed** (VO 1.0 / BGM 0.15 / SFX per STYLE §6) — never a silent file. The user gives **taste** feedback (pacing, emphasis, aesthetic).

### Gate 6 — Taste forks  ⏸ user confirms
Whenever a choice is **not** covered by STYLE.md (a new color, a new layout, an ambiguous aesthetic call), **do not decide unilaterally** — render 2 variants and present an **A/B**. The user picks.

### Gate 7 — Lock + capture (the learning loop)  ✅ Claude, user nods
On lock:
- Every **approved new decision** → write learnings back into `<LIBRARY>/brand-kits/<brand>/STYLE.md`: add as a positive rule in the relevant section.
- Every **rejection / "don't use X"** → write learnings back into `<LIBRARY>/brand-kits/<brand>/STYLE.md` **§0 禁用清單** with a one-line reason, **and** to Claude's cross-session memory.
- Note the final render path + version.
This is what makes the kit smarter each use — rules accumulate, taboos accumulate, style converges.

---

## Rhythm at a glance

```
user: brief ─▶ [G0 scope✓] ─▶ [G1 script✓] ─▶ [G2 storyboard✓]
                                                      │
                            Claude: [G3 build] ─▶ [G4 self-critique]
                                                      │
                                   ─▶ [G5 draft✓] ⇄ [G6 taste A/B✓] ─▶ [G7 lock + capture]
```
The user touches it 3× up front + taste at the end. Claude carries everything in between.

---

## Standing conventions (apply on every project)

- **Drafts always ship with sound muxed.** Mux at STYLE §6 levels; slice BGM at the beat's global start offset.
- **BGM is mandatory and must be added manually.** Offline TTS skips auto-BGM — the brand-kit's BGM track is copied into `assets/` and pre-wired as the track-11 `<audio>` (volume 0.15) in the skeleton. A render with no BGM is a Gate-4 failure. *(Learned: A2A trial, 2026-07-13.)*
- **Time to measured cues, never slots.** `ffmpeg -i NN.wav -af silencedetect=noise=-32dB:d=0.12 -f null -` before timing any beat's animation.
- **Dev server stays alive** in the background (`npm run dev`, `run_in_background: true`) so the user can preview anytime.
- **Always `npm run check`** after editing any composition; fix all errors before rendering.
- **Ground continuity** (the brand `ground` color under every cut) is checked at Gate 4, every time.
- **New UI comes from the user.** Don't fabricate product screens; request them at Gate 0. Reconstruct them in-style per STYLE §4.
- **The last beat is always the closing brand-logo end card** (STYLE §4.4).
