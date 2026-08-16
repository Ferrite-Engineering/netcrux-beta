# NetCrux Release Notes

All notable changes between beta builds. New builds are announced in
[Discussions → Announcements](../../discussions/categories/announcements), which
is also where the download links are posted while the beta is opening up.

---

## 0.8.0 — 2026-08-16

A maintenance release, cut with the rest of the suite so all four products stay
on one version.

### Fixed

- **Opening a file no longer breaks on macOS.** A file-picker dependency
  update turned every Open File into a plugin error; backed out and pinned, in
  all four products.

### Also

- Other performance and quality enhancements.

---

## 0.7.0 — 2026-08-11

A quiet release for NetCrux: one file that opens a design across the whole
suite, a shorter route from a schematic element to the RTL behind it, and a
reset-domain fix that is worth re-running your designs for.

### New

- **One file opens a design in all four products.** Write a `.crux-project`
  manifest at the root of your design — naming the dump, the RTL, the lint
  project and the regression config — check it in next to the RTL, and open it
  in any Crux product. NetCrux loads the `netlist` artifact when the manifest
  names one and otherwise elaborates `design.sources` directly. All four
  products derive the same design identity from it, so cross-probing works
  exactly as it does when you open each file by hand. Every path resolves
  against the manifest's own directory, so the file travels with the
  repository, and everything except `version` is optional. Open Core in all
  four products.
- **Go to source, from the Inspector.** The action already existed on the
  schematic context menu, but the Inspector is where someone reading an
  element's details actually forms the question. It is a button there now,
  rather than a reason to dismiss the panel and right-click the canvas.

### Fixed

- **A synchronous reset is recognized as a reset (Pro).** Reset-domain analysis
  knew every asynchronous reset alias Yosys emits and none of the synchronous
  one — `$sdff`'s `SRST` port was missing from the list that discovers a
  domain's members. The consequence was worse than a mislabelled synchronicity:
  a synchronously reset register looked like a register with **no reset at
  all**, so it joined no domain, no crossing analysis ran across it, and it
  drew a false "unreset register" warning against a flop that resets perfectly
  well. Synchronicity is now reported per domain, and a design that mixes the
  two shows both. **If your designs use synchronous resets, re-run the
  reset-domain analysis on this build.**

### Also

- Other performance and quality enhancements.

---

## 0.6.0 — 2026-08-04

A small release for NetCrux, which spends this cycle on getting you to a
netlist faster and on layout behaviour that stopped misbehaving at awkward
window sizes. The suite's RISC-V work this release lands in WaveCrux, SimCrux
and LintCrux.

### New

- **Two example projects you can open immediately**, with no capture or setup —
  and committed projects are now portable, so a project checked into a repo
  opens on someone else's machine.

### Fixed

- **Every IDE region has a minimum size**, so panes stop collapsing into
  unusable slivers when you drag a divider too far.
- **The camera re-aims when the canvas changes size**, instead of leaving your
  netlist off screen after a resize.

### Also

- **Linux requirements are now measured, not asserted.** Our published glibc
  figure had drifted from what we actually shipped; every release build now
  verifies it. NetCrux requires glibc 2.34, which means it runs on RHEL /
  Rocky / AlmaLinux 9, Ubuntu 22.04+ and Debian 12+.
- Other performance and quality enhancements.

---

## 0.5.0 — 2026-07-31

The release where NetCrux grew the instrumentation to tell you what it is
doing and how hard it is working — plus a Windows fix that unblocks anyone
who installed Yosys and found NetCrux could not see it.

### New

- **A live statistics strip.** Real-time layout timing while a schematic is
  being placed, so a slow elaboration is legible instead of a spinner.
- **The elaboration indicator names the running Yosys pass**, so you can see
  where a long elaboration is actually spending its time.
- **App Diagnostics.** NetCrux had no app-level diagnostics surface at all;
  it now has one, with memory and frame sections and a Pane Render Stats
  popover, reachable from the menu.
- **An Acknowledgments page** in the About box listing every third-party
  license NetCrux ships.

### Fixed

- **Yosys is found on Windows.** NetCrux now augments the persistent PATH to
  locate the executable, instead of failing to find an installed Yosys.
- **Quit works from every route.** The menu item did nothing on some screens.
- **A sensible minimum window size** (800×500) on macOS, Windows and Linux,
  so the layout can no longer be crushed into an unusable state.

### Also

- **One consistent suite.** The menu bar, toolbar, status bar and Settings are
  now shared components across all four apps, and panels moved to a
  VS Code-style dock model: bottom, right and left regions, tabs you can drag
  between docks, restore bars for collapsed regions, and direction-aware hide
  controls. The analysis dock goes multi-open — one tab per open analysis. The
  welcome screen gained an animated app logo and now shows the running
  version — handy in the browser, where there is no menu bar to check.
- Other performance and quality enhancements.

> **A note on version numbers.** NetCrux desktop builds shipped as part of the
> 2026.07 suite beta before this file caught up, and the open-core package
> version had been left at `0.1.0` by oversight. Both are corrected here: the
> app reports `0.5.0`, matching its three siblings and the suite release it
> ships in.

---

## Unreleased — 0.1.0

The first public beta. Notes land here the day it ships; until then this file is
the placeholder that tells you where to look.

What 0.1.0 is expected to cover, so you know what to point at it:

- **Elaboration** of Verilog / SystemVerilog / VHDL through Yosys (VHDL via
  `ghdl-yosys-plugin`), including mixed-language designs, Vivado-style `.f`
  filelists, and `.netcrux-project` project files.
- **Schematic canvas** with push-in / pop-out navigation, breadcrumb,
  level-of-detail rendering, pan and zoom.
- **Hierarchy tree, selection, and inspector** for instances, ports, and nets.
- **Design search** — substring, glob, and regex.
- **One-step fanin / fanout** overlay from any selection.
- **Export** to PNG, SVG, and JSON; `.netcrux` sessions and
  `.netcrux-workspace` multi-tab workspaces with split panes.
- **Cross-probing over CXP** — highlight from a peer Crux app, send your
  selection back.
- Linux, macOS, and Windows, plus a read-only web schematic viewer for
  already-elaborated Yosys netlists.
- Four display languages: English, 简体中文, 日本語, 한국어.

Pro-tier features — cone of influence, X-trace, bookmarks and annotations, the
RTL source pane, netlist diff, custom cell symbols, CDC and reset-domain
visualization, FSM bubble diagrams, and the switching-activity heatmap — are
**unlocked for everyone during the beta**, and carry a `PRO` badge so you can
tell which is which.
