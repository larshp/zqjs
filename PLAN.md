# zqjs — Porting QuickJS to ABAP

A feasibility analysis and step-by-step implementation plan for `zqjs`: a pure-ABAP
JavaScript engine derived from [Fabrice Bellard's QuickJS](https://github.com/bellard/quickjs).

> Source reference: QuickJS version **2026-06-04**, "almost fully" ES2025.

---

## 1. Executive summary

**Verdict: feasible, but it is a large multi-phase effort, not a mechanical translation.**

QuickJS is a bytecode-compiling JavaScript engine written in dense, pointer-heavy C.
The C source does not map cleanly onto ABAP: there are no pointers, no `union`, no
`goto`, no manual memory management, and value representation relies on NaN-boxing /
tagged unions that have no ABAP analogue. A line-by-line transliteration is therefore
neither possible nor desirable.

The realistic approach is to **re-implement QuickJS's *architecture* in idiomatic OO
ABAP, using the C source as the authoritative specification** — same bytecode design,
same atom/shape model, same built-in semantics — while replacing C-specific machinery
(reference counting, pointer arithmetic, computed-goto dispatch) with ABAP-native
equivalents (managed references / GC, index-based buffers, `CASE` dispatch).

Correctness is achievable. The two hard truths to set expectations:

1. **Scope is large.** The core (`quickjs.c`) is ~61k lines of C. A *useful embedded
   scripting engine* (core language + common built-ins) is a matter of person-months;
   *broad ES2025 + test262 conformance* is a multi-person-year undertaking.
2. **Performance will be modest.** An interpreter written in ABAP, dispatching bytecode
   via method calls with boxed values, will be orders of magnitude slower than native
   QuickJS. This is fine for configuration logic, rules, templating, and light
   scripting — the likely use cases for JS-on-ABAP — but it is not a general-purpose
   high-throughput runtime.

The verification story is unusually strong: via abaplint's transpiler the ABAP runs as
JS on Node for fast CI, *and* runs unchanged on a real ABAP stack. (There is a pleasing
irony in a JS engine written in ABAP, transpiled to JS, and validated by running JS.)

---

## 2. What we are porting — component inventory

| C file | Size | Role | Port priority |
|---|---|---|---|
| `quickjs.c` | ~2.0 MB (~61k lines) | Core: lexer, parser→bytecode, VM, GC, atoms, shapes, **all** built-ins | Core (split into many ABAP classes) |
| `quickjs.h` | small | Public API + `JSValue`, tags, opcodes surface | Design input |
| `quickjs-opcode.h` | small | Bytecode opcode table (the VM ISA) | Port first — generate ABAP constants |
| `quickjs-atom.h` | small | Predefined atoms (interned strings) | Port first — generate ABAP table |
| `libregexp.c/.h` | ~113 KB | Own regex engine (compiler + backtracking VM) | **Not ported** — PCRE shim (§5) |
| `libunicode.c/.h` | ~64 KB | Case mapping, identifier classes, normalization | **Mostly not ported** — use ABAP/PCRE (§5) |
| `libunicode-table.h` | ~252 KB | Generated Unicode data tables | Mostly replaced; keep only a small ID_Start/Continue table (+ optional normalization data) |
| `dtoa.c/.h` | ~45 KB | Correct double↔string (`Number.toString`, parsing), radix 2–36; uses internal bignum for exact rounding | **Deferred** (Phase 8): interim stopgap first; faithful port later, pulls in a mini-bignum |
| `cutils.c/.h` | ~18 KB | dbuf, UTF-8, sort, bit helpers | Fold into ABAP utils |
| `quickjs-libc.c/.h` | ~125 KB | `std`/`os` host modules (files, timers, exec) | Reimplement selectively w/ ABAP APIs |
| `qjs.c`, `qjsc.c` | — | CLI REPL / AOT compiler | Optional (an ABAP report front-end) |
| `run-test262.c` | ~77 KB | test262 harness | Reimplement as ABAP test runner |
| `unicode_gen.c` | ~105 KB | Build-time table generator | Run once (in C or JS) to emit ABAP tables |

**Not present in current mainline:** `libbf.c` is gone. BigInt is implemented in-tree;
BigFloat/BigDecimal have been removed. This *reduces* scope versus older QuickJS.

> **Out of scope for zqjs: BigInt.** Arbitrary-precision integers are the one built-in
> that ABAP cannot back natively, and they are rarely needed for the target use cases.
> BigInt is therefore explicitly excluded — the `BigInt` global is absent, `123n`
> literals are a syntax error, and the `bigint` typeof/coercion paths are omitted.
> This can be revisited later (a `zcl_qjs_bigint` bignum class) if a concrete need
> appears. **Caveat:** cutting the *JS `BigInt` feature* does **not** remove the need
> for arbitrary-precision integers *inside* `dtoa` — but since the faithful `dtoa` port
> is itself **deferred** (interim stopgap first; see §7 Phase 5/8), that internal
> big-integer helper is deferred with it.

**Deployable ABAP scope** ≈ `quickjs.c` + `dtoa` + relevant `cutils`. `libregexp` and
most of `libunicode` are **replaced by ABAP-native facilities** (PCRE2 + `to_upper`/
`to_lower` + codepage classes — see §5), not ported. `quickjs-libc` is host glue,
largely replaced by ABAP-native equivalents. The only Unicode *data* still generated is
a small identifier-classification table (and, optionally, normalization data).

---

## 3. Target environment & constraints

- **Language target:** the ABAP subset supported by the **abaplint transpiler** /
  **open-abap**, so the engine runs both on Node (CI) and on a real ABAP stack.
  Configure the accepted syntax/rules in `abaplint.jsonc`. ABAP Cloud (RAP/Steampunk)
  compatibility is a worthwhile stretch goal (avoid non-released statements).
- **Object model:** OO ABAP — classes (`zcl_qjs_*`), interfaces (`zif_qjs_*`),
  `CX_*` exceptions. No global state beyond a runtime instance.
- **Toolchain / dev loop:** abaplint (lint) + transpiler (ABAP→JS) + open-abap runner;
  `CL_ABAP_UNIT_ASSERT` for tests; GitHub Actions for CI.
- **Naming:** proposed prefix `zcl_qjs_` / `zif_qjs_` / `zcx_qjs_` (adjust to taste).

---

## 4. The hard part — C↔ABAP impedance mismatches

These decide the whole design and must be settled in Phase 1.

| QuickJS (C) mechanism | Problem in ABAP | Chosen ABAP approach |
|---|---|---|
| `JSValue` = NaN-boxed / tagged union | No unions, no NaN boxing | A value **struct/class** `zcl_qjs_value`: an integer `tag` + typed payload fields (`i`/`f`/`ref`). Objects/strings held via `REF TO`. |
| Reference counting (`JS_DupValue`/`JS_FreeValue`) + cycle GC | ABAP is garbage-collected; manual refcounts are meaningless and pervasive | **Drop refcounting entirely**; rely on ABAP GC. Removes ~thousands of dup/free call sites. |
| Weak references (`WeakRef`, `WeakMap`, `WeakSet`, `FinalizationRegistry`) | ABAP GC exposes no collection hook to the port | **Use `CL_ABAP_WEAK_REFERENCE`** — a genuine weak-ref primitive (open-abap backs it with a JS `WeakRef` via `@KERNEL`, so it is truly weak on both Node and on-stack). `WeakRef`→direct wrapper; `WeakMap`/`WeakSet`→weak keys + lazy sweep; `FinalizationRegistry`→polling. See §5 + Risks. |
| Computed-goto / switch dispatch in `JS_CallInternal` | No computed goto; giant `switch` legal but must be structured | Single `CASE opcode` loop; opcode bodies as inlined blocks or helper methods. |
| `goto` (error unwinding, fast paths) | No `goto` in ABAP | Restructure with loops, early `RETURN`, and `TRY/CATCH` for the exception paths. |
| Pointer arithmetic (lexer, bytecode reader, buffers) | No pointers | Index-based access over ABAP `string`/`xstring`/internal tables; a `dbuf`-like `zcl_qjs_bytebuf`. |
| 32-bit int wraparound, `ToInt32`/`ToUint32`, `<<`/`>>>`/`&` | ABAP `i` is signed 4-byte; uint32 overflows it; bitops are on byte fields | Use `int8` (8-byte) for intermediate math; implement JS integer coercion + bit ops explicitly (via `int8` masking or `xstring` `BIT-*`). |
| IEEE-754 semantics: `1/0=Infinity`, `0/0=NaN`, no traps | ABAP arithmetic on `f` can raise `CX_SY_ARITHMETIC_*` / zero-divide | **Guard every arithmetic op**; produce JS NaN/±Infinity results instead of exceptions. Centralize in a numeric helper. |
| Strings = UTF-16 code units, 8/16-bit rope optimization | ABAP `string` abstracts code units; astral/surrogate handling is fiddly | Model strings as **UTF-16 code-unit sequences** (backed by `string`, with a code-unit access layer). BMP-first; correct surrogate pairs for `charCodeAt`/`codePointAt`/iteration. Skip the 8/16-bit storage optimization. |
| `libunicode` (case mapping, `\p{}` props, identifier classes, normalization) | Large code + 252 KB of generated tables | **Mostly not ported** — delegate to ABAP standard facilities: `to_upper`/`to_lower` + `cl_abap_char_utilities` for case; **PCRE2 `\p{…}`** (already adopted) for regex properties + case-insensitive match; `cl_abap_codepage`/`cl_abap_conv_*` for UTF-8↔UTF-16. Residual: a small generated **ID_Start/ID_Continue** table for the lexer, and normalization data if `normalize` is implemented (§5). |
| BigInt (arbitrary precision integers) | No native bignum in ABAP | **Out of scope** (see §2). If revived: a `zcl_qjs_bigint` bignum class. |
| Regex engine (`libregexp` bytecode backtracker) | ABAP has PCRE, but JS regex semantics differ | **Decided: shim to ABAP PCRE** (`CL_ABAP_REGEX`/`CL_ABAP_MATCHER`, `... PCRE ...`). `libregexp` is *not* ported. A translation layer maps JS pattern/flag syntax to PCRE and JS `RegExp.prototype.*` semantics onto ABAP matching; known JS↔PCRE divergences are documented, not chased. |
| Deep C recursion (`JS_CallInternal` per JS call; recursive-descent parser) | ABAP call stack depth is limited | VM loop is iterative; bound native recursion, surface a JS `RangeError` ("stack overflow") before ABAP aborts; consider explicit call-stack table. |
| Function pointers (built-in dispatch, class methods) | No function pointers | Dynamic dispatch: interface-typed handler objects, or `CALL METHOD (name)` keyed by atom/opcode. |

---

## 5. Strategy decision

**Re-implement, don't transliterate.** Treat the C as an executable specification:

- Reuse QuickJS's **opcode set** (`quickjs-opcode.h`) verbatim so the VM is a faithful
  port and bytecode-level test vectors from QuickJS can validate it.
- Reuse the **atom table**, **shape** model, and **built-in algorithms** (which
  themselves track the ECMAScript spec), reading `quickjs.c` function-by-function.
- Replace machinery, not meaning: GC, dispatch, buffers, value boxing become ABAP-native.

**Settled sub-decision — memory management.** zqjs **drops QuickJS's reference
counting and cycle collector entirely** and leans on the ABAP kernel's garbage
collector. Every `JS_DupValue`/`JS_FreeValue` call site in the C source is simply
*not* ported; `JSValue` becomes a plain ABAP value/`REF TO` that the GC reclaims when
unreferenced. Consequences the design must own: (a) no deterministic finalization
order — anything QuickJS did in a free hook (e.g. closing a resource) moves to explicit
`close()`/`dispose` semantics; (b) weak-collection features are built on
`CL_ABAP_WEAK_REFERENCE` rather than on internal collector hooks (next decision).
Net effect: a large, pervasive simplification of the port.

**Settled sub-decision — weak references (`CL_ABAP_WEAK_REFERENCE`).** ABAP *does*
provide a real weak-reference primitive, and open-abap implements it with a JS
`WeakRef` via `@KERNEL` — so `get( )` returns `INITIAL` once the target is collected,
genuinely weak on **both** the transpiled-Node and on-stack runtimes. zqjs builds all
four JS weak features on it, so they collect for real (not a leaking strong-ref shim):

- **`WeakRef`** → thin wrapper: hold one `CL_ABAP_WEAK_REFERENCE`; `deref()` = `get( )`
  (mapping `INITIAL`→`undefined`).
- **`WeakMap` / `WeakSet`** → each entry holds its *key* via a `CL_ABAP_WEAK_REFERENCE`
  (indexed by a per-object identity id for O(1) lookup); values are held **strongly**
  (per spec). A **lazy sweep** on access — and opportunistically during GC/job-queue
  checkpoints — purges entries whose key `get( )` has gone `INITIAL`.
- **`FinalizationRegistry`** → **polling**: keep `(weakref, held_value, token)` records;
  at job-queue drain, any record whose `get( )` is `INITIAL` enqueues its cleanup
  callback with `held_value`. The spec permits lazy/never finalization, so polling is
  conforming.

Known limitations (documented, not chased): (i) **no true ephemeron semantics** — a
`WeakMap` value that strongly references its own key can over-retain (memory only, not
observable); (ii) **GC timing is non-deterministic** — test262 cases that force GC via
`$262.gc()` are mapped to host GC where available (`global.gc()` on Node), otherwise
skip-listed.

**Settled sub-decision — regex.** zqjs does **not** port `libregexp`; it shims to
ABAP's PCRE engine behind a JS-semantics translation layer (see §4 and Phase 7).

**Settled sub-decision — Unicode (use ABAP standard facilities, don't port
`libunicode`).** The bulk of `libunicode` (and its 252 KB of tables) is replaced by
what ABAP already provides:

- **Case conversion** (`toLowerCase`/`toUpperCase`, `toLocale*`) → ABAP `to_upper`/
  `to_lower` built-ins + `cl_abap_char_utilities`. *Caveat:* JS uses locale-independent
  full case mapping with special cases (`ß`→`SS`, Greek final sigma, Turkish dotless i)
  that plain `to_upper` may not reproduce; verify against test262 and patch the handful
  of divergent code points with a tiny special-casing table.
- **RegExp Unicode property escapes `\p{…}`/`\P{…}` and case-insensitive matching** →
  delegated to the **PCRE2 engine already chosen** (kernel PCRE2 supports `\p{…}`), so
  no property database is ported.
- **UTF-8 ↔ UTF-16 / codepage** (source decoding, `TextEncoder`/`TextDecoder`) →
  `cl_abap_codepage` / `cl_abap_conv_*`.

Two residual gaps that ABAP standard classes do **not** cover cleanly:

1. **Identifier classification** (`ID_Start`/`ID_Continue`) in the lexer hot path — no
   clean standard class, and a per-char PCRE call would be too slow. → Keep **one small
   generated ABAP table** (a tiny fraction of `libunicode-table.h`).
2. **`String.prototype.normalize`** (NFC/NFD/NFKC/NFKD) — no standard ABAP normalization
   class exists and none is in open-abap today. → **Deferred**; options when needed:
   generate just the normalization data, or add a normalization class to open-abap.

**Settled sub-decision — direct-to-bytecode (no AST).** zqjs follows QuickJS's
fused parse+codegen: the parser emits bytecode as it recognizes each grammar
production, with **no intermediate parse tree**, followed by a **second pass** that
resolves variables/closures and rewrites/patches the bytecode (QuickJS's
`resolve_variables`/`resolve_labels` stage). This keeps the front end faithful to
the C source and the opcode stream directly comparable to native QuickJS output. To
offset the loss of an AST's debuggability, a **bytecode disassembler is built early**
(Phase 2 deliverable) and disassembly snapshots are the primary front-end test.

---

## 6. Proposed ABAP architecture

```
zif_qjs_value            " value handle: tag + payload
zcl_qjs_runtime          " JSRuntime: heap-wide state, atom table, shapes, GC policy, job queue
zcl_qjs_context          " JSContext: global object, intrinsics, per-realm state
zcl_qjs_atoms            " string<->atom interning; predefined atoms
zcl_qjs_string           " UTF-16 code-unit string + operations
zcl_qjs_dtoa             " double<->string (ECMAScript formatting/parsing), radix 2-36; interim stopgap -> faithful port in Phase 8
zcl_qjs_mpb              " internal big-integer (limb array) for exact dtoa rounding (deferred with dtoa)
zcl_qjs_shape            " hidden class: property-name/flags layout, shared
zcl_qjs_object           " JSObject: shape + property values, prototype, class id, exotic hooks
zcl_qjs_lexer            " tokenizer over UTF-16 source
zcl_qjs_parser           " recursive-descent parser, emits bytecode directly (no AST)
zcl_qjs_emitter          " bytecode buffer + label/reloc handling (zcl_qjs_bytebuf)
zcl_qjs_disasm           " bytecode disassembler (debug + front-end test oracle)
zcl_qjs_function         " JSFunctionBytecode: code, constants, locals, closure vars
zcl_qjs_vm               " JS_CallInternal: the CASE-dispatch interpreter loop + stack
zcl_qjs_weakref          " WeakRef/WeakMap/WeakSet/FinalizationRegistry on CL_ABAP_WEAK_REFERENCE
zcl_qjs_builtin_*        " Object, Array, String, Number, Math, JSON, Date, RegExp, Map, ...
zcx_qjs_*                " host-side exceptions (distinct from thrown JS values)
zcl_qjs                  " public facade: eval_string(), call(), value marshalling
```

Public API sketch:

```abap
DATA(rt) = zcl_qjs=>create_runtime( ).
DATA(result) = rt->eval( `1 + 2 * 3` ).      " -> zif_qjs_value
DATA(n) = result->as_number( ).              " -> 7 (ABAP f)
```

---

## 7. Step-by-step implementation plan

Each phase is independently testable and delivers standalone value. Check items off as
completed.

### Phase 0 — Scaffolding & toolchain
- [ ] Repo layout, `package.json`, `abaplint.jsonc` (choose syntax level + rules).
- [ ] Wire abaplint transpiler + open-abap runner; GitHub Actions CI.
- [ ] Skeleton `zcl_qjs` facade + one `CL_ABAP_UNIT_ASSERT` test that runs on Node CI.
- [ ] Test-harness skeleton: feed a JS source string, capture result/`console.log`.
- **Exit:** green CI on a trivial transpiled+run unit test.

### Phase 1 — Core data model (values, atoms, strings)
- [ ] `zif_qjs_value` + tag constants mirroring QuickJS (`INT`, `FLOAT64`, `BOOL`,
      `NULL`, `UNDEFINED`, `STRING`, `OBJECT`, `SYMBOL`, `EXCEPTION`, ...). No `BIG_INT`.
- [ ] `zcl_qjs_string`: UTF-16 code-unit model, `length`, code-unit access, concat.
- [ ] `zcl_qjs_atoms`: string↔atom interning; load predefined atoms (`quickjs-atom.h`).
- [ ] Central numeric helper: JS `ToNumber`/`ToInt32`/`ToUint32`, NaN/Infinity handling,
      guarded arithmetic (no ABAP arithmetic exceptions leak).
- **Exit:** construct/inspect every primitive; atom round-trip; guarded math unit-tested
      against IEEE edge cases (`1/0`, `0/0`, `-0`, overflow).

### Phase 2 — Front end: lexer & parser → bytecode
- [ ] `zcl_qjs_lexer`: tokens, keywords, literals (numbers/strings/regex tokens),
      ASI rules, template-literal tokenizing.
- [ ] `zcl_qjs_parser`: expressions (precedence), statements, functions, blocks —
      **emitting bytecode directly during the parse, no AST** (QuickJS-style).
- [ ] `zcl_qjs_emitter` + `zcl_qjs_bytebuf`: emit QuickJS opcodes, labels, jumps.
- [ ] **Pass 2** — variable/closure resolution + bytecode rewrite/patch (scopes,
      `var`/`let`/`const`, TDZ markers, arg/local/closure slot assignment,
      label fixups); mirrors QuickJS `resolve_variables`/`resolve_labels`.
- [ ] `zcl_qjs_disasm`: bytecode disassembler (debug + test oracle), built here.
- **Exit:** parse + emit bytecode for a corpus; disassembly snapshots match expected.

### Phase 3 — The VM (bytecode interpreter) — *the core*
- [ ] Port `quickjs-opcode.h` → `zif_qjs_opcodes` constants + operand widths.
- [ ] `zcl_qjs_vm`: operand stack, frames, locals/args, `CASE`-dispatch loop.
- [ ] Implement the minimal opcode subset: push/pop, arithmetic, comparisons, local
      get/set, control flow (jumps), function call/return, closures.
- [ ] Stack-depth guard → JS `RangeError`.
- **Exit:** run real scripts — arithmetic, `if`/`while`/`for`, recursion (fibonacci),
      closures/counters — with correct results.

### Phase 4 — Objects, shapes, prototypes
- [ ] `zcl_qjs_shape` (hidden classes, shared) + `zcl_qjs_object` (props, prototype,
      class id, property flags: writable/enumerable/configurable).
- [ ] Property get/set/define/delete; getters/setters; prototype-chain lookup.
- [ ] `Array` (start generic; fast-array optimization later); `arguments`.
- [ ] `new`, constructors, `this` binding.
- **Exit:** object/array literals, property access, prototypal inheritance, `instanceof`.

### Phase 5 — Core built-ins & number formatting
- [ ] Number↔string — **interim stopgap** (`zcl_qjs_dtoa`); the faithful `dtoa.c` port
      is **deferred** to Phase 8. Interim gets common cases right without a bignum:
  - [ ] `String(n)`/`toString()` default: integers exact; doubles via
        **shortest-round-trip search** — format at increasing precision through ABAP
        conversion, parse back, take the shortest that reproduces the value — then apply
        the ECMAScript exponent/format-shape rules.
  - [ ] `parseFloat`/`Number()`/literals: ABAP decimal parse + manual `0x`/`0o`/`0b`.
  - [ ] **Documented divergences** (await exact port): `toFixed`/`toPrecision` rounding
        at large magnitudes, arbitrary-radix fractional output; affected test262 cases
        go on the skip-list.
- [ ] Priority built-ins: `Object`, `Function`, `Array`, `String`, `Number`,
      `Boolean`, `Math`, `JSON`, `Symbol`, `Error` hierarchy.
- [ ] Then: `Map`, `Set`, `Reflect`, `Date`; `WeakMap`/`WeakSet` on
      `CL_ABAP_WEAK_REFERENCE` (weak keys + lazy sweep — see §5).
- **Exit:** rising test262 pass rate on built-in sections; JSON round-trips; correct
      number formatting across the tricky cases.

### Phase 6 — Advanced language features
- [ ] Exceptions end-to-end: `try/catch/finally`, `throw`, error unwinding in the VM.
- [ ] Destructuring, spread/rest, default params, template literals, computed keys.
- [ ] Classes (fields, `#private`, static, inheritance, `super`).
- [ ] Iterators + `for..of`; **generators** (VM suspend/resume — significant).
- [ ] **Promises** + microtask/job queue; **async/await**.
- [ ] **ES modules** (parse, link, evaluate; import/export, dynamic `import()`).
- [ ] `WeakRef` + `FinalizationRegistry` on `CL_ABAP_WEAK_REFERENCE` (direct wrapper +
      polling at job-queue drain — see §5).
- **Exit:** each feature group passes its test262 subset.

### Phase 7 — Regex & Unicode
- [ ] Unicode (**use ABAP facilities** — §5): wire `to_upper`/`to_lower` (+ special-case
      patch table) for String case ops; rely on PCRE2 `\p{…}` for regex properties;
      `cl_abap_codepage`/`cl_abap_conv_*` for UTF conversions.
  - [ ] Generate the one small **ID_Start/ID_Continue** table for the lexer.
  - [ ] `String.prototype.normalize` — **deferred** (no standard class); stub that
        throws/no-ops until normalization data or an open-abap class is added.
- [ ] Regex (**PCRE shim** — decided): `zcl_qjs_regexp` wrapping `CL_ABAP_MATCHER`/
      `CL_ABAP_REGEX` (`PCRE`). Sub-tasks:
  - [ ] **Pattern translation** JS source → PCRE: named groups `(?<name>…)`,
        lookbehind, `\uXXXX`/`\u{…}` → `\x{…}`, character-class and escape differences.
  - [ ] **Flag mapping** `i`/`m`/`s`/`u` → PCRE options; **`g`** and sticky **`y`**
        emulated by driving matches from `lastIndex` (anchored for `y`); `d` (indices)
        and `v` best-effort.
  - [ ] **`RegExp.prototype` semantics** on top: `exec`/`test`/`Symbol.match`/
        `matchAll`/`Symbol.replace`/`Symbol.split`, `lastIndex` bookkeeping, capture
        arrays + named groups object.
  - [ ] **Divergence doc + skip-list**: record JS↔PCRE gaps rather than chase them;
        reflect them in the test262 skip-list.
- [ ] (BigInt is out of scope — see §2.)
- **Exit:** the supported regex / `u`-flag test262 subset passes; divergences documented.

### Phase 8 — Conformance, performance, packaging
- [ ] **Faithful `dtoa.c` port** (deferred from Phase 5): `js_dtoa`/`js_atod` with the
      internal `zcl_qjs_mpb` big-integer for exact rounding across FIXED/PRECISION,
      radix 2–36, and all round-trip edge cases; removes the interim divergences +
      their skip-list entries. (Needed only if exact number-formatting conformance is a
      goal — the interim stopgap suffices for typical scripting.)
- [ ] ABAP **test262 runner**; track and publish pass-rate over time.
- [ ] Performance: fast arrays, atom/shape inline caches, fewer allocations, hot-path
      opcode tuning; benchmark suite.
- [ ] Public API polish: ABAP↔JS value marshalling, host-function registration,
      resource limits (instruction/step budget, memory guard).
- [ ] Docs, examples, and an optional `qjs`-style ABAP REPL report.
- **Exit:** documented, versioned engine with a stated conformance level.

---

## 8. Testing & conformance strategy

- **Golden vectors:** compile the same scripts with native QuickJS (`qjsc`/dump) and
  compare bytecode/behavior to catch divergence at the VM boundary.
- **Unit tests:** `CL_ABAP_UNIT_ASSERT` per class; run on Node via the transpiler for
  fast feedback, and periodically on a real ABAP stack.
- **test262:** the canonical measure. Start with language basics, expand per phase,
  maintain a skip-list with reasons, and treat pass-rate as the north-star metric.
- **Differential fuzzing (later):** random small programs, compare output vs. native
  QuickJS/Node.

---

## 9. Milestones & rough effort

| Milestone | Capability | Rough scale |
|---|---|---|
| M1 (Phases 0–3) | Core language runs (expressions, control flow, functions, closures) | weeks–months |
| M2 (Phases 4–5) | Objects + common built-ins → *usable embedded scripting engine* | months |
| M3 (Phase 6) | Classes, generators, promises/async, modules | months |
| M4 (Phase 7–8) | Regex/Unicode + conformance & performance hardening | ongoing / multi-person-year to broad parity |

Estimates assume the C source is used as spec throughout. **M2 is the pragmatic
"ship something useful" line.**

---

## 10. Risks & mitigations

- **Performance** — inherent to an ABAP interpreter. *Mitigate:* shape-based caches,
  fast arrays, step budgets; set expectations (light scripting, not compute).
- **Floating-point traps** — ABAP raising on arithmetic that JS defines as NaN/Infinity.
  *Mitigate:* one guarded numeric layer, fuzzed against IEEE edge cases early.
- **Number formatting fidelity** — ABAP native float→string ≠ ECMAScript shortest
  round-trip. *Interim (chosen):* shortest-round-trip-by-search stopgap — correct for
  typical scripting, with documented edge-case divergences on the skip-list. *Full fix
  (deferred, Phase 8):* faithful `dtoa` + `zcl_qjs_mpb` bignum; do **not** substitute
  `decfloat34`/`WRITE`. Differential-test against Node when the exact port lands.
- **UTF-16 correctness** — surrogate pairs, astral code points. *Mitigate:* explicit
  code-unit model + targeted tests; BMP-first, then astral.
- **Weak references** (WeakRef/WeakMap/WeakSet/FinalizationRegistry) — **resolved**:
  built on `CL_ABAP_WEAK_REFERENCE` (real weak semantics on both runtimes; see §5).
  Residual: no true ephemeron semantics (over-retention only, not observable) and
  non-deterministic GC timing (map `$262.gc()` to host GC where available, else
  skip-list). *Depends on* open-abap continuing to back the class with a JS `WeakRef`.
- **Scope creep** — ES2025 is huge. *Mitigate:* phase gates, test262 pass-rate targets,
  explicit deferral list (**BigInt**, Atomics, `Intl`/ECMA-402, tail calls).
- **Regex fidelity (PCRE shim)** — the chosen shim diverges from JS in edge cases
  (`u`/`v` Unicode semantics, sticky `y`, `d` indices, some class/escape differences),
  and behavior may differ between the transpiled-Node runtime and a real ABAP PCRE2
  stack. *Mitigate:* keep JS semantics (`lastIndex`, groups) in the shim, not in the
  raw match; document divergences + skip-list; validate on both runtimes. Porting
  `libregexp` remains a fallback only if a concrete requirement demands full fidelity.
- **Unicode via ABAP facilities** — `to_upper`/`to_lower` may diverge from JS full
  case mapping (`ß`→`SS`, final sigma, Turkish `i`), and `String.prototype.normalize`
  has no standard ABAP backing. *Mitigate:* small special-casing patch table validated
  against test262; ship `normalize` deferred (stub) until data/class is added; regex
  `\p{…}` is covered by PCRE2. Depends on the kernel/open-abap case-mapping behavior
  matching between runtimes — validate on both.
- **Native-recursion limits** — deep JS call chains. *Mitigate:* stack-depth guard →
  `RangeError`; consider an explicit call-stack structure.
- **Upstream drift** — QuickJS keeps evolving. *Mitigate:* pin to a QuickJS version,
  record it, and rebase deliberately.

---

## 11. Recommended immediate next steps

1. Finalize dialect target + `abaplint.jsonc`; stand up CI with one transpiled test
   (Phase 0).
2. Prototype `zif_qjs_value` + the guarded numeric layer + `zcl_qjs_atoms` (Phase 1) —
   this de-risks the biggest design decisions cheaply.
3. Vertical slice: lexer → parser → emitter → VM for `1 + 2 * 3` and a `while` loop,
   proving the whole pipeline end-to-end on the smallest opcode subset (Phases 2–3).
4. Pin the QuickJS commit being tracked and record it in this repo.

---

## 12. Sources

- QuickJS repository — <https://github.com/bellard/quickjs>
- QuickJS engine documentation (features, architecture, memory model) —
  <https://bellard.org/quickjs/quickjs.html>
- "QuickJS: An Overview and Guide to Adding a New Feature", Igalia —
  <https://blogs.igalia.com/compilers/2023/06/12/quickjs-an-overview-and-guide-to-adding-a-new-feature/>
- QuickJS internals (DeepWiki) — <https://deepwiki.com/bellard/quickjs>
- abaplint / open-abap toolchain — <https://abaplint.org> · <https://github.com/open-abap>
