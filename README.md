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
- 97 verified QuickJS-aligned opcode IDs, constant/local slots, patched jumps, a
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
  strict JSON parsing/stringification, the core `Error` constructors, and
  `Array.isArray`;
- persistent contexts, direct calls, host-callable and host-constructable interfaces,
  catchable host-error translation, runtime disposal, resource budgets, and
  cooperative cancellation, including runtime-owned disposable host resources;
- public `zcl_qjs=>eval( )` facade and explicit runtime/context embedding API;
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
fixture, runs abaplint, transpiles the ABAP, executes the ABAP Unit suite with
`node --expose-gc`, self-tests the test262 metadata parser, and then runs 809 pinned
  test262 language and built-in cases through the transpiled zqjs engine. Positive and negative
tests, feature exclusions, harness includes, and pass/fail/unsupported/infrastructure
skip outcomes are handled explicitly.

See [PROFILE.md](PROFILE.md) for the active compatibility profile and [PLAN.md](PLAN.md)
for the remaining implementation phases.
