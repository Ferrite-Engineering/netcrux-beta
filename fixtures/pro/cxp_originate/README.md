# CXP-Originate Fixtures (§6)

Fixtures for the Pro outbound cross-probe originator
(`CrossProbeOriginator`), consumed by the §6 verification entry in
`VERIFICATION_GUIDE.md` and the CXP-originate integration test.

## Inventory

| Fixture | What it represents | Expected result |
|---|---|---|
| `cxp_originate_hierarchy.v` | Two-level hierarchy (`top → u_cpu → {clk, data_bus}`); selecting an element resolves to a canonical `ElementId` and dispatches a `RequestHighlight` | Per-scenario canonical path + `CrossProbeDispatchResult` (see companion JSON) |

The companion `cxp_originate_hierarchy.expected.cxp.json` pins one
scenario per selection kind — instance, port, net — plus the
`noServer` short-circuit. Each scenario maps a `(scope, element)`
selection to:

- the canonical `ElementId` the outbound `RequestHighlight` carries
  (deterministic `NetcruxNameResolver` output; instance paths use the
  `:cell` suffix, a boundary port uses the `:port:<name>` marker, a net
  uses `:net:<edgeId>`), and
- the expected `CrossProbeDispatchResult` (`sent` with a capturing peer,
  `noServer` when Remote Control is off).

> **2026-07-19 correction.** Scenarios 2 (port) and 3 (net) were
> hand-authored with name-based canonical paths (`top.clk`,
> `top.u_cpu.data_bus`) that `buildElementPath` + `NetcruxNameResolver`
> never emit. The shipping forms are `top:port:clk` and
> `top.u_cpu:net:e_10_1` (the first schematic edge off the `data_bus`
> boundary port in the `u_cpu` scope). Caught by wiring all four
> scenarios into the live-originator sync test
> (`test/verification/cxp_originate_fixture_sync_test.dart`), which drives
> `CrossProbeOriginator.dispatchTo` against a capturing `LocalCxpServer`
> and golden-compares each dispatched envelope.

Name resolution is deterministic and does not require a live peer, so
`test/features/cxp_originate/services/cross_probe_originator_integration_test.dart`
drives `CrossProbeOriginator.dispatchTo()` against a real
`NetcruxCxpServer` + `LocalCxpClient` pair over a synthetic
`NetlistModel` and asserts scenario 1 (the `u_cpu` instance at the top
scope) plus the `noServer` / `unresolvable` / `peerGone` outcomes.

Also has a companion `cxp_originate_hierarchy.netlist.json` — a
Yosys-shaped structural mirror of the `.v` (two hierarchical modules,
`top` instantiating `u_cpu`; mirrored as a Dart const in
`integration_test/fixtures/cxp_originate_hierarchy_netlist.dart`),
consumed by the seeded
`integration_test/cxp_originate/cxp_originate_journey_test.dart` journey
via the Yosys-free design-seed helper. That journey raises scenario 1 to
a real launched app: it seeds the netlist into an active tab, connects a
raw peer to the live server, and dispatches through the per-tab
`crossProbeOriginatorProvider` — the exact seam the schematic
context-menu's "Cross-probe → &lt;peer&gt;" entry uses.

## Regenerating

```bash
dart run tool/generate_pro_verification_fixtures.dart --feature cxp_originate
```

See `../helpers/README.md` for the full regeneration reference.
