# Tracing Fixtures — Cone-of-Influence (§4.1) + X-trace (§4.2)

Fixtures for the Pro connectivity-tracing services
(`ProConeOfInfluenceService`, `ProXTraceService`), consumed by the §4.1
and §4.2 verification entries in `VERIFICATION_GUIDE.md` and their
integration tests.

> Netlist-diff, the third tracing surface, has its own top-level
> `../diff/` folder (baseline/comparison pair + `expected_diff.json`) and
> is **not** duplicated here.

## Inventory

| Fixture | Feature | What it represents | Expected result |
|---|---|---|---|
| `coi_fanin_alu.v` | Cone of Influence (§4.1) | Registered ALU; a fanin cone from the output flop | `TraceOverlay` (mode `fanin`) highlighting `{y_reg, muxed, sum}` and boundary inputs `{a, b, sel}` |
| `xtrace_backcone.v` | X-trace (§4.2) | 3-stage buffer chain from a primary input to a primary output | Topological back-walk `q_out → buf2 → buf1`; `reachedBoundary` without a VCD, `foundOrigin` at `buf1` with an X-seeded VCD |

Each `.v` file has a companion:

- `coi_fanin_alu.expected.overlay.json` — the canonical `TraceOverlay`
  fields (mode + highlighted id sets). The schematic projection may add
  synthesized helper cells, so the integration test asserts the
  highlighted sets are a **superset** of the anchors listed here.
- `xtrace_backcone.expected.trace.json` — the canonical X-trace chain.
  Full X-trace requires a loaded VCD (`XTraceRequest.simulationTime`);
  without one the service walks the topology. The companion documents
  both the topological termination and the VCD-seeded `foundOrigin`
  result the integration test asserts once the design-seed helper lands
  (see `../../../integration_test/PENDING.md` §4.2).

Both `.v` files ship a `<name>.netlist.json` Yosys-shaped mirror (Dart
const in `integration_test/fixtures/`). `test/fixtures/tracing_netlist_fixture_sync_test.dart`
builds a real `SchematicGraph` from the mirror (open-core
`SchematicGraphBuilder` — the tracing services are pure connectivity
walks and ignore layout geometry) and asserts the live
`ProConeOfInfluenceService` / `ProXTraceService` output against these
companions, closing the drift gap where the JSONs were only referenced in
doc-comments / inline journey literals.

> **Id convention (verified 2026-07-19).** The anchors use readable
> `top.`-qualified paths; the live graph uses **bare** Yosys names
> (`SchematicCell.id == cell.name`, `port:<name>` for boundary ports).
> The sync test normalizes the anchors to the bare form and asserts the
> live output is a **superset** — the COI fanin cone legitimately also
> reaches `port:clk` (the output flop's clock), which the anchor set
> omits. The X-trace companion's VCD `foundOrigin`/`buf1` scenario is not
> computed by v1 (no loaded VCD); the sync test asserts the topological
> `reachedBoundary` walk and that every `expectedChain` signal is a net
> the live walk visits, in order.

## Regenerating

```bash
dart run tool/generate_pro_verification_fixtures.dart --feature tracing
```

See `../helpers/README.md` for the full regeneration reference.
