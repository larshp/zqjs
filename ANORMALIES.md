# Transpiler and open-abap anomalies

This log tracks behavior observed in the abaplint transpiler, `@abaplint/runtime`, or
open-abap that may differ from real ABAP semantics or affect zqjs implementation choices.
It is deliberately separate from JavaScript compatibility gaps in `PROFILE.md`.

## Recording policy

Add an entry when a toolchain behavior:

- differs from expected ABAP behavior or from a representative SAP system;
- exposes Node.js semantics through transpiled ABAP;
- rejects or miscompiles otherwise supported ABAP syntax;
- requires a non-obvious source workaround; or
- makes a transpiled test weaker or stronger than the equivalent real-ABAP test.

Each entry should state the pinned component versions, smallest available reproducer,
expected and observed results, impact, workaround, and real-ABAP verification status.
Keep uncertain findings marked `suspected` until a minimal reproduction and cross-host
comparison establish ownership.

Do not add ordinary zqjs engine bugs, parser gaps, or JavaScript conformance failures
unless a minimal reproduction identifies the transpiler/runtime/open-abap layer as the
suspected source. Keep those findings in focused ABAP Unit tests, `PLAN.md`, or
`PROFILE.md` instead.

## OA-001 — fixed character literal comparison in class parser

- Status: suspected; workaround active; minimal standalone reproduction pending.
- Components: abaplint CLI 2.120.4, transpiler/runtime 2.13.42, open-abap-core
  `f30a24120b6677e6cbf92210b59db9589c8be32f`.
- Originating test: ABAP Unit method `ltcl_qjs=>class_syntax` while recognizing the
  `constructor` method name.
- Expected: comparing a `string` containing `constructor` with the fixed character
  literal `'constructor'` should select the constructor branch.
- Observed: in the transpiled Node run, that branch was not selected. The method was
  installed as an ordinary prototype method and a default constructor was emitted.
- Workaround: compare against the string template literal `` `constructor` `` in
  `zcl_qjs_parser`; the focused class test and full repository gate then pass.
- Impact: fixed-character/string comparisons on parser control paths need focused ABAP
  Unit coverage; do not generalize the workaround without a minimal reproduction.
- Real ABAP: not yet compared. A representative SAP_BASIS 7.54+ run is required to
  determine whether this is transpiler-specific or an incorrect expectation about the
  source-level comparison.

## OA-002 — inline declaration in CATCH is block-scoped after transpilation

- Status: suspected; workaround active; minimal source-level reproduction retained by
  the originating class test.
- Components: abaplint CLI 2.120.4, transpiler/runtime 2.13.42, open-abap-core
  `f30a24120b6677e6cbf92210b59db9589c8be32f`.
- Originating test or reproducer: ABAP Unit method `ltcl_qjs=>class_syntax`, while
  `zcl_qjs_native_function=>zif_qjs_callable~call` handled
  `Object.setPrototypeOf(Derived, Base)`. A `DATA lo_set_proto_base ...` declaration
  inside `CATCH cx_sy_move_cast_error` was read after the surrounding `TRY...ENDTRY`.
- Expected: ABAP method-local declarations remain available after the control-flow
  block containing their declaration.
- Observed: the transpiled Node run raised JavaScript `ReferenceError:
  lo_set_proto_base is not defined` at the later read.
- Workaround: declare `lo_set_proto_base` before the `TRY` and clear it explicitly.
- Impact: inline or local declarations first introduced inside nested ABAP control-flow
  blocks must not be consumed later without a focused transpiled test; prefer an
  upfront declaration when the value escapes the block.
- Real ABAP: not yet compared on the target SAP_BASIS 7.54+ system.
- Upstream issue: not filed.

## Entry template

```text
## OA-NNN — short title

- Status: suspected | confirmed | cleared | upstream-reported
- Components: exact pinned versions/commits
- Originating test or reproducer:
- Expected:
- Observed:
- Workaround:
- Impact:
- Real ABAP:
- Upstream issue: link or `not filed`
```
