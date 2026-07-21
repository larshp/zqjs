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
| `parseInt`, `parseFloat`, `isFinite`, and `isNaN` | verified by ABAP Unit and selected test262 cases | unverified |
| `encodeURI`, `encodeURIComponent`, `decodeURI`, `decodeURIComponent`, and `URIError` | URI transforms verified by ABAP Unit and selected test262 cases; `URIError` verified by ABAP Unit | unverified |
| `Function`, dynamic function construction, and `Function.prototype.call`, `apply`, and `bind` | verified by ABAP Unit and selected test262 cases; broader prototype and metadata coverage remains partial | unverified |
| Runtime-stable well-known Symbols and symbol-keyed ordinary/callable properties and Object reflection | verified by ABAP Unit and selected test262 cases; well-known Symbol property attributes remain partial | unverified |
| `Array.prototype`, generic `push`/`pop`/`shift`/`unshift`/`reverse`/`slice`/`forEach`/`map`/`filter`/`some`/`every`/`find`/`findIndex`/`reduce`/`reduceRight`/`fill`/`copyWithin`/`join`/`indexOf`/`lastIndexOf`/`includes`/`at`, shared `ToLength`, uint32 index boundaries, sparse array literals, and truncating array `length` assignment | verified by ABAP Unit and selected test262 cases; broader Array prototype remains partial | unverified |
| Number static predicates, safe-integer bounds, and core constants | verified by ABAP Unit and selected test262 cases | unverified |
| Math numeric constants and `abs`, `acos`, `acosh`, `asin`, `asinh`, `atan`, `atan2`, `atanh`, `cbrt`, `ceil`, `clz32`, `cos`, `cosh`, `exp`, `expm1`, `f16round`, `floor`, `fround`, `hypot`, `imul`, `log`, `log1p`, `log10`, `log2`, `max`, `min`, `pow`, `random`, `round`, `sign`, `sin`, `sinh`, `sqrt`, `tan`, `tanh`, and `trunc` | verified by ABAP Unit and selected test262 cases (`f16round` upstream vector deferred with `Float16Array`) | unverified |
| Object `assign`, `values`, `entries`, `hasOwn`, and SameValue `is`; real `Object.prototype` inheritance and `Object.prototype.toString` tags | verified by ABAP Unit and selected test262 cases | unverified |

Unverified capabilities are release blockers only for the feature groups that require
them; they do not block development of the arithmetic vertical slice.

Two hundred eighty-four pinned test262 cases are selected for the transpiled ABAP engine across
Symbol, Function, Array and Object methods, Number statics, Math, numeric and URI global functions, JSON, addition,
bitwise-and, compound assignment, left-shift, logical-and, and postfix increment. The runner installs its base assertion
harness, parses front matter, loads
requested harness includes, executes positive and parse/runtime-negative tests, filters
unsupported features/flags, and reports pass, fail, unsupported, and infrastructure
skip separately. The current set reports two hundred eighty-two passes, one explicit `onlyStrict`
unsupported case, and one `f16round` vector deferred because it requires `Float16Array`.

The currently enabled language surface includes the implemented statement, function-declaration,
anonymous/named function-expression, IIFE,
closure, exception, lexical-binding, ordinary-object, array, prototype, constructor,
bitwise, and embedding slices. This is not yet a claim of general ECMAScript or test262
conformance. Regular expressions, classes, generators, promises, modules, exact `dtoa`,
and the broader built-in library remain outside the enabled profile.
