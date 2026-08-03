# FSM Detection Fixtures (§5.3.3)

Fixtures consumed by the FSM detection integration tests
(`test/features/fsm/fsm_integration_test.dart`) and the §5.3.3
verification entry in `VERIFICATION_GUIDE.md`.

## Inventory

| Fixture | What it represents | Expected detection |
|---|---|---|
| `simple_binary_fsm.v` | 4-state binary-encoded FSM | 1 detected (binary, 4 states) |
| `one_hot_fsm.v` | 4-state one-hot encoded FSM | 1 detected (one-hot, 4 states) |
| `gray_fsm.v` | 3-state Gray-encoded FSM | 1 detected (gray, 3 states) |
| `johnson_fsm.v` | 8-state Johnson counter | 1 detected (**unknown** encoding — see file header) |
| `multiple_fsms.v` | Two independent FSMs in one module | 2 detected (both binary, 3 states each) |
| `unreachable_state_fsm.v` | 4-state FSM with one dead-code arm | 1 detected (v1 marks all reachable; v2 reachability TBD) |
| `candidate_register.v` | 16-bit register, exceeds the v1 8-bit width cap | 0 detected, 1 candidate (force-detection target) |

Each `.v` file has a companion `.expected.json` capturing the canonical
detection result the integration test asserts against. The integration
test builds a synthetic `NetlistModel` equivalent in-Dart rather than
shelling out to Yosys (running the Yosys subprocess in tests is out of
scope).

**`stateValues` formatting note (corrected 2026-07-19).** Every
`.expected.json`'s `stateValues` array was zero-padded to 2 hex digits
(e.g. `"0x00"`), but `ProFsmDetectionService._buildFsm` formats with
`hexWidth = ((width + 3) ~/ 4).clamp(1, 16)` — 1 hex digit for every
fixture here (2-bit or 4-bit state registers). This field was never
asserted by `fsm_integration_test.dart` (it only checks
`stateRegisterName` / `encoding` / `stateCount` / `resetStateId`), so
the drift went unnoticed until `test/fixtures/fsm_netlist_fixture_sync_test.dart`
live-classified `simple_binary_fsm.netlist.json` (below) and diffed the
result against the checked-in JSON. All six `stateValues` arrays are
now single-hex-digit (`"0x0".."0xf"`), with an inline `_stateValuesNote`
in each file.

## Seeded-journey netlist fixture

`simple_binary_fsm.netlist.json` is a hand-authored Yosys-shaped
structural mirror of `simple_binary_fsm.v`, used by the seeded FSM
integration journey (`integration_test/fsm/fsm_detection_journey_test.dart`,
parsed via `YosysJsonParser`, injected into the active tab Yosys-free).
Its Dart-const mirror lives at
`integration_test/fixtures/simple_binary_fsm_netlist.dart`; both are
pinned to each other and to a live re-classification against
`simple_binary_fsm.expected.json` by
`test/fixtures/fsm_netlist_fixture_sync_test.dart`.

Unlike the `cdc/`, `reset_domains/`, `tracing/`, and `cxp_originate/`
fixture folders, this `.netlist.json` is **not** emitted by
`tool/generate_pro_verification_fixtures.dart` — that generator's
`<name>.expected.<suffix>.json` filename convention doesn't fit this
folder's pre-existing `<name>.expected.json` files without a breaking
rename (see the generator's own header comment, which explicitly
excludes `fsm/`). Regenerate by hand if the fixture's structural shape
changes; re-run the sync test to confirm the pinned values still match.

## Regenerating

The `.v` files are the source of truth for the structural shape each
fixture exercises. Their main role is documentation and future
end-to-end verification of the Yosys → NetCrux elaboration pipeline.
To regenerate against Yosys for manual verification:

```bash
yosys -p 'read_verilog <fixture>.v; proc; opt; write_json <fixture>.json'
```

then load `<fixture>.json` through NetCrux's elaboration pipeline.
Drop the `.expected.json` next to it if the canonical detection
result changes — the integration test diffs every assertion against
this file.
