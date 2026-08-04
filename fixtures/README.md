# NetCrux Test Fixtures

**This is what NetCrux tests against.** Every design here is part of the NetCrux
test suite — each one has a known-correct expected result, and elaboration,
hierarchy construction, tracing, and the Pro analyses are validated against it on
every change. We publish the corpus so you can see exactly how NetCrux is
verified, elaborate the designs yourself, and
[contribute your own](../docs/SUBMITTING_FIXTURES.md).

During the public beta all features are unlocked, so you can open both the
open-core and the Pro fixtures in the app and watch every analysis run against
them.

> ⚙️ **This tree is generated.** It's mirrored from the NetCrux test suite by
> tooling — don't edit it here. To contribute a fixture, use the
> **[fixture submission form](../../issues/new?template=fixture_submission.yml)**;
> see [SUBMITTING_FIXTURES.md](../docs/SUBMITTING_FIXTURES.md).

Looking for something you can just **open and run**? That's
[`examples/`](../examples/) — two ready-made projects that draw a schematic.
This tree is test data; those are tools.

## What needs Yosys, and what doesn't

Say it up front, because it decides what you can do with this tree:

- The **`.v` / `.sv` / `.vhd` sources** here are RTL. To see one as a schematic
  you need **Yosys on your `PATH`** — NetCrux draws elaborated netlists, and on
  desktop the only thing that produces one is a live Yosys subprocess. There is
  no pre-elaborated artifact you can open in its place.
- The **`.netlist.json` / `.netlist.json.gz` files** are already-elaborated,
  Yosys-shaped JSON. The test suite ingests those directly, which is why most of
  NetCrux's tests run with no Yosys installed at all. They are inputs to the
  parser, not files the app opens from a menu.

So: the corpus is fully *readable* with nothing installed, and the RTL becomes
*viewable* once Yosys is. `brew install yosys`, `sudo apt install yosys`, or
[OSS-CAD-Suite](https://github.com/YosysHQ/oss-cad-suite-build).

## Layout

```
fixtures/
├── open-core/                # Fixtures for the free, open-core viewer
│   ├── sources/              # RTL and project inputs
│   │   ├── verilog/          #   Verilog / SystemVerilog + expected elaborations
│   │   ├── vhdl/             #   VHDL (needs ghdl-yosys-plugin to elaborate)
│   │   ├── mixed/            #   a VHDL entity instantiated from Verilog
│   │   ├── filelist/         #   Vivado-style .f expansion, incl. include cycles
│   │   └── project/          #   a .netcrux-project schema golden
│   └── netlist/<design>/     # Elaborated designs, split generated/ + captured/
└── pro/                      # Fixtures for the Pro analyses
    ├── tracing/              # Cone of influence + X-trace
    ├── cdc/                  # Clock-domain-crossing detection
    ├── reset_domains/        # Reset-domain crossing detection
    ├── fsm/                  # FSM state-machine detection
    ├── diff/                 # Netlist diff (baseline vs. comparison)
    ├── cxp_originate/        # Cross-probe name resolution
    └── sources/verilog/      # RTL the Pro analysis tests elaborate
```

Every design directory under `netlist/` is split into two tiers:

- **`generated/`** — deterministic designs emitted by NetCrux's own fixture
  generators (a scale ladder from a thousand cells to a hundred thousand, an
  adversarial malformed corpus, seeded designs). 100% reproducible; the unit-test
  backbone. Each carries the RTL, the Yosys-shaped netlist JSON it elaborates to,
  and an `.expected_netlist.json` golden — module/cell/net counts, a cell-type
  histogram, and a fingerprint.
- **`captured/`** — real designs taken from **permissively-licensed open-source
  projects** (PicoRV32, VexRiscv), exercising elaboration and hierarchy
  construction against RTL nobody on this team wrote. Each `captured/` directory
  carries a **`PROVENANCE.md`** recording the source project, version/commit,
  license, and the exact Yosys invocation used to elaborate it, plus the same
  `.expected_netlist.json` companion.

The Pro directories follow the same idea with analysis-specific companions: a
small RTL design, the netlist it elaborates to, and a golden snapshot of what the
analysis must produce (`expected.cdc.json`, `expected.reset.json`,
`expected.overlay.json`, `expected.trace.json`, `expected_diff.json`, and so on).
Each carries a `README.md` inventory naming what every fixture represents and the
result it pins — including the corrections we've had to make, which are worth
reading if you want to know how seriously these are taken.

## What's covered

**Open core:** Verilog and SystemVerilog elaboration, VHDL via
`ghdl-yosys-plugin`, mixed-language designs, Vivado-style `.f` filelist expansion
(including include cycles), project files, malformed-netlist hardening, and a
scale ladder from a thousand cells up to a hundred thousand. The million-cell
mesh is a manifest only — it is built on demand by the ingestion benchmark rather
than committed.

**Pro:** cone-of-influence and X-trace overlays, CDC crossing detection,
reset-domain crossing detection, FSM detection (binary, one-hot, Gray, Johnson,
multiple and unreachable states), netlist diff, and CXP cross-probe name
resolution.

## Licensing

`generated/` fixtures are produced by NetCrux's own generators and are released
into the public domain (CC0).

`captured/` fixtures retain the license of the upstream project they were derived
from — always one of **MIT, BSD-2-Clause, BSD-3-Clause, Apache-2.0, ISC, CC0, or
public domain**. The exact source and license for each is in that directory's
`PROVENANCE.md`. NetCrux's publishing tool **aborts** rather than publish a
captured fixture that lacks a provenance record, and the test suite blocks any
fixture outside the license allow-list.

If you reuse a captured fixture, honor the upstream license named in its
`PROVENANCE.md`.
