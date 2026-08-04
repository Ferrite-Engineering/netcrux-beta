# Reset-Domain Analysis Fixtures (§5.2)

Fixtures for the Pro reset-domain analyzer
(`ProResetDomainAnalysisService`), consumed by the §5.2 verification
entry in `VERIFICATION_GUIDE.md` and the reset-domain integration test.

## Inventory

| Fixture | What it represents | Expected result |
|---|---|---|
| `reset_async_por_crossing.v` | Data crosses from an async power-on-reset domain (`por_n`, active-low) into a sync software-reset domain (`soft_rst`, active-high) with no boundary reset synchronizer | 2 reset domains, 1 crossing, `dataCrossesResetBoundary` / `missingSynchronizer` → **warning** (see note below) |

Each `.v` file has a companion `<name>.expected.reset.json` capturing the
canonical `ResetDomainAnalysisResult` (mirroring
`ResetDomainAnalysisResult.toJson()`). The two domains differ in polarity
(`activeLow` vs `activeHigh`), synchronicity
(`asyncAssertSyncDeassert` vs `syncAssertSyncDeassert`), and source kind
(`powerOnReset` vs `primaryInput` — `soft_rst` is wired as a plain module
input, not driven internally by a register, so it never reaches the
`softwareTriggered` branch of `ProResetDomainDetector._classifySource`),
so the detector's domain classification is exercised alongside the
crossing severity.

**Note on severity.** `ResetCrossing.severityFor` only promotes a
`dataCrossesResetBoundary + missingSynchronizer` crossing to `critical`
at `ResetConfidence.high`. `ProResetDomainAnalysisService
._classifySynchronizer` never assigns `high` confidence to a
`missingSynchronizer` outcome — only to a synchronizer chain that
already resolved as "proper" (2+ cascaded same-domain flops) — so a
direct one-hop A -> B crossing (this fixture's shape) always caps at
`medium` confidence, i.e. `warning` severity. `critical` is not a
reachable outcome for this shape today. Full trace in the generator's
doc-comment on `_resetAsyncPorCrossing`.

Also has a companion `<name>.netlist.json` — a Yosys-shaped structural
mirror of the `.v` (mirrored as a Dart const in
`integration_test/fixtures/reset_async_por_crossing_netlist.dart`),
consumed by the seeded
`integration_test/reset_domain/reset_domain_analysis_journey_test.dart`
journey via the Yosys-free design-seed helper.

## Regenerating

```bash
dart run tool/generate_pro_verification_fixtures.dart --feature reset_domains
```

The seeded integration test parses the `.netlist.json` through the real
`YosysJsonParser`, injects it into the active tab, drives the real
`runResetDomainAnalysis` opener, and asserts the analyzer output against
the companion `.expected.reset.json`. See `../helpers/README.md` for the
full regeneration reference.
