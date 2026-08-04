# CDC Analysis Fixtures (§5.1)

Fixtures for the Pro clock-domain-crossing analyzer
(`ProClockDomainAnalysisService`), consumed by the §5.1 verification
entry in `VERIFICATION_GUIDE.md` and the CDC integration test.

## Inventory

| Fixture | What it represents | Expected result |
|---|---|---|
| `cdc_two_domain_2ff.v` | Single-bit flag synchronized `clk_a → clk_b` with a proper 2-flop synchronizer | 2 domains, 1 crossing, `singleBit` / `properTwoFlopSync` → **info** (safe) |
| `cdc_missing_sync.v` | Single-bit signal (`enable_a`) used across `clk_a → clk_b` with no synchronizer | 2 domains, 1 crossing, `singleBit` / `missingSynchronizer` → **critical** |

> **2026-07-19 correction.** `cdc_missing_sync.expected.cdc.json`'s
> `crossingKind` was hand-authored as `control`, but the live
> `_classifyCrossingKind` keys on name suffixes (`_en` / `_enable` /
> `_sel` / `_select` / `ctrl`) and `enable_a` matches none, so the
> shipping value is `singleBit`. The **severity is unchanged** —
> `missingSynchronizer` is critical for every crossing kind. The missing
> synchronizer is detected through combinational logic (the enable mux),
> so `synchronizerInstances` carries that comb cell (`top.capture_mux`),
> not the previously-committed empty list. Both were caught by wiring the
> canonical JSON into the live-service sync test
> (`test/fixtures/cdc_netlist_fixture_sync_test.dart`).

Both fixtures now ship a `<name>.netlist.json` Yosys-shaped structural
mirror (Dart const in `integration_test/fixtures/`) that the sync test
feeds through the real `YosysJsonParser` + `ProClockDomainAnalysisService`
and asserts against the companion `.expected.cdc.json` — the seeded
journey, the mirror, and the canonical expectations can no longer drift
apart. Domain ids (`dom-N`) and clock-signal paths (bare `clk_a`) are
service-internal; the readable `cd_clk_a` / `top.clk_a` in the JSON are
documentation and are **not** asserted.

Each `.v` file has a companion `<name>.expected.cdc.json` capturing the
canonical `CdcAnalysisResult` the analyzer produces (mirroring
`CdcAnalysisResult.toJson()`, plus `expected*Count` convenience keys).
The severities are the deterministic output of
`CdcCrossing.severityFor(kind, status)` — the fixtures pin one safe and
one critical row so the severity matrix is exercised end to end.

## Regenerating

The `.v` sources and the `.expected.cdc.json` companions are both emitted
by the shared generator (their canonical values live in the generator, not
in Yosys):

```bash
dart run tool/generate_pro_verification_fixtures.dart --feature cdc
```

The integration test builds a synthetic `NetlistModel` matching each
fixture's structural shape (running Yosys in unit tests is out of scope)
and asserts the analyzer output against the companion JSON. See
`../helpers/README.md` for the full regeneration reference.
