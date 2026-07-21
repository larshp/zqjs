# zqjs compatibility profile

This file records the implementation target. A feature not listed as enabled is not
silently treated as conforming.

## Hosts

- Development runtime: Node.js 22.18 or newer through abaplint CLI 2.120.4 and
  transpiler/runtime 2.13.42.
- ABAP target: Unicode SAP_BASIS 7.54 or newer.
- Real-ABAP capability verification is required before a release is published.
- open-abap-core is pinned in `upstream-lock.json` and materialized under `.cache/`.

## Core profile

- Script goal: ECMAScript language semantics derived from QuickJS 2026-06-04.
- Bytecode is internal to zqjs; serialized QuickJS bytecode compatibility is excluded.
- BigInt, Intl/ECMA-402, SharedArrayBuffer/Atomics, tail calls, `with`, and Annex B are
  initially excluded.
- Direct `eval`, the dynamic `Function` constructor, modules, Proxy, typed arrays,
  async generators, RegExp `v`, and String normalization remain disabled until their
  implementation phase is complete and covered by the target contract.

## Capability status

| Capability | Transpiled Node | Real ABAP |
|---|---|---|
| Explicit special-Number representation | verified by ABAP Unit | unverified |
| Interim finite Number shortest-round-trip formatting | verified by ABAP Unit | unverified |
| UTF-16 code-unit access | basic BMP access verified by ABAP Unit | unverified |
| Explicit PCRE adapter | not implemented | unverified |
| Weak references and forced GC | probe pending | unverified |
| Unicode case mapping | probe pending | unverified |
| Shape transitions, data/accessor descriptors, and Object reflection | verified by ABAP Unit | unverified |
| Host callbacks, constructors, error translation, disposal, and cancellation | verified by ABAP Unit | unverified |
| JSON parse/stringify core algorithms | verified by ABAP Unit | unverified |
| Error constructors and catchable language/host error objects | verified by ABAP Unit | unverified |

Unverified capabilities are release blockers only for the feature groups that require
them; they do not block development of the arithmetic vertical slice.

Thirteen pinned test262 cases are selected for the transpiled ABAP engine across JSON,
addition, bitwise-and, compound assignment, left-shift, logical-and, and postfix
increment. The runner installs its base assertion harness, parses front matter, loads
requested harness includes, executes positive and parse/runtime-negative tests, filters
unsupported features/flags, and reports pass, fail, unsupported, and infrastructure
skip separately. The current set reports twelve passes and one explicit `onlyStrict`
unsupported case.

The currently enabled language surface includes the implemented statement, function,
closure, exception, lexical-binding, ordinary-object, array, prototype, constructor,
bitwise, and embedding slices. This is not yet a claim of general ECMAScript or test262
conformance. Regular expressions, classes, generators, promises, modules, exact `dtoa`,
and the broader built-in library remain outside the enabled profile.
