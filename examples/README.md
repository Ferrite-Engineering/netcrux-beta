# NetCrux Examples

**These are projects you open, not data a test asserts against.** Everything in
[`fixtures/`](../fixtures/) exists to be checked by the suite; everything here
exists to be run by you. We publish them so evaluating NetCrux doesn't start with
"now write a project file" — clone this repo, open one, get a schematic.

> ⚙️ **This tree is generated.** It's mirrored from the NetCrux source tree by
> tooling — don't edit it here. One thing *is* rewritten on the way out: each
> project's `sourceFiles` path is repointed at this repo's copy of the RTL under
> [`fixtures/open-core/sources/verilog/`](../fixtures/open-core/sources/verilog/),
> which is the same committed fixture the test suite elaborates. The publishing
> tool checks that every rewritten path resolves and refuses to ship an example
> that would not open.

## Both examples need Yosys — there is no toolchain-free option

Read this before you clone. NetCrux draws a schematic of an *elaborated netlist*,
and on desktop the only thing that produces one is a live **Yosys** subprocess.
Nothing here opens without it: the `.netcrux-project` schema has no netlist
field, and the elaboration cache is in-memory only, so it starts empty on every
launch.

This is the one place NetCrux differs from its sibling tools — LintCrux ships a
captured SARIF report and SimCrux replays committed logs, so both have an entry
point that needs nothing installed. NetCrux has no equivalent yet.

Without Yosys the examples do not look broken — they open a tab and report the
reason on the canvas:

> **Elaboration failed**
> Yosys was not found on your PATH. Install Yosys, or set a custom path in
> Settings.

The status bar carries a persistent `Yosys not found` segment alongside it.

```bash
# macOS
brew install yosys
# Debian / Ubuntu
sudo apt install yosys
```

Or install [OSS-CAD-Suite](https://github.com/YosysHQ/oss-cad-suite-build), which
bundles Yosys with the rest of the open toolchain.

NetCrux looks for `yosys` (`yosys.exe` on Windows) on `PATH`. Two overrides exist
when it is installed somewhere else: **Settings → Engines** takes a custom binary
path, and `--yosys-path` overrides it for a single run. If you launched NetCrux
from Finder or a desktop launcher rather than a terminal, it may not inherit the
`PATH` that has Homebrew on it; NetCrux augments the search path with the usual
install locations, but the custom path in Settings is the reliable fix.

## The examples

Launch NetCrux, then **File → Open Project…** (`Cmd/Ctrl+O`), and pick the
`.netcrux-project` file in one of the directories below. The schematic appears on
its own tab as soon as elaboration finishes.

| Example | What it demonstrates | Needs |
|---|---|---|
| [`adder4/`](adder4/adder4.netcrux-project) | The smallest thing NetCrux draws: five ports, two `$add` cells. Use it to confirm your Yosys install works before reaching for a real design. | `yosys` on `PATH` |
| [`cdc-capture/`](cdc-capture/cdc-capture.netcrux-project) | A two-clock-domain capture path — 18 cells, 7 `$adff` flops, muxes and an adder. Enough structure to exercise the hierarchy tree, the inspector, design search, and one-step fanin/fanout tracing. | `yosys` on `PATH` |

Both are also positional arguments:

```bash
netcrux examples/cdc-capture/cdc-capture.netcrux-project
```

## What to click, once the schematic is up

Both examples land on the top module with the schematic fitted to the window.
From there:

- The **Hierarchy** dock (left edge) lists the modules and instances. Double
  click an instance to descend into it; **Navigate → Jump to Top**
  (`Cmd/Ctrl+Home`) comes back up, and **Navigate → Pop Out of Scope**
  (`Cmd/Ctrl+[`) goes up one level.
- **Search → Search…** (`Cmd/Ctrl+F`) matches instances, cells and nets by
  substring, glob or regex. In `cdc-capture`, searching `req` finds the request
  pulse and both flops that sample it.
- Select a net, then **Navigate → Show Fanin** (`[`) or **Show Fanout** (`]`) to
  dim everything that is not a driver or a load of it. **Navigate → Clear
  Selection / Overlay** (`Esc`) restores the full view. Tracing `req_a` in
  `cdc-capture` walks straight into the single-flop crossing the design is built
  around.
- The **Inspector** dock (right edge) shows the selected element's type, ports
  and source location.
- **View → Zoom to Fit** (`Cmd/Ctrl+0`) reframes the schematic; the two docks
  toggle with `Cmd/Ctrl+1` and `Cmd/Ctrl+2`.

## Why these two designs

`adder4` is deliberately trivial. When elaboration fails, the useful first
question is whether Yosys works at all, and a five-port module answers it without
a design in the way.

`cdc-capture` is the EDACrux suite's shared demo design — the same fixture
WaveCrux, SimCrux and LintCrux use, each catching a different face of one planted
bug. A one-cycle request pulse crosses from `clk_a` into `clk_b` through a single
flop, with no 2-FF synchronizer and no handshake, and the multi-bit `sample_a`
bus is captured with no coherent hold. NetCrux's face of it is structural: the
crossing is visible in the schematic, and fanin from `captured_b` reaches back
into the other clock domain.

## Found a bug in one of these?

That's a good find — an example failing is a bug report with a reproduction
already attached. [File an issue](../../issues/new?template=bug_report.yml) and
name the example plus your **Yosys version** (`yosys -V`). NetCrux shells out to
Yosys, so the version matters more than almost anything else in the report.
