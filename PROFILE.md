# zqjs compatibility profile

This file records the implementation target. A feature not listed as enabled is not
silently treated as conforming.

The versioned, machine-readable contract is `compatibility-profile.json`. The
`verify:profile` build gate checks its upstream/toolchain pins, required feature
declarations, host requirements, and published test262 denominator against repository
source files.

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
- Direct `eval`, modules, Proxy, typed arrays,
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
| Shape transitions, data/accessor descriptors, Object reflection, and a cell-backed `globalThis`/top-level script global object with lexical-global separation | verified by ABAP Unit and selected test262 cases | unverified |
| Host callbacks, constructors, error translation, disposal, and cancellation | verified by ABAP Unit | unverified |
| JSON parse/stringify core algorithms | verified by ABAP Unit | unverified |
| Error constructors including `EvalError`, Error/native-error prototype identity, standard `options.cause` properties including `AggregateError`, and catchable language/host error objects | verified by ABAP Unit and selected test262 cases | unverified |
| `parseInt`, `parseFloat`, `isFinite`, and `isNaN` | verified by ABAP Unit and selected test262 cases | unverified |
| `encodeURI`, `encodeURIComponent`, `decodeURI`, `decodeURIComponent`, and `URIError` | URI transforms verified by ABAP Unit and selected test262 cases; `URIError` verified by ABAP Unit | unverified |
| `Function`, dynamic function construction, and `Function.prototype.call`, `apply`, and `bind` | verified by ABAP Unit and selected test262 cases; broader prototype and metadata coverage remains partial | unverified |
| Runtime-stable well-known Symbols and symbol-keyed ordinary/callable properties and Object reflection | verified by ABAP Unit and selected test262 cases; well-known Symbol property attributes remain partial | unverified |
| Constructor-sensitive `Array.of`; `Array.prototype`; generic `push`/`pop`/`shift`/`unshift`/`reverse`/`toReversed`/`toSorted`/`toSpliced`/`with`/`slice`/`forEach`/`map`/`filter`/`some`/`every`/`find`/`findIndex`/`findLast`/`findLastIndex`/`reduce`/`reduceRight`/`fill`/`copyWithin`/`concat`/`splice`/`sort`/`flat`/`flatMap`/`toString`/`join`/`indexOf`/`lastIndexOf`/`includes`/`at`; shared `ToLength`; uint32 index boundaries; sparse array literals; and truncating array `length` assignment | verified by ABAP Unit and selected test262 cases; broader Array prototype remains partial | unverified |
| String primitive/wrapper prototype identity and indexed access; `toString`, `valueOf`, `charAt`, `charCodeAt`, `at`, `indexOf`, `lastIndexOf`, `includes`, `startsWith`, `endsWith`, `slice`, `substring`, `concat`, `repeat`, case conversion, and trim methods | verified by ABAP Unit and selected test262 cases; locale methods, normalization, and exact lone-surrogate preservation remain outside the verified profile | unverified |
| Number static predicates, safe-integer bounds, and core constants | verified by ABAP Unit and selected test262 cases | unverified |
| Math numeric constants and `abs`, `acos`, `acosh`, `asin`, `asinh`, `atan`, `atan2`, `atanh`, `cbrt`, `ceil`, `clz32`, `cos`, `cosh`, `exp`, `expm1`, `f16round`, `floor`, `fround`, `hypot`, `imul`, `log`, `log1p`, `log10`, `log2`, `max`, `min`, `pow`, `random`, `round`, `sign`, `sin`, `sinh`, `sqrt`, `tan`, `tanh`, and `trunc` | verified by ABAP Unit and selected test262 cases (`f16round` upstream vector deferred with `Float16Array`) | unverified |
| Object `assign`, `values`, `entries`, `hasOwn`, and SameValue `is`; real `Object.prototype` inheritance with `toString`, `valueOf`, `hasOwnProperty`, `propertyIsEnumerable`, `isPrototypeOf`, and built-in tags | verified by ABAP Unit and selected test262 cases | unverified |
| All 13 `Reflect` methods, method metadata, receiver-aware access, symbol keys, prototype operations, and extensibility; Object `isExtensible` and `preventExtensions` | verified by ABAP Unit and selected test262 cases | unverified |
| `Map` and `Set` ordered SameValueZero storage, constructors over arbitrary iterables, core prototype methods, live iterators, `forEach`, size accessors, well-known iterator aliases, and built-in tags | verified by ABAP Unit and selected test262 cases | unverified |
| Binary `in`; `for..in` over ordinary objects, prototype chains, strings, `null`, and `undefined`; ordered keys, non-enumerable shadow suppression, deletion checks, and fresh lexical cells | verified by ABAP Unit and selected test262 cases | unverified |
| General synchronous iterator protocol; Array/String/Map/Set iterators; `for..of`; fresh lexical cells; iterator closing for explicit `break`, `return`, and `throw` plus indirect runtime exceptions; astral string code-point iteration | verified by ABAP Unit and selected test262 cases, including nested loops, catch-body completions, generator closing, and throwing destructuring defaults | unverified |
| Computed string/Symbol object-literal keys and identifier shorthand; default and rest parameters; default/rest-aware function `length`; array/call/constructor/object spread; object rest; nested array/object destructuring with defaults, elisions, computed keys, rest, and member targets in declarations, assignments, parameters, loop heads, and catch bindings; untagged templates with cooked substitutions; tagged templates with frozen cooked/raw arrays, per-site caching, ordered substitutions, and member receiver semantics | verified by ABAP Unit and selected test262 cases | unverified |
| Ordinary and async arrow functions with single/parenthesized parameters, defaults/rest/destructuring, concise and block bodies, nested arrows, object-literal returns, non-constructibility, lexical `this`/`arguments`, Promise-backed async completion, and `await` | verified by focused ABAP Unit and 27 selected arrow/async-arrow integration test262 cases; lexical `super`/`new.target`, broader name inference, and wider early-error coverage remain partial | unverified |
| Class declarations and anonymous/named class expressions with default/explicit constructors; rejection of class invocation without `new`; non-constructible public/private instance/static methods, including generators and async methods; public/private getter/setter accessors; computed public string/Symbol names; writable/non-enumerable/configurable public method descriptors; prototype and static inheritance including native Promise/Error bases; `instanceof`; `super(...)` with multi-level `newTarget` propagation; receiver-aware instance/static `super` operations; ordered public/private static/instance fields; hidden brand-checked private storage; private-name early errors; `#name in object`; base/derived initialization ordering; default-derived argument forwarding; and ordered static initialization blocks | verified by ABAP Unit and selected test262 cases; direct-eval-specific private-name behavior remains governed by its separately unsupported feature group | unverified |
| Generator declarations/expressions and class/object generator methods; lazy explicit-frame suspension; `yield` and delegated `yield*`; sent values and final returns; function-specific iterator prototypes; `.next()`, `.return()`, and `.throw()` including intrinsic descriptors, receiver validation, non-constructibility, re-entrant execution rejection, method `this`, iterator result objects, nested `try`/`catch`/`finally`, yielding cleanup, and delegated iterator completion forwarding | verified by focused ABAP Unit and 60 selected GeneratorPrototype/language test262 cases plus delegated-yield cases; broader syntax and conformance edges remain partial | unverified |
| Initial `Promise` constructor with its intrinsic `Symbol.species` accessor, constructor-sensitive `resolve`/`reject` and iterable `all`/`allSettled`/`any`/`race`, native subclass construction and inherited statics, `then` with custom and inherited species capabilities, generic `catch`/`finally`, ordered aggregate results and errors, `AggregateError` including `options.cause` and its global descriptor, first-settlement behavior, promise adoption, deferred foreign-thenable assimilation, a `HostPromiseRejectionTracker`-style embedding callback, and a bounded FIFO job queue drained at embedding checkpoints; async function declarations/expressions, async arrows, and public/private instance/static/computed class and object methods with immediate execution, Promise-backed return/throw completion, `await` fulfillment/rejection resumption, sequential awaits, and return-value assimilation | verified by focused ABAP Unit, 78 selected Promise/AggregateError cases, and selected async-function/async-arrow test262 cases including persistent-context `$DONE` completion; `for await..of`, async generators, and broader behavioral coverage remain outside this partial slice | unverified |

Unverified capabilities are release blockers only for the feature groups that require
them; they do not block development of the arithmetic vertical slice.

Nine hundred forty-one pinned test262 cases are selected for the transpiled ABAP engine across
Symbol, Function, Array, String, Object, Reflect, Map, Set, Promise, AggregateError, and Error methods, Number statics, Math, numeric and URI global functions, JSON, addition,
bitwise-and, compound assignment, conditional and `in` expressions, array/call/object spread, rest parameters, declaration destructuring, ordinary/async arrows, untagged and tagged template literals, `for..in`, `for..of`, iterators, generators, initial async functions, left-shift, logical-and, and postfix increment. The runner installs its base assertion
harness, parses front matter, loads
requested harness includes, executes positive, asynchronous `$DONE`, and parse/runtime-negative tests, filters
unsupported features/flags, and reports pass, fail, unsupported, and infrastructure
skip separately. The current set reports nine hundred thirty-eight passes, one explicit `onlyStrict`
unsupported case, one `f16round` vector deferred because it requires `Float16Array`, and one
String-iterator vector deferred because exact standalone lone-surrogate preservation is outside
the current host profile.

The currently enabled language surface includes the implemented statement, function-declaration,
anonymous/named function-expression, IIFE,
closure, exception, conditional-expression, lexical-binding, ordinary-object, array, prototype, constructor,
`for..in`, `for..of`, synchronous-iterator, binary `in`, bitwise, and embedding slices. Constructors accept both parenthesized
argument lists and the standard no-argument `new Constructor` form. This is not yet a claim of general ECMAScript or test262
conformance. Regular expressions, residual generator, Promise, and async-function edges,
modules, exact `dtoa`,
and the broader built-in library remain outside the enabled profile.
