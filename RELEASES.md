# NetCrux Release Notes

All notable changes between beta builds. New builds are announced in
[Discussions → Announcements](../../discussions/categories/announcements), which
is also where the download links are posted while the beta is opening up.

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
