# zqjs

zqjs is a JavaScript engine implemented in ABAP and derived architecturally from
[QuickJS](https://github.com/bellard/quickjs).

The current implementation contains a growing embedded-language profile:

- tagged primitive values with explicit NaN, positive/negative infinity, and negative zero;
- UTF-16 string abstraction, bounded atom table, all completion kinds, runtime/context
  ownership, and enforced instruction/source/parser/bytecode/stack limits;
- explicit numeric coercion plus interim decimal/hex/octal/binary literal parsing;
- locale-independent shortest-round-trip formatting for finite Numbers with
  ECMAScript decimal/exponent shaping;
- lexer and direct bytecode emitter for primitive literals, arithmetic, comparison,
  equality, logical and bitwise operators, variables, blocks, `if`/`else`, `while`,
  C-style `for`, `break`, and `continue`;
- hoisted named functions, parameters, calls, returns, recursion, and mutable lexical
  closures;
- ordinary and async arrow functions with concise/block bodies, default/rest parameters,
  non-constructibility, and lexical `this`/`arguments` capture;
- 105 verified QuickJS-aligned opcode IDs, constant/local slots, patched jumps, a
  disassembler, and an iterative VM with explicit frames;
- shape-backed ordinary objects, data and accessor property descriptors,
  prototypes, constructors, `this`, `instanceof`, object/array literals,
  computed properties, and `delete`;
- string concatenation/comparison, thrown-value propagation, and nested
  `try`/`catch` across function frames;
- block-scoped `let`/`const`, TDZ and const-assignment errors, plus `finally` handling
  for normal and abrupt completions;
- abstract equality, logical short-circuiting, remainder, unary logical negation,
  comments, and line-terminator-sensitive `return`/`throw` handling;
- ordinary arrays with indexed reads/writes, sparse growth, and `length`;
- String primitive and wrapper indexing plus foundational `String.prototype` search,
  extraction, concatenation, repeat, case-conversion, and trim methods;
- initial intrinsics for `Object`, `Array`, `Number`, `String`, `Boolean`, `Math`,
  `JSON`, `isNaN`, `NaN`, and `Infinity`, including `Object` reflection methods,
  strict JSON parsing/stringification, the core `Error` constructors including
  `EvalError` and standard `options.cause` properties, and `Array.isArray`;
- persistent contexts, direct calls, host-callable and host-constructable interfaces,
  catchable host-error translation, runtime disposal, resource budgets, and
  cooperative cancellation, including runtime-owned disposable host resources and a
  Promise rejection-tracking callback for embedding hosts;
- a `globalThis` object whose data properties share storage with script and host global
  bindings, with top-level script `this` and lexical-global separation;
- public `zcl_qjs=>eval( )` facade and explicit runtime/context embedding API;
- an initial bounded Promise job queue with `Promise` construction, `resolve`, `reject`,
  `then`, generic `catch`/`finally`, ordered checkpoint draining, promise adoption, and
  deferred foreign-thenable assimilation, plus iterable `Promise.all`, `allSettled`,
  `any`, and `race`, constructor-sensitive capability creation, custom species chaining,
  native Promise subclass construction, host rejection tracking, and `AggregateError`
  rejection for `Promise.any`;
- initial async function declarations, expressions, class methods, and object methods
  with immediate body execution, Promise-backed completion, `await`
  suspension/resumption, rejection injection, and ordered continuation jobs, plus
  `for await..of` over asynchronous and synchronous iterables with awaited closure;
- async generator declarations, expressions, and class/object methods with lazy
  execution, FIFO `.next()`/`.throw()`/`.return()` requests, awaited yields and returns,
  rejection injection, and the asynchronous-iterator prototype chain;
- ABAP Unit tests executed through the abaplint transpiler on Node.

For example, this source is tokenized, compiled, and interpreted rather than delegated to
the host JavaScript engine:

```abap
DATA(result) = zcl_qjs=>eval( `1 + 2 * 3` ).
DATA(number) = zcl_qjs_value=>as_finite_number( result ).
```

## Development

Prerequisites are Node.js 22.18 or newer and Git. Dependencies and upstream source pins
are exact and recorded in `package-lock.json` and `upstream-lock.json`.

```text
npm ci
npm test
```

`npm test` verifies the pinned QuickJS opcode metadata and normalized compiler-oracle
fixture, validates the machine-readable compatibility profile against the lockfiles and
published conformance denominator, runs abaplint, transpiles the ABAP, executes the ABAP Unit suite with
`node --expose-gc`, self-tests the test262 metadata parser, and then runs 962 pinned
test262 language and built-in cases through the transpiled zqjs engine. Positive and negative
tests, feature exclusions, harness includes, persistent-context `$DONE` async tests, and
pass/fail/unsupported/infrastructure skip outcomes are handled explicitly. Set
`TEST262_FILTER` to a path substring for a focused development run.

See [compatibility-profile.json](compatibility-profile.json) for the enforced profile,
[PROFILE.md](PROFILE.md) for its human-readable detail, and [PLAN.md](PLAN.md) for the
remaining implementation phases.
