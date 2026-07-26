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

## OA-003 - failed down-cast leaves the target reference bound

- Status: suspected; defensive workaround active; real-ABAP comparison pending.
- Components: abaplint CLI 2.120.4, transpiler/runtime 2.13.42, open-abap-core
  `f30a24120b6677e6cbf92210b59db9589c8be32f`.
- Originating path: `zcl_qjs_vm=>execute`, `push_const`, while probing whether an
  object-valued constant is a `zcl_qjs_template_site`.
- Expected by the original implementation: after `lo_template_site ?= value` raises
  `cx_sy_move_cast_error`, `lo_template_site` is unbound.
- Observed: after one successful template-site cast, a later failed cast left the
  previous object reference bound. The handler consequently materialized the stale
  template site for unrelated object constants. In the `test:zmjs-abaplint` workload,
  exposing the path through an early constant fast dispatcher produced a 208,888.5 ms
  run instead of the roughly 45,000-60,000 ms range seen around it.
- Workaround: `CLEAR lo_template_site` immediately before every caught down-cast whose
  target is subsequently tested with `IS BOUND`.
- Impact: caught `?=` probes can silently reuse stale objects, causing incorrect values
  and extreme allocation/runtime amplification. Audit similar cast-and-catch patterns.
- Real ABAP: not yet compared. This may be standard assignment-on-failure behavior
  rather than a transpiler defect, so it remains `suspected`.
- Upstream issue: not filed.

## OA-004 - end-to-end benchmark timing is highly unstable on the current host

- Status: suspected host/runtime effect; measurement workaround active.
- Components: Node.js host running transpiler/runtime 2.13.42 and the pinned zqjs
  dependencies above; observed on 2026-07-26.
- Originating test: `npm run test:zmjs-abaplint` in consecutive, unchanged or staged
  source configurations.
- Expected: adjacent runs should be stable enough that a single sample indicates the
  direction of a substantial optimization.
- Observed: valid runs varied from 33,238.5 ms to 81,628.9 ms, while the Node reference
  in the same harness varied from about 24 ms to 209 ms. One three-sample shape-stage
  sequence was 58,554.6, 60,877.6, and 45,595.3 ms. This variance can reverse the
  apparent result of small optimizations.
- Workaround: compare staged medians from at least three consecutive samples, retain
  only directional improvements, and run correctness gates separately. Treat the
  208,888.5 ms stale-reference run from OA-003 as a code-path failure, not host noise.
- Impact: absolute timings from different sessions are not directly comparable. Keep
  raw samples with every reported percentage and prefer same-session controls.
- Real ABAP: not applicable; SAP-side performance still requires separate measurement.
- Upstream issue: not filed.

## OA-005 - transpiled initialization module was transiently unavailable

- Status: suspected process/filesystem race; one occurrence; not reproduced by
  individual reruns.
- Components: Node.js v22.19.0, npm test scripts, transpiler/runtime 2.13.42.
- Originating test: three `npm run test:zmjs-abaplint` commands chained sequentially
  after a successful `npm run unit` transpilation.
- Expected: every benchmark invocation imports the existing `output/init.mjs` emitted
  by the completed transpile step.
- Observed: the first benchmark passed at 41,557.3 ms. The second failed with Node
  `ERR_MODULE_NOT_FOUND` for `output/init.mjs`. An immediate read-only check found the
  file present, and two subsequent individual benchmark invocations passed.
- Workaround: do not treat the failed sample as performance data; run benchmark samples
  as individual commands and confirm `output/init.mjs` after any import failure.
- Impact: chained benchmark batches can lose a sample and should stop on the first
  harness error. No source correctness failure was observed.
- Real ABAP: not applicable.
- Upstream issue: not filed; a deterministic reproducer is required first.

## Performance experiment anomalies (2026-07-26)

These are not accepted optimizations. They are retained here because their measured
behavior was counterintuitive and repeating them would waste another benchmark cycle.

| Experiment | Observed result | Disposition |
| --- | --- | --- |
| Inline strict equality inside the VM dispatcher | 55,850.3 ms median versus 46,933.9 ms for the shared tagged-value helper | Reverted |
| Direct numeric equality without `normalized` copies | 70,528.3 ms first combined sample | Reverted |
| One-copy shape transition plus cached insertion order | 58,554.6 ms median (58,554.6, 60,877.6, 45,595.3) versus a nearby 53,120.2 ms control | Reverted |
| Early `push_const`/primitive constant dispatch | 81,628.9 ms after fixing OA-003; the first stale-reference run was 208,888.5 ms | Reverted; retained only OA-003 reset |
| Stack-window argument copying | Approximately 60,700 ms median | Reverted |
| Lazy local-cell boxing | 48,700-76,100 ms across samples | Reverted |
| Reference-swapped parser locals table | 45,393.0 ms median (43,678.5, 47,379.3, 45,393.0) versus 27,384.8 ms for lazy parent bindings alone | Reverted; per-lookup reference indirection outweighed two avoided copies |
| Removing redundant simple-parameter bytecode prologues | 46,281.0 ms median (43,353.9, 47,654.9, 46,281.0) versus 26,033.0 ms with the original prologue | Reverted; fewer VM instructions produced a substantially worse transpiled execution/JIT shape |
| VM integer property-key shortcut | Approximately 10% slower | Reverted |
| Contiguous local-metadata iteration | 70,300 ms | Reverted |
| Lazy function prototype/property creation | Semantic test failures | Reverted |

The recurring pattern is that expanding the transpiled VM dispatcher or replacing
runtime table operations with more ABAP source branches can cost more than the avoided
helper calls. QuickJS-inspired changes should therefore remain narrow and be validated
against the full transpiled workload, not inferred from native-engine structure alone.

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
