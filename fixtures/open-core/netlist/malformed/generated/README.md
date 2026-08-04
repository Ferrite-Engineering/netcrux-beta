# Malformed Yosys-JSON corpus (WS5)

Hand-authored adversarial inputs, one file per invariant in the NetCrux
Robustness & Performance Plan §5.1 (`edacrux/docs/archive/2026/plans/netcrux/robustness-and-performance-plan.md`).
Consumed by `test/services/yosys/yosys_json_fuzz_test.dart`, which asserts
every case yields a typed `YosysJsonParseException` (never a raw
`FormatException` / `TypeError`, never a hang, never a partial netlist).

| File | §5.1 invariant |
|------|----------------|
| `non_object_root_array.json` | #1 non-object root (`[]`) |
| `non_object_root_scalar.json` | #1 non-object root (`42`) |
| `missing_modules.json` | #2 missing `modules` key |
| `empty_object.json` | #4 empty `{}` (failure, not an empty netlist) |
| `nested_type_error.json` | #3 a cell's `connections` is a string |
| `truncated.json` | #5 cut mid-token |
| `unterminated_module_name.json` | #5 unterminated string |

The fuzz test adds programmatic cases on top of this corpus: seeded random
truncation of a valid netlist, random type-mutation, and a deeply-nested
array (#6 bounded recursion).

**Deferred to PR 2 / WS8:** the `.expected_error.json` ARB-key companions
and the static guardrails that police this directory's layout. The current
parser surfaces literal English messages rather than ARB keys, so the
companion + i18n migration rides with WS8's static-guardrail work, not WS5.
