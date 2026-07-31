# NetCrux Release Notes

All notable changes between beta builds. New builds are announced in
[Discussions → Announcements](../../discussions/categories/announcements), which
is also where the download links are posted while the beta is opening up.

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
