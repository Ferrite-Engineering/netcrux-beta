# Netlist Diff Fixtures (§5.2.3)

Fixtures for the Pro netlist-diff service (`ProNetlistDiffService`),
consumed by the §5.2.3 verification entry in `VERIFICATION_GUIDE.md` and
the diff integration test (`test/features/diff/diff_integration_test.dart`).

This folder is **aggregate-style**: a baseline/comparison source pair
plus a single `expected_diff.json` describing the diff between them (not
one `.expected.*.json` per source).

## Inventory

| Fixture | What it represents |
|---|---|
| `baseline.v` | Baseline netlist — one `u_alu` instance |
| `comparison.v` | Comparison netlist — widens `in_a` 8→16, adds a `u_dma` instance |
| `expected_diff.json` | Canonical `NetlistDiff` (per-`elementKind` add/remove/modify/unchanged counts + the expected changed rows) |
| `baseline.netlist.json` / `comparison.netlist.json` | Yosys-shaped structural mirrors of `baseline.v` / `comparison.v`, hand-authored for the seeded Netlist Diff integration journey |

**`port` summary correction (2026-07-19).** `expected_diff.json`'s `port`
summary originally claimed `added: 0` (only `top.in_a`'s width change was
anticipated). The live value is `added: 2`:
`ProNetlistDiffService._diffPerModule` walks every module name in the
union of both sides, so the wholly-new `u_dma` module's own 2 ports
(`clk`, `data`) surface as `added` rows too — not folded into the single
"module added" row. `diff_integration_test.dart`'s synthetic fixture
never caught this because it only ever modeled a single `top` module on
each side (no `u_alu` / `u_dma` module records at all). See
`expected_diff.json`'s `_liveVerificationNote` for the full trace; a
`net` summary section was added for the same reason (previously
omitted, not previously wrong).

## Seeded-journey netlist fixtures

`baseline.netlist.json` + `comparison.netlist.json` back the seeded
Netlist Diff integration journey
(`integration_test/diff/netlist_diff_journey_test.dart`): the baseline
side is parsed via `YosysJsonParser` and injected into the active tab
Yosys-free (same technique every other seeded journey uses); the
comparison side is resolved through a test-only `NetlistLoader` override
(the production default loader has no comparison-side implementation
yet — see the journey test's doc comment). Their Dart-const mirrors live
at `integration_test/fixtures/diff_{baseline,comparison}_netlist.dart`;
all four files are pinned to each other and to a live re-classification
against `expected_diff.json` by
`test/fixtures/diff_netlist_fixture_sync_test.dart`. `u_alu` (the one
element unchanged between baseline and comparison) is given identical
`attributes` maps (no `src`) in both files, deliberately — a real
two-file Yosys elaboration would legitimately differ on `src` alone and
report `u_alu` as spuriously `modified`, which isn't the scenario this
fixture pair is documenting (see `comparison.v`'s header: "The u_alu
cell stays unchanged").

Like `fsm/`, this folder predates `tool/generate_pro_verification_fixtures.dart`
and is additionally aggregate-style (two sources sharing one expected
file) — a shape the generator's one-verilog-per-fixture model has no
field for — so it is not, and will not be, generator-owned.

## Regenerating

The `.v` sources are the structural source of truth and the
`expected_diff.json` companion is hand-maintained. To refresh against
Yosys for manual end-to-end verification, and for the full command set,
see `../helpers/README.md`. The integration test builds a synthetic
in-memory equivalent and asserts a subset of `expected_diff.json`
(running Yosys in unit tests is out of scope). The `.netlist.json`
sidecars above are hand-authored separately (not derived from a Yosys
run of the `.v` files) — update both by hand and re-run the sync test if
the structural shape changes.
