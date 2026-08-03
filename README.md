# NetCrux Beta

Welcome to the home of the **NetCrux public beta** — this is where you report
bugs, request features, get help, and browse the test-fixture corpus NetCrux is
validated against.

> **NetCrux** is an interactive RTL schematic browser and netlist navigator for
> HDL engineers — elaborate Verilog / SystemVerilog / VHDL with Yosys, walk the
> hierarchy, push into any module, trace what drives a net, and cross-probe to
> the rest of the Crux suite. Linux, macOS, and Windows, plus a read-only web
> schematic viewer.

**This repository contains no application source code.** During the public beta
the NetCrux source is closed; this repo exists purely as the public meeting
point for the beta:

- 🐞 **[Report a bug](../../issues/new?template=bug_report.yml)** — or just use
  **Help → Submit Issue** inside the app (recommended; it attaches diagnostics
  for you — see below).
- 🧪 **[Submit a test fixture](../../issues/new?template=fixture_submission.yml)** —
  hand us a design that elaborates wrong, lays out badly, or traces incorrectly,
  and we'll fold it into the suite.
- 💡 **[Request a feature / share an idea](../../discussions/categories/ideas)** —
  in Discussions, so it can be discussed and upvoted.
- 🙋 **[Ask a question / get help](../../discussions/categories/q-a)** — in Discussions.
- 📋 **[Release notes](RELEASES.md)** — what changed in each beta build.
- 📂 **[Browse the test fixtures](fixtures/)** — *this is what NetCrux tests
  against.* See [`fixtures/README.md`](fixtures/README.md).

> **Two places, clear split.** The **[Issues](../../issues)** tab is a work
> queue — **bugs and fixture submissions only**. Everything conversational —
> questions, feature ideas, announcements, show-and-tell — lives in
> **[Discussions](../../discussions)**, the single community hub for the beta.
> (No Discord or Slack — Discussions keeps every answer searchable and in one
> place.)

NetCrux is part of the **EDA Crux** suite and cross-probes with its siblings over
CXP. Their betas run the same way:
[WaveCrux](https://github.com/Ferrite-Engineering/wavecrux-beta) ·
[LintCrux](https://github.com/Ferrite-Engineering/lintcrux-beta) ·
[SimCrux](https://github.com/Ferrite-Engineering/simcrux-beta).

---

## Reporting a bug — the easy way

The best bug reports come straight from the app, because they carry the
reproduction context automatically:

1. In NetCrux, open **Help → Submit Issue** (also in the command palette and the
   About box).
2. Pick which context to attach — app & environment, session state, a diagnostics
   snapshot, and (on desktop) a screenshot. App & environment is always on.
3. Hit **Submit**. NetCrux copies a formatted report to your clipboard and opens
   a pre-filled new-issue form **in this repository**. Paste if needed, drag in
   the screenshot, and submit.

No private file contents, module or net names, or file paths are included — only
counts, formats, and environment metadata. See the in-app privacy callout for
exactly what each toggle adds.

Prefer to file by hand? Use the [bug report form](../../issues/new?template=bug_report.yml).

**Elaboration bugs deserve one extra line:** tell us your **Yosys version**
(`yosys -V`), and for VHDL whether you have `ghdl-yosys-plugin` installed.
NetCrux shells out to Yosys, so the version matters more than almost anything
else in the report.

## Getting help

**[GitHub Discussions](../../discussions) is the community hub** — it's where all
the conversation happens:

- **[Q&A](../../discussions/categories/q-a)** — questions, "how do I…", workflow tips.
- **[Ideas](../../discussions/categories/ideas)** — feature requests and suggestions, upvotable.
- **[Show and tell](../../discussions/categories/show-and-tell)** — share what you've built.
- **[Announcements](../../discussions/categories/announcements)** — updates from us, including new beta builds.

**Bugs and crashes** → file an [Issue](../../issues) (above) instead, so they land
in the triage queue, not the discussion stream.

## What's in this repo

| Path | What it is |
|------|------------|
| [`README.md`](README.md) | This file. |
| [`RELEASES.md`](RELEASES.md) | What changed in each beta build. |
| [`docs/BETA_GUIDE.md`](docs/BETA_GUIDE.md) | How to join the beta, what to test, how feedback is handled, what you get for contributing. |
| [`docs/SUBMITTING_FIXTURES.md`](docs/SUBMITTING_FIXTURES.md) | How to contribute a design fixture (and the license rules). |
| [`fixtures/`](fixtures/) | The netlist + analysis test-fixture corpus NetCrux is tested against. |
| [`.github/ISSUE_TEMPLATE/`](.github/ISSUE_TEMPLATE/) | Bug / fixture issue forms (feature ideas go to Discussions). |

## After the beta

When NetCrux opens its source post-beta, the canonical repository becomes
[`Ferrite-Engineering/netcrux`](https://github.com/Ferrite-Engineering/netcrux),
and the open-core test fixtures live there alongside the code. This beta repo is
archived at that point; the in-app issue reporter automatically retargets the
open repo. Until then, **everything happens here.**

---

*NetCrux is built by [Ferrite Engineering](https://ferriteengineering.com).
Thanks for helping us make the beta better.*
