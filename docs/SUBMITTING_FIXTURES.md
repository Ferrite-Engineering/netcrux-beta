# Submitting a Test Fixture

A **fixture** is a small design plus the result NetCrux *should* produce from it.
Fixtures are how NetCrux proves its elaboration, layout, and analyses stay
correct: every fixture in [`fixtures/`](../fixtures/) runs in the test suite, so
once a design is in, the behavior it captures can never silently regress.

If you found a design that fails to elaborate, renders as an unreadable
schematic, or traces to the wrong drivers — **that design is the most valuable
thing you can give us.** This guide explains how to submit one and the rules it
has to follow.

## The fastest path

1. Open the
   **[fixture submission form](../../issues/new?template=fixture_submission.yml)**.
2. Attach (or link) the design — the RTL sources (`.v`, `.sv`, `.vhd`) and, if
   you have one, the elaborated Yosys netlist (`yosys -p 'read_verilog …;
   hierarchy -auto-top; proc; write_json out.json'`).
3. Tell us your **Yosys version** (`yosys -V`), what NetCrux currently does, and
   what it *should* do.
4. Confirm the licensing (below).

We take it from there: trim it, snapshot the expected result, document its
provenance, and fold it into the suite. You'll be credited on the resulting
change.

## What makes a great fixture

- **Small and focused.** One module — or one small hierarchy — that still
  reproduces the behavior. We can trim, but a tight design is gold. Aim for
  under a few hundred KB of RTL.
- **Self-contained.** No vendor IP, no macros from a proprietary header, no
  `include` you can't ship. If it doesn't elaborate on a clean machine with
  stock Yosys, it can't be a fixture.
- **A known-correct answer.** The bug isn't "the schematic looks wrong" — it's
  "the fanin cone of `wb_dat_o` should include `u_alu`, and NetCrux stops at the
  register." The more precisely you can state the expected result, the faster it
  becomes a test.
- **Say which kind of bug it is.** Elaboration failure, hierarchy shape,
  schematic layout, tracing, CDC/reset-domain analysis, FSM detection, and diff
  each land in a different part of the corpus and get a different companion
  snapshot.
- **Real or hand-crafted, both welcome.** A module from a real project that
  breaks the layout engine, or a minimal hand-built design that isolates an edge
  case — either is great.

## Licensing — please read

Fixtures we publish must be redistributable, because [`fixtures/`](../fixtures/)
is public. We can only accept fixtures under a permissive license:

> **MIT, BSD-2-Clause, BSD-3-Clause, Apache-2.0, ISC, CC0, or public domain.**

- **Your own hand-crafted design?** Easiest case — by submitting it you agree to
  contribute it under CC0 / public domain so it can live in the test suite.
- **Derived from an open-source project?** Only if that project is under one of
  the licenses above. Tell us the project, the commit/version, and how you
  elaborated it (Yosys version and the exact script or command line). We record
  this as provenance.
- **From proprietary, GPL, or AGPL sources, or anything you can't relicense?**
  We can't accept it — please don't attach it. A *hand-rebuilt* minimal design
  that reproduces the same behavior without copying the original is fine.

Submissions without clear, permissive provenance can't be published, and our
tooling refuses to publish a captured fixture that lacks a provenance record.

## How fixtures are organized

See [`fixtures/README.md`](../fixtures/README.md) for the full layout. In short:

- `generated/` — deterministic designs and netlists produced by our own
  generators, each with a golden snapshot of the expected elaboration result.
- `captured/` — real designs taken from **permissively-licensed** open-source
  projects, each with a `PROVENANCE.md` recording the upstream project, commit,
  license, and the exact Yosys invocation used to elaborate it.

Your submission typically becomes a new `captured/` entry (with provenance) or a
new `generated/` case if we can reproduce it with a generator.

Thank you — every design you contribute makes NetCrux more correct for everyone.
