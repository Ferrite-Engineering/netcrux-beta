# NetCrux Public Beta — Participant Guide

Thanks for taking part in the NetCrux public beta. This guide explains what the
beta is, how to get the most out of it, and how your feedback turns into a better
release.

## What the beta is

NetCrux is in **free, all-features-unlocked public beta**. Every capability —
including the Pro analyses (cone of influence, X-trace, CDC and reset-domain
visualization, FSM bubble diagrams, netlist diff, the switching-activity heatmap)
— is enabled for every beta user, with no license key required. Pro features
still carry a `PRO` badge so you know which tier they'll land in; during the beta
the badge is information, not a gate.

The application source is closed during the beta. This repository
(`netcrux-beta`) is the public channel for bug reports, feature requests, help,
and the test-fixture corpus.

## Installing

Download the latest beta build for your platform from the NetCrux website; new
builds are announced in
[Discussions → Announcements](../../discussions/categories/announcements). Beta
builds self-identify in **Help → About NetCrux** — the version and build SHA are
one click away via **Copy Version Info**, and the in-app reporter fills them in
for you.

Supported platforms: **Linux**, **macOS**, and **Windows**. There is also a
**read-only web schematic viewer** that renders an already-elaborated Yosys JSON
netlist in the browser — no elaboration, since browsers can't run Yosys.

### You need Yosys

NetCrux does not bundle a synthesis frontend. It shells out to **Yosys** to
elaborate your RTL, so you need Yosys on your `PATH` (or point NetCrux at it via
`--yosys-path` or **Settings → Engines**). VHDL additionally needs the
[`ghdl-yosys-plugin`](https://github.com/ghdl/ghdl-yosys-plugin).

Telling us your Yosys version in a bug report is the single highest-value line
you can add — `yosys -V` output, verbatim.

## What's most useful to test

All feedback is welcome, but these areas move the needle most during beta:

- **Elaborate your real designs.** Point NetCrux at the RTL you actually work on
  — parameterized modules, generate loops, deep hierarchies, mixed
  Verilog + VHDL, vendor IP wrappers. Tell us what fails to elaborate, what
  elaborates but renders wrong, and how long it takes.
- **Hierarchy navigation at scale.** Push in and pop out through a design with
  thousands of instances. Does the breadcrumb stay honest? Does the canvas stay
  responsive? Does level-of-detail rendering kick in where you'd want it to?
- **Schematic layout quality.** This is the hardest problem in the product and
  the place where "it works" and "it's usable" diverge. A module whose layout is
  unreadable — crossed nets, sprawling mux trees, ports in the wrong place — is
  a legitimate bug, and a great one to file with the design attached.
- **Tracing.** One-step fanin/fanout (open core) and multi-level cone of
  influence and X-trace (Pro). Does the cone contain what you expect? Does it
  stop where it should? Missing or spurious drivers are high-value reports.
- **Search.** Substring, glob, and regex across instances, modules, ports, and
  nets. Anything you can name and can't find is a bug.
- **Filelists and project files.** Import your Vivado-style `.f` filelist with
  `+incdir+`, `+define+`, `-f` recursion, and environment variables in paths.
  Anything that doesn't carry over is a bug.
- **Cross-probing.** Run NetCrux next to WaveCrux, LintCrux, or SimCrux and
  bounce a selection between them. Report anything that gets acknowledged but
  doesn't actually highlight.
- **Cross-platform + window behaviour.** Resize aggressively, go full-screen, try
  a narrow window, switch light/dark themes and the colour presets.

## How to report

### Bugs and crashes — from inside the app (best)

Use **Help → Submit Issue** (also in the command palette and the About box). It
assembles a report with your app version, platform, OS, locale, and an optional
diagnostics snapshot and screenshot, then opens a pre-filled new-issue form in
this repo. This is the highest-signal way to report, because the reproduction
context is captured automatically.

**Privacy:** the report never includes RTL source, module or net names, or file
paths — only counts, formats, and environment metadata. Each toggle in the
dialog shows exactly what it adds, and you see the full body before it's sent.

Filing by hand works too: [bug report form](../../issues/new?template=bug_report.yml).

### Feature requests and ideas

Post them in [Discussions → Ideas](../../discussions/categories/ideas), where
other beta users can discuss and upvote them and we turn accepted ones into
tracked issues. Tell us the debug workflow you're trying to complete, not just
the widget you want — it helps us find the best solution.

### Questions, help, and discussion

[GitHub Discussions](../../discussions) is the single community hub for the
beta — [Q&A](../../discussions/categories/q-a) for help,
[Ideas](../../discussions/categories/ideas) for feature requests,
[Show and tell](../../discussions/categories/show-and-tell) for what you've
built. (We're keeping everything here rather than running a Discord or Slack, so
answers stay searchable and in one place.) Keep crashes and defects in Issues so
they hit the triage queue.

## How feedback is handled

- Issues are triaged and labelled (`bug`, `beta-feedback`, platform). The in-app
  reporter applies these automatically.
- Reproducible reports — *especially ones with an attached design* — are
  prioritized, because we can turn them into a regression test.
- Fixture submissions that pass the license check are folded into the NetCrux
  test suite, so the bug you found stays fixed.

## Contributor recognition

The beta runs on community help, and we don't take it for granted. Meaningful
contributions during the beta — solid reproducible bug reports, design donations
that expose real elaboration, layout, or tracing edge cases, translations, and
community help — are recognized when NetCrux launches. Details of the
contributor program are announced on the NetCrux website and in Discussions.

## After the beta

When NetCrux opens its source, the canonical repo becomes
[`Ferrite-Engineering/netcrux`](https://github.com/Ferrite-Engineering/netcrux)
and the in-app reporter retargets it automatically. This beta repo is archived
at that point. Until then, everything happens here.

Thank you for helping shape NetCrux.
