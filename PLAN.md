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
ABAP, using a pinned QuickJS release and commit as the authoritative reference** — the
same bytecode concepts, atom/shape model, and built-in algorithms — while replacing
C-specific machinery (reference counting, pointer arithmetic, computed-goto dispatch)
with ABAP-native equivalents (managed references / GC, index-based buffers, explicit
VM frames, `CASE` dispatch). Exact serialized-bytecode compatibility is not a goal.

Correctness is achievable **within an explicit, versioned feature profile**. The two
hard truths to set expectations:

1. **Scope is large.** The core (`quickjs.c`) is ~61k lines of C. A *useful embedded
   scripting engine* (core language + common built-ins) is a matter of person-months;
   *broad ES2025 + test262 conformance* is a multi-person-year undertaking.
2. **Performance will be modest.** An interpreter written in ABAP, dispatching bytecode
   via method calls with boxed values, will be orders of magnitude slower than native
   QuickJS. This is fine for configuration logic, rules, templating, and light
   scripting — the likely use cases for JS-on-ABAP — but it is not a general-purpose
   high-throughput runtime.

The transpiler provides a valuable **fast structural test loop**, but it is not a semantic
substitute for a real ABAP stack. Node can mask exactly the host differences that matter
here: exceptional floating-point values, UTF-16 edge cases, PCRE behavior, case mapping,
and garbage collection. CI therefore has two lanes: frequent transpiled tests and a
mandatory real-ABAP compatibility suite for every release (plus scheduled runs while
developing host-sensitive components).

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
| `dtoa.c/.h` | ~45 KB | Correct double↔string (`Number.toString`, parsing), radix 2–36; uses internal bignum for exact rounding | **Deferred** (Phase 9): interim literal parser in Phase 1 and formatter in Phase 5; faithful port later, pulls in a mini-bignum |
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
> is itself **deferred** (interim stopgaps first; see §7 Phases 1, 5, and 9), that internal
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
  Configure the accepted syntax/rules in `abaplint.jsonc` and pin all npm dependencies.
- **Supported-system contract:** before implementation, record the minimum SAP_BASIS
  release, Unicode-only requirement, supported kernel/PCRE versions, and the exact
  open-abap version. ABAP Cloud is a separate adapter/profile, not an assumed property:
  weak-reference, explicit-GC, and codepage APIs must be checked for release status and
  replaced or feature-gated where unavailable.
- **Object model:** OO ABAP — classes (`zcl_qjs_*`), interfaces (`zif_qjs_*`),
  `CX_*` exceptions. No global state beyond a runtime instance.
- **Toolchain / dev loop:** abaplint (lint) + transpiler (ABAP→JS) + open-abap runner;
  `CL_ABAP_UNIT_ASSERT` for tests; GitHub Actions for CI. Node is the fast lane; real
  ABAP is the semantic authority for host-sensitive behavior.
- **Naming:** proposed prefix `zcl_qjs_` / `zif_qjs_` / `zcx_qjs_` (adjust to taste).

Phase 0 must run a **host-capability probe** on both targets for: NaN/±Infinity/-0
representation, arithmetic traps, UTF-16 indexing and lone surrogates, UTF conversion,
case mapping, PCRE selection/capture offsets/flags, weak-reference collection after an
explicit GC request, and availability of every proposed standard class. A failed probe
changes the design or disables a feature; it is not papered over by the transpiled lane.

---

## 4. The hard part — C↔ABAP impedance mismatches

These decide the whole design and must be settled in Phases 0–1.

| QuickJS (C) mechanism | Problem in ABAP | Chosen ABAP approach |
|---|---|---|
| `JSValue` = NaN-boxed / tagged union | No unions, no NaN boxing; ABAP `f` cannot carry every JS numeric state | A **flat tagged structure** `zcl_qjs_value=>ty_value`, not one object per primitive. It has `tag` + typed payload fields. The Number payload is `{ kind, finite_value }`, where `kind` distinguishes finite, NaN, +Infinity, -Infinity, and -0. Objects/strings use `REF TO`. Benchmark this representation in Phase 1. |
| Reference counting (`JS_DupValue`/`JS_FreeValue`) + cycle GC | ABAP is garbage-collected; manual object refcounts are unnecessary, but runtime-owned intern/caches remain GC roots | Drop object/value refcounting and rely on ABAP GC. Explicitly design retention, reclamation, and quotas for atom tables, shape-transition caches, modules, compiled functions, and host resources. |
| Weak references (`WeakRef`, `WeakMap`, `WeakSet`, `FinalizationRegistry`) | ABAP has weak references, but availability/GC control varies by target and weak maps require ephemerons for full semantics | Use `CL_ABAP_WEAK_REFERENCE` only after the Phase 0 capability probe. `WeakRef`→direct wrapper; weak collections→weak keys + lazy sweep; `FinalizationRegistry`→best-effort polling. Feature-gate targets where the primitive is absent or behavior differs. See §5 + Risks. |
| Computed-goto / switch dispatch in `JS_CallInternal` | No computed goto; giant `switch` legal but must be structured | Single `CASE opcode` loop; opcode bodies as inlined blocks or helper methods. |
| `goto` (error unwinding, fast paths) | No `goto` in ABAP | Restructure with loops, early `RETURN`, and `TRY/CATCH` for the exception paths. |
| Pointer arithmetic (lexer, bytecode reader, buffers) | No pointers | Index-based access over ABAP `string`/`xstring`/internal tables; a `dbuf`-like `zcl_qjs_bytebuf`. |
| 32-bit int wraparound, `ToInt32`/`ToUint32`, `<<`/`>>>`/`&` | ABAP `i` is signed 4-byte; uint32 overflows it; bitops are on byte fields | Use `int8` (8-byte) for intermediate math; implement JS integer coercion + bit ops explicitly (via `int8` masking or `xstring` `BIT-*`). |
| IEEE-754 semantics: `1/0=Infinity`, `0/0=NaN`, signed zero, no traps | ABAP arithmetic on `f` can raise `CX_SY_ARITHMETIC_*`; exceptional values and -0 cannot be assumed representable | Route every numeric operation through a helper over the explicit Number-kind representation. Never allow an ABAP arithmetic exception to escape as JS behavior. Differential-test the full special-value matrix on both hosts. |
| Strings = UTF-16 code units, 8/16-bit rope optimization | ABAP `string` behavior for lone surrogates/conversion must be proven on every target | Model strings as **UTF-16 code-unit sequences** behind an abstraction. Phase 0 decides whether `string` is a safe backing; otherwise use an `xstring`/16-bit-unit table. Correct code-unit access is required from the first slice; code-point iteration can follow. Skip the 8/16-bit storage optimization. |
| `libunicode` (case mapping, `\p{}` props, identifier classes, normalization) | Large code + 252 KB of generated tables | **Mostly not ported** — use validated host adapters for case/UTF conversion and the explicit PCRE adapter for supported regex properties. Generate a pinned **ID_Start/ID_Continue** table plus deterministic case corrections. Normalization remains unsupported until implemented (§5). |
| BigInt (arbitrary precision integers) | No native bignum in ABAP | **Out of scope** (see §2). If revived: a `zcl_qjs_bigint` bignum class. |
| Regex engine (`libregexp` bytecode backtracker) | ABAP has PCRE, but JS regex semantics differ | **Decided: explicit PCRE adapter first** (`CL_ABAP_REGEX`/`CL_ABAP_MATCHER`, PCRE mode). A translation layer owns JS syntax and `RegExp.prototype` state. Supported constructs must agree across hosts; known gaps are rejected and documented. Port `libregexp` later only if required. |
| Deep C recursion (`JS_CallInternal` per JS call; recursive-descent parser) | ABAP call stack depth is limited; generators/async later need suspendable frames | The VM has an **explicit frame table from Phase 2** and never uses ABAP recursion for JS calls. Bound parser recursion separately and surface the appropriate JS error before an ABAP abort. |
| Function pointers (built-in dispatch, class methods) | No function pointers | Prefer typed handler interfaces (`zif_qjs_callable`, exotic-object hooks) and numeric built-in IDs with `CASE` dispatch. Avoid dynamic method-name calls on hot paths. |

---

## 5. Strategy decision

**Re-implement, don't transliterate.** Treat the C as an executable specification:

- Generate constants and operand metadata from the pinned QuickJS
  **opcode set** (`quickjs-opcode.h`). Preserve opcode semantics where practical, but do
  not promise compatibility with QuickJS's version-bound serialized bytecode.
- Reuse the **atom table**, **shape** model, and **built-in algorithms** (which
  themselves track the ECMAScript spec), reading `quickjs.c` function-by-function.
- Replace machinery, not meaning: GC, dispatch, buffers, value boxing become ABAP-native.
- Maintain a tiny patched QuickJS reference tool that emits **normalized JSON
  disassembly** (symbolic opcodes/atoms, constants, scopes, and stack metadata). This,
  plus behavior, is the compiler oracle; raw serialized bytes and numeric atom IDs are
  not compared.

**Settled sub-decision — memory management.** zqjs drops QuickJS's object/value
reference counting and cycle collector and leans on the ABAP kernel's garbage
collector. `JS_DupValue`/`JS_FreeValue` call sites are not mechanically ported.
This does **not** make ownership disappear: runtime tables can keep data reachable
forever. The design must define which atom, shape transition, bytecode, module, and host
resource tables are strong, weak, bounded, or cleared at checkpoints/runtime disposal.
Anything QuickJS did in a finalizer (for example closing a resource) moves to explicit
`close()`/`dispose` semantics. Atom count, object count/estimated bytes, bytecode size,
and job-queue length have configurable limits from the first embedded milestone.

**Conditional sub-decision — weak references (`CL_ABAP_WEAK_REFERENCE`).** ABAP
provides a weak-reference primitive, but zqjs enables it only on target adapters that
pass the Phase 0 collection probe. The pinned open-abap implementation is inspected and
tested rather than assumed. On a conforming target, zqjs builds the weak features as
follows:

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

Known limitations: (i) there is **no true ephemeron semantics** — a `WeakMap` value that
strongly references its key can over-retain it, which can affect weak-reference and
finalization observations under forced GC; (ii) GC timing is non-deterministic;
(iii) explicit GC may be unavailable or unreleased on some targets. Test262 cases that
require `$262.gc()` run only on adapters with a verified host-GC hook and are otherwise
reported as unsupported, not silently counted as passes. Weak collections are therefore
an optional conformance profile, not a resolved core feature.

**Settled sub-decision — regex.** zqjs does **not** initially port `libregexp`; it shims
to an explicitly selected PCRE adapter behind a JS-semantics translation layer (see §4
and Phase 7). The Node and on-stack adapters must pass the same contract suite; the
default `CL_ABAP_REGEX` mode must never be assumed to be PCRE. Unsupported syntax is
rejected deterministically instead of being accepted with approximate meaning.

**Settled sub-decision — Unicode (validated host adapters first, don't initially port
`libunicode`).** The bulk of `libunicode` (and its 252 KB of tables) is replaced by
host behavior only where the cross-host contract proves it, with generated corrections
for deterministic results:

- **Case conversion** (`toLowerCase`/`toUpperCase`) → start with ABAP `to_upper`/
  `to_lower`, but validate the complete supported Unicode mapping on both hosts. Use a
  generated patch table where host mappings or Unicode versions differ. `toLocale*` is
  separately feature-gated by declared locale support; it is not aliased blindly to the
  locale-independent methods.
- **RegExp Unicode property escapes `\p{…}`/`\P{…}` and case-insensitive matching** →
  delegated to the explicit PCRE adapter only for property names and Unicode behavior
  proven by the pinned contract. The initial profile ports no separate property database;
  unsupported properties are rejected.
- **UTF-8 ↔ UTF-16 / codepage** (source decoding, `TextEncoder`/`TextDecoder`) →
  `cl_abap_codepage` / `cl_abap_conv_*`.

Two residual gaps that ABAP standard classes do **not** cover cleanly:

1. **Identifier classification** (`ID_Start`/`ID_Continue`) in the lexer hot path — no
   clean standard class, and a per-char PCRE call would be too slow. → Keep **one small
   generated ABAP table** (a tiny fraction of `libunicode-table.h`).
2. **`String.prototype.normalize`** (NFC/NFD/NFKC/NFKD) — no standard ABAP normalization
   class exists and none is in open-abap today. → **Deferred**; the method is absent or
   throws a documented unsupported-feature error. It must never silently no-op. Options
   when implemented: generate the normalization data or add an open-abap class.

**Settled sub-decision — direct-to-bytecode (no AST).** zqjs follows QuickJS's
fused parse+codegen: the parser emits bytecode as it recognizes each grammar
production, with **no intermediate parse tree**, followed by a **second pass** that
resolves variables/closures and rewrites/patches the bytecode (QuickJS's
`resolve_variables`/`resolve_labels` stage). To offset the loss of an AST's
debuggability, a bytecode disassembler and normalized QuickJS reference oracle are built
early. Direct `eval`, the `Function` constructor, strict/sloppy mode, `with`, and Annex B
all change scope resolution, so their supported status is fixed before that pass is
designed.

---

## 6. Proposed ABAP architecture

```
zcl_qjs_value            " ty_value: flat tag + payload; static constructors/conversions
zcl_qjs_number           " finite f + explicit NaN/±Infinity/-0 kinds and JS arithmetic
zcl_qjs_runtime          " heap state, atoms/shapes, budgets, job queue, adapter capabilities
zcl_qjs_context          " JSContext: global object, intrinsics, per-realm state
zcl_qjs_atoms            " string<->atom interning; predefined atoms
zcl_qjs_string           " UTF-16 code-unit string + operations
zcl_qjs_dtoa             " double<->string; interim parser/formatter -> optional faithful port in Phase 9
zcl_qjs_mpb              " internal big-integer (limb array) for exact dtoa rounding (deferred with dtoa)
zcl_qjs_shape            " hidden class: property-name/flags layout, shared
zcl_qjs_object           " JSObject: shape + property values, prototype, class id, exotic hooks
zcl_qjs_lexer            " tokenizer over UTF-16 source
zcl_qjs_parser           " recursive-descent parser, emits bytecode directly (no AST)
zcl_qjs_emitter          " bytecode buffer + label/reloc handling (zcl_qjs_bytebuf)
zcl_qjs_disasm           " bytecode disassembler (debug + front-end test oracle)
zcl_qjs_function         " JSFunctionBytecode: code, constants, locals, closure vars
zif_qjs_callable         " typed call interface for bytecode and host functions
zcl_qjs_completion       " normal/return/throw/break/continue completion representation
zcx_qjs_throw            " internal ABAP unwinder carrying a thrown JS value where needed
zcl_qjs_vm               " CASE-dispatch loop, explicit operand/frame stacks, step budget
zif_qjs_host_adapter     " PCRE/Unicode/clock/GC/cancellation and capability boundary
zcl_qjs_limits           " instruction, stack, atom, object, bytecode, and queue budgets
zcl_qjs_weakref          " WeakRef/WeakMap/WeakSet/FinalizationRegistry on CL_ABAP_WEAK_REFERENCE
zcl_qjs_builtin_*        " Object, Array, String, Number, Math, JSON, Date, RegExp, Map, ...
zcx_qjs_host_*           " host/configuration failures, distinct from thrown JS values
zcl_qjs                  " public facade: eval_string(), call(), value marshalling
```

Public API sketch:

```abap
DATA(rt) = zcl_qjs=>create_runtime( ).
DATA(result) = rt->eval( `1 + 2 * 3` ).      " -> zcl_qjs_value=>ty_value
DATA(n) = zcl_qjs_value=>as_finite_number( result ). " -> 7 (ABAP f)
```

Internal values stay flat on operand/local tables to avoid allocating an ABAP object for
every primitive. References remain references when the structure is copied. Phase 1
benchmarks stack push/pop, calls, and arithmetic against an object-wrapper alternative;
changing the representation after the VM exists would be expensive, so measure early.

---

## 7. Step-by-step implementation plan

Each phase is independently testable and delivers standalone value. Check items off as
completed.

**Implementation status (2026-07-22):** `[x]` means the item is implemented and
verified in the current transpiled-Node lane. Incomplete items remain `[ ]` and may
carry a **Partial** note. Verification on a representative real ABAP stack is still
outstanding, so no dual-host exit criterion is considered complete yet.

Current verified baseline: the full `npm test` pipeline is green; the generated
QuickJS table contains 99 opcodes; abaplint covers 64 files with no findings; all
current ABAP Unit suites pass; and the pinned test262 slice reports 806 pass, 3
reasoned unsupported, and 0 fail.

### Phase 0 — Scope, reproducibility & host proof
- [x] Fix the supported language profile: strict/sloppy mode, direct `eval`, `Function`,
      `with`, Annex B, modules, and the explicitly excluded/deferred features. BigInt,
      `Intl`, SharedArrayBuffer/Atomics, and tail calls start outside the core profile;
      record `Proxy`, TypedArray/ArrayBuffer/DataView, and async-generator status too.
- [ ] Pin the QuickJS release **and commit**, test262 commit, Unicode version, npm
      dependencies, open-abap version, minimum SAP_BASIS/kernel, and PCRE baseline.
      Preserve upstream MIT notices for derived/generated material.
      **Partial:** QuickJS, test262, npm/open-abap, and minimum SAP versions are
      recorded; Unicode/PCRE baselines and the complete derived-material notice audit
      remain.
- [ ] Repo layout, lockfile, `abaplint.jsonc`, transpiler/open-abap runner, and CI.
      **Partial:** the repository, lockfile, lint/transpile/test runners, and the
      transpiled lane exist; a real-ABAP CI lane remains.
- [ ] Run the host-capability probe from §3 on Node and a representative real ABAP
      stack; publish its result as a target matrix.
- [x] Minimal test262 ingestion: front matter, harness includes, positive/negative parse
      and runtime tests, feature filtering, and reasoned unsupported/skip reporting.
      Async and module harness support grows when those features arrive.
- [ ] Build/pin a small QuickJS reference utility that emits normalized JSON
      disassembly. Generate `zif_qjs_opcodes`, operand metadata, predefined atoms, and
      `ID_Start`/`ID_Continue` ranges from pinned upstream inputs.
      **Partial:** the normalized oracle and opcode/operand generation are in place;
      predefined-atom and Unicode identifier-range generation remain.
- [ ] Skeleton public facade and one unit test passing in both CI lanes.
      **Partial:** the facade and transpiled ABAP Unit coverage exist; the real-ABAP
      lane is not yet available.
- **Exit:** reproducible green builds, a published capability/profile manifest, a real
      ABAP smoke test, generated inputs, and one test262 test reported correctly.

### Phase 1 — Runtime invariants
- [ ] `zcl_qjs_value=>ty_value`: flat tagged representation for `INT`, `NUMBER`, `BOOL`,
      `NULL`, `UNDEFINED`, `STRING`, `OBJECT`, `SYMBOL`, and internal sentinels. No
      `BIG_INT`; benchmark it against object wrappers before freezing the VM API.
      **Partial:** the tagged representation is implemented and in use; the recorded
      wrapper comparison/benchmark remains.
- [ ] `zcl_qjs_number`: explicit finite/NaN/+Infinity/-Infinity/-0 kinds; guarded JS
      arithmetic, comparison, `ToNumber`/`ToInt32`/`ToUint32`, and an **interim parser**
      for decimal and `0x`/`0o`/`0b` literals. Validate it against a named boundary
      corpus and tag every exact-rounding divergence pending Phase 9. No ABAP arithmetic
      exception may leak.
      **Partial:** number kinds, coercions, parsing, arithmetic, and shortest finite
      formatting are covered; the named boundary corpus and exact divergence catalog
      are not complete.
- [ ] `zcl_qjs_string`: choose its backing from the Phase 0 probe; implement exact
      UTF-16 length/code-unit access, lone-surrogate preservation, concat, and equality.
      **Partial:** the string abstraction and UTF-16 operations exist; real-host probe
      evidence, especially for lone surrogates, remains.
- [x] `zcl_qjs_completion`/`zcx_qjs_throw`: define normal, return, throw, break, and
      continue propagation, keeping host/configuration failures separate.
- [ ] Runtime/context shell, symbols, atom interning, and explicit retention rules.
      Predefined atoms may be permanent; dynamic atoms and shape caches need lifecycle
      policy and quotas.
      **Partial:** runtime/context, symbols, and atom interning exist; lifecycle policy
      and quotas for dynamic atoms and shape caches remain incomplete.
- [ ] `zcl_qjs_limits` and cancellation checks: instruction, frame/operand stack,
      parser depth, atoms, objects/estimated bytes, source/bytecode size, and job queue.
      **Partial:** instruction, stack/frame, parser, atom/object, and source/bytecode
      limits plus cancellation are implemented; estimated-byte and job-queue limits
      remain.
- [x] Minimal callable/object cells needed by the first VM slice.
- **Exit:** every primitive and special Number state round-trips; arithmetic/coercion,
      string/code-unit, completion, atom-lifecycle, and limit tests pass on both hosts.

### Phase 2 — First end-to-end vertical slice
- [x] Minimal lexer for identifiers, numeric/string literals, `+ - * /`, parentheses,
      and end-of-input. Regex literal scanning is parser-directed when added later.
- [x] Direct-emitting expression parser plus `zcl_qjs_emitter`/byte buffer.
- [x] `zcl_qjs_function` and `zcl_qjs_disasm`; normalized snapshots compare with the
      pinned QuickJS reference at the logical-instruction level.
- [x] `zcl_qjs_vm`: `CASE` dispatch, operand stack, **explicit frame table**, program
      counter, and budget/cancellation checkpoint.
- [x] Minimal push, arithmetic, return, and required conversion opcodes.
- **Exit:** `1 + 2 * 3` runs through source→lexer→parser→bytecode→VM on both hosts, has a
      normalized reference snapshot, and terminates under a deliberately tiny budget.
      **Status:** complete in the transpiled lane; real-ABAP execution remains.

### Phase 3 — Core language, one vertical slice at a time
- [x] Expand tokens/grammar incrementally: comparisons, assignments, conditional
      expressions, blocks, `if`, classic `for`, `for..in`, `break`/`continue`, ASI,
      and functions. `for..in` includes ordered own/prototype enumeration, duplicate
      suppression, deletion checks, and fresh `let`/`const` cells per iteration. Add
      template/regex lexical modes only with the parser productions that consume them.
- [x] Pass 2: `var`/`let`/`const`, TDZ, args/locals/closure slots, labels, and closure
      capture. Its rules follow the language profile fixed in Phase 0.
- [x] Expand the same explicit-frame VM: locals/args, jumps, calls/returns, closures,
      lexical environments, and stack metadata verification.
- [x] Exceptions end-to-end now: `throw`, `try/catch/finally`, internal TypeError/
      RangeError/SyntaxError creation, real Error/native-error prototype identity,
      and abrupt-completion unwinding.
- [x] Enforce instruction/stack/parser/allocation limits in all new paths.
- **Exit:** arithmetic, `if`/`while`/`for`, recursion, closure counters, and caught/finally
      exceptions pass their test262 subsets and host-differential tests.
      **Status:** covered by ABAP Unit in the transpiled lane; broader named test262
      subsets and real-host differential tests remain.

### Phase 4 — Objects, prototypes & the embedding API
- [ ] `zcl_qjs_shape` + `zcl_qjs_object`: property keys/flags, prototype, class id,
      transition-cache ownership, and exotic hooks.
      **Partial:** shapes, ordinary objects, property flags, prototypes, and transition
      caching exist; class/exotic-hook coverage is not complete.
- [x] Property get/set/define/delete; accessors; prototype lookup; ordinary arrays and
      `arguments`; object/array literals.
- [ ] Functions become ordinary callable objects; implement `this`, `new`, constructors,
      `instanceof`, and callable/constructable distinction.
      **Partial:** declarations plus anonymous/named function expressions, captures,
      self-recursion, and IIFEs are implemented; closures are property-bearing callable
      objects and `this`, `new`, constructors, and callable/constructable checks exist;
      full ordinary-object
      unification and `instanceof` coverage remain.
- [x] Host-function registration through `zif_qjs_callable`, ABAP↔JS marshalling,
      explicit host-resource disposal, error translation, and cancellation.
- [x] Stabilize the public `eval`/`call` API and define runtime/context disposal.
- **Exit:** an ABAP caller registers a function, passes structured values, runs object/
      prototype/constructor code, receives results, catches JS errors, and hits budgets.
      This is the first credible embedded-engine milestone.
      **Status:** achieved and tested in the transpiled lane; representative real-ABAP
      verification remains.

### Phase 5 — Core built-ins & number formatting
- [x] Interim Number→string implementation: integers exact; finite doubles use a
      locale-independent shortest-round-trip search over verified ABAP conversion, then
      ECMAScript exponent/shape rules. Keep special Number kinds explicit.
- [ ] Document and tag known interim divergences (`toFixed`/`toPrecision` extremes,
      arbitrary-radix fractions); they are unsupported/expected failures, not passes.
      **Partial:** shortest-round-trip finite formatting is implemented and tested;
      exact `toFixed`/`toPrecision` and arbitrary-radix divergence coverage remains.
- [ ] Priority built-ins: global functions, `Object`, `Function`, `Array`, `String`,
      `Number`, `Boolean`, `Math`, `JSON`, `Symbol`, and the `Error` hierarchy.
      **Partial:** Object, Array, String, Number, Boolean, Math, bounded JSON, the
      Error hierarchy with constructor/prototype identity, Symbol creation/global-registry operations, numeric globals,
      Number static predicates/constants, Math's eight standard numeric constants plus
      `abs`, `acos`, `acosh`, `asin`, `asinh`, `atan`, `atan2`, `atanh`, `cbrt`,
      `ceil`, `clz32`, `cos`, `cosh`, `exp`, `expm1`, `f16round`, `floor`, `fround`,
      `hypot`, `imul`, `log`, `log1p`, `log10`, `log2`, `max`, `min`, `pow`, `round`,
      `random`, `sign`, `sin`, `sinh`, `sqrt`, `tan`, `tanh`, and `trunc`, and
      Object `assign`, `values`, `entries`, `hasOwn`, and `is`, a real
      `Object.prototype` with `toString`, `valueOf`, `hasOwnProperty`,
      `propertyIsEnumerable`, and `isPrototypeOf`, the four URI transform
      globals, `URIError`, dynamic `Function` construction, and
      `Function.prototype.call`/`apply`/`bind`, runtime-stable well-known Symbols,
      separate symbol-keyed property storage, and Symbol-aware Object reflection are
      present; `Array.of` honors constructor receivers, and arrays inherit a real
      `Array.prototype` with generic `push`, `pop`,
      `shift`, `unshift`, `reverse`, `toReversed`, `toSorted`, `toSpliced`, `with`,
      `slice`, `forEach`, `map`, `filter`, `join`,
      `some`, `every`, `find`, `findIndex`, `findLast`, `findLastIndex`,
      `reduce`, `reduceRight`, `fill`,
      `copyWithin`, `concat`, `splice`, `sort`, `flat`, `flatMap`, `toString`, `indexOf`,
      `lastIndexOf`, `includes`, and `at`,
      shared `ToLength` handling, uint32 index boundaries, and truncating `length`
      assignment. String primitives and wrappers share a real `String.prototype` with
      `toString`, `valueOf`, `charAt`, `charCodeAt`, `at`, `indexOf`, `lastIndexOf`,
      `includes`, `startsWith`, `endsWith`, `slice`, `substring`, `concat`, `repeat`,
      `toLowerCase`, `toUpperCase`, `trim`, `trimStart`, and `trimEnd`, including
      built-in metadata and generic object coercion. All 13 Reflect methods, their
      metadata, receiver-aware access, symbol keys, prototype operations, and object
      extensibility are implemented and covered by ABAP Unit and pinned test262 cases. The
      broader Function/Array/String surfaces, well-known Symbol property attributes,
      other prototypes, and built-in function metadata remain incomplete.
- [x] Then `Map` and `Set`. Ordered SameValueZero storage and arbitrary iterable
      construction, core prototype methods, live iterators, `forEach`, metadata, and
      tags are verified through the general iterator protocol. `Reflect` is complete for ordinary objects
      and the declared callable/constructable profile. Keep `Date`, weak collections, Proxy, and binary
      data in explicit later/deferred feature groups rather than silently omitting them.
- **Exit:** JSON and the declared core built-in profile pass published test262 subsets;
      Number formatting passes a named corpus with every remaining divergence listed.
      **Status:** selected JSON, Symbol, Function, Array, String, Reflect, Map, Set, numeric-global, URI-global, Number, Math, and Object slices
      pass pinned test262 cases; the broader built-in profile, named formatting corpus,
      and divergence catalog remain.

### Phase 6 — Advanced language features
- [x] Destructuring, spread/rest, default parameters, template literals, computed keys.
      Computed string/Symbol object-literal keys and default parameters
      (including references to prior parameters and default-aware function `length`
      descriptors), rest parameters, array/call/constructor spread over arbitrary
      iterables, object spread/rest, and nested array/object
      destructuring (defaults, elisions, computed keys, rest, and member targets in
      declarations, assignments, parameters, loop heads, and catch bindings) are
      implemented and verified. Untagged templates support cooked substitutions;
      tagged templates add cooked/raw frozen arrays, per-site caching, ordered
      substitution arguments, and member-call receiver semantics.
- [x] Classes (fields, private fields, static elements, inheritance, `super`).
      Lexical class declarations, default and explicit constructors,
      instance/static methods, prototype and static inheritance, `instanceof`, and
      `super(...)` constructor calls are implemented and verified. Instance and static
      methods are defined with writable, non-enumerable, configurable descriptors via
      the QuickJS-aligned `define_method` opcode. Anonymous/named class expressions,
      getter/setter accessors, non-constructible method closures, and computed
      string/Symbol method and accessor names are also implemented and verified via
      `define_method_computed`. Class constructors reject direct, member, and
      `Function.prototype.call` invocation without `new`, while `super(...)` remains an
      explicitly marked constructor path. Receiver-aware instance/static `super`
      property reads, writes, method calls, accessors, and computed Symbol keys are
      implemented through `get_super_value`/`put_super_value`. Literal-name public static
      fields now run lexical, receiver-aware initializer closures in source order and use
      QuickJS-aligned `define_field` descriptors; redeclaration, omitted initializers, the
      `static` field name, class self-reference, and callable-object enumeration are covered
      by ABAP Unit and pinned test262 cases. Literal-name public instance fields are likewise
      materialized per instance with standard descriptors: base fields run before the base
      constructor body, derived fields run immediately after `super()`, default derived
      constructors forward arguments across multiple inheritance levels, initializer throws
      propagate, and forbidden literal field names are rejected. Computed public fields
      evaluate string/Symbol keys once at class definition and preserve static/instance
      initializer ordering. Static initialization blocks execute in source order with
      isolated lexical scope, class `this`, and static `super` property access. Private
      instance and static fields use fresh per-class private-name identities and hidden
      brand-checked storage; reads, direct/compound writes, postfix updates,
      initialization ordering, semicolon-free field termination, per-class identity,
      brand rejection, and reflection invisibility are covered by ABAP Unit and pinned
      test262 cases. Private instance/static methods and getter/setter accessors preserve
      receivers, reject invalid brands and writes, support legal accessor pairing, and
      remain invisible to reflection. Undeclared names, duplicate declarations,
      `#constructor`, and static/instance collisions are early errors. The exact
      QuickJS `private_in` opcode implements field/method/accessor brand presence checks.
- [x] Synchronous iterators and `for..of`: Array, String, Map, Set, and user-defined
      iterables; fresh lexical cells; astral string code-point iteration; and
      IteratorClose for explicit `break`/`return`/`throw` and indirect runtime
      exceptions are implemented and verified. Focused ABAP Unit coverage includes
      inner catches, nested loops, and throwing destructuring defaults; the selected
      test262 slice includes generator closing, abrupt completion from catch bodies,
      and `var`/`let` destructuring-initializer failures.
- [ ] Generators by suspending the existing explicit frames.
      **Partial:** generator declarations and expressions, lazy invocation, explicit
      VM-frame suspension/resumption, `yield`/sent values/final returns, repeated
      completion, closure cells across suspension, and iterator self-identity are
      implemented. The exact QuickJS `yield` opcode and focused ABAP Unit coverage are
      in place. Generator instances use function-specific prototypes backed by shared
      `Generator`/`GeneratorFunction` intrinsic prototypes; generator methods work in
      classes (including static, computed, and private forms) and object literals.
      `.throw()` supports catch recovery, uncaught propagation through `finally`,
      yielding from catch/finally bodies, and correct never-started/completed state
      transitions. `.return(value)` supports suspended, never-started, and completed
      generators; it runs nested pending `finally` blocks, can suspend on a `yield` in
      `finally`, and honors a `return` or `throw` that overrides the injected completion.
      Focused ABAP Unit coverage exercises these abrupt-completion paths. Concise object
      methods now capture a home object for `super` lookup, including generator methods,
      and use the standard enumerable object-method descriptor. The 60-case
      GeneratorPrototype/language test262 expansion passes in full, covering intrinsic
      descriptors, receiver validation, re-entrant execution rejection, method `this`,
      iterator result objects, and nested abrupt completions. Focused ABAP Unit coverage
      independently exercises these intrinsic contracts and non-constructibility.
      Delegated `yield*`
      forwards sent values and `.return()`/`.throw()` completions, including yielding
      cleanup, missing-throw IteratorClose, and line-terminator grammar; six additional
      test262 cases pass. Explicit throws now close only iterators exited before their
      nearest local catch. Remaining generator work is broader conformance expansion and
      residual edge cases discovered by it.
- [ ] Promises + bounded microtask/job queue; async functions/`await`; then async
      generators if included in the profile.
- [ ] ES modules: parse/link/evaluate, host resolver/loader, import/export, and dynamic
      `import()`. Add module test262 harness support here.
- [ ] Direct `eval` and `Function` construction only if the Phase 0 profile includes
      them; verify their scope-resolution effects explicitly.
      **Partial:** `Function` construction uses global context bindings and is covered
      for parameter/body compilation and non-capture of caller locals; direct `eval`
      remains unimplemented.
- **Exit:** each enabled feature group has a named test262 denominator, pass rate, limits,
      and host-integration tests.

### Phase 7 — Regex & deterministic Unicode behavior
- [ ] Unicode: wire case conversion through the host adapter plus generated corrections;
      validate the pinned Unicode version and both hosts. Locale variants advertise only
      the locales actually supported. Use verified codepage adapters for UTF conversion.
- [ ] `String.prototype.normalize` stays absent/explicitly unsupported until real
      NFC/NFD/NFKC/NFKD support exists; never implement it as a no-op.
- [ ] `zcl_qjs_regexp` uses an **explicit PCRE adapter** (`create_pcre` or target
      equivalent), not the default regex mode. Run one adapter contract suite on Node
      and on-stack.
  - [ ] Translate supported JS escapes/classes/groups to the pinned PCRE dialect.
  - [ ] Map `i`/`m`/`s`/`u`; implement `g` and sticky `y` by exact start-position and
        `lastIndex` rules. Implement `d` only if reliable capture offsets are exposed.
  - [ ] Reject unsupported `v` constructs and other known gaps with `SyntaxError` rather
        than approximate them.
  - [ ] Implement `exec`/`test`/`Symbol.match`/`matchAll`/`replace`/`split`, capture and
        named-group objects, zero-length advancement, and `lastIndex` bookkeeping.
- **Exit:** the declared regex/Unicode profile passes its cross-host contract and test262
      subsets; engine/Unicode-version divergences are published.

### Phase 8 — Host-sensitive and remaining feature groups
- [ ] `Date` with a declared clock/time-zone adapter and deterministic tests.
- [ ] WeakMap/WeakSet/WeakRef/FinalizationRegistry only on targets whose weak-reference
      and forced-GC capabilities passed Phase 0; publish the ephemeron limitation.
- [ ] Evaluate and separately scope `Proxy`, TypedArray, ArrayBuffer, DataView, URI
      functions, and other remaining standard built-ins. Do not hide them inside a total
      pass-rate denominator.
- **Exit:** every feature is enabled, explicitly deferred, or explicitly unsupported in
      the profile manifest, with host capability requirements and test results.

### Phase 9 — Conformance, exact formatting, performance & packaging
- [ ] Optional faithful `dtoa.c`/`js_atod` port with `zcl_qjs_mpb`, exact rounding for
      FIXED/PRECISION and radix 2–36, and removal of the interim expected failures.
- [ ] Complete the evolving test262 runner for all enabled async/module features. Publish
      both the **raw** pass rate and the profile pass rate with unsupported/skip reasons.
- [ ] Differential fuzzing against pinned QuickJS and another engine; minimize and retain
      failures as regression tests.
- [ ] Performance: fast arrays, atom/shape inline caches with bounded ownership, fewer
      allocations, opcode tuning, and a reproducible benchmark suite.
- [ ] Documentation, versioned compatibility/profile manifest, examples, licensing, and
      optional `qjs`-style ABAP REPL report.
- **Exit:** documented, versioned engine with reproducible builds, enforced limits, a
      stated conformance profile, raw/profile test results, and dual-host release gates.

---

## 8. Testing & conformance strategy

- **Normalized reference oracle:** compile with the pinned, instrumented QuickJS helper
  and compare symbolic disassembly, constants, scopes, stack metadata, and behavior.
  Serialized byte arrays and numeric atom IDs are deliberately excluded.
- **Unit tests:** `CL_ABAP_UNIT_ASSERT` per class. Node/transpiler runs are frequent and
  fast; host-sensitive tests run on a real ABAP stack on a schedule and are mandatory
  release gates.
- **Recurring implementation gate:** every meaningful parser, VM, runtime, object-model,
  or built-in slice adds or extends focused ABAP Unit methods in the corresponding
  `*.testclasses.abap` source before its broader test262 cases are counted. Do not defer
  ABAP coverage until a phase is otherwise complete. Add focused ABAP Unit tests at
  regular checkpoints within long-running features—especially after new syntax,
  control-flow, or object-model behavior—then run the focused unit suite during
  development and the full `npm test` gate at each feature milestone.
- **Transpiler/open-abap anomaly log:** record every suspected toolchain divergence,
  host-semantic leak, unsupported construct, or required workaround in
  `ANORMALIES.md` when it is encountered. Each entry includes pinned versions, a minimal
  reproducer or originating test, expected and observed behavior, workaround, impact,
  and whether a real-ABAP comparison confirms or clears the anomaly. Engine defects and
  JavaScript conformance gaps stay in their implementation tests/profile rather than
  being mislabeled as toolchain anomalies.
- **Cross-host contract:** the host adapter has one shared suite for special Numbers,
  UTF-16/codepages, case mapping, regex, time zones, weak references/GC, and exceptions.
  A Node pass cannot waive a real-ABAP failure.
- **test262:** ingest it in Phase 0 and expand harness capabilities per phase. Report four
  outcomes separately: pass, fail, explicitly unsupported, and infrastructure skip.
  Publish both raw totals and totals within the declared zqjs profile; pin the test262
  commit so rates remain comparable.
- **Limit/adversarial tests:** infinite loops, deep syntax/calls, atom/property floods,
  huge source/bytecode, promise storms, and hostile regex inputs must terminate through
  the declared budget/error mechanism without an ABAP dump.
- **Differential fuzzing:** random small programs and generated bytecode compare against
  pinned QuickJS and a second engine; minimized failures become regression tests.

---

## 9. Milestones & rough effort

| Milestone | Capability | Rough scale |
|---|---|---|
| M0 (Phases 0–2) | Reproducible dual-host proof; first expression runs end-to-end under limits | weeks |
| M1 (Phase 3) | Core language, closures, explicit frames, and catchable exceptions | weeks–months |
| M2 (Phases 4–5) | Objects, host API, limits, marshalling, common built-ins → *usable embedded engine* | months |
| M3 (Phase 6) | Classes, generators, promises/async, modules | months |
| M4 (Phases 7–8) | Declared regex/Unicode and host-sensitive feature profiles | months–ongoing |
| M5 (Phase 9) | Exact formatting, broad conformance, performance and packaging | ongoing / multi-person-year to broad parity |

Estimates assume the C source is used as spec throughout. **M2 is the pragmatic
"ship something useful" line.**

---

## 10. Risks & mitigations

- **Performance** — inherent to an ABAP interpreter. *Mitigate:* benchmark the flat value
  representation before freezing it; later add bounded shape caches and fast arrays.
  Set expectations (light scripting, not compute).
- **JavaScript Number representation** — ABAP `f` cannot be assumed to preserve
  NaN/±Infinity/-0 and raises on operations JavaScript defines. *Mitigate:* explicit
  Number kinds plus one guarded numeric layer, with a cross-host special-value matrix and
  fuzzing from Phase 1.
- **Number formatting fidelity** — ABAP native float→string ≠ ECMAScript shortest
  round-trip. *Interim (chosen):* shortest-round-trip-by-search stopgap — correct for
  a named verified corpus, with documented expected failures. *Full fix (optional,
  Phase 9):* faithful `dtoa` + `zcl_qjs_mpb`; do **not** substitute `decfloat34`/`WRITE`.
- **UTF-16 correctness** — surrogate pairs, astral code points. *Mitigate:* explicit
  code-unit model and host probe; lone surrogates and code-unit access are correct from
  Phase 1 rather than hidden behind a BMP-only period.
- **GC does not reclaim reachable caches** — strong atom/shape/module tables can grow for
  the runtime lifetime even after value refcounting is removed. *Mitigate:* document
  ownership, use weak/bounded tables where valid, expose disposal, and enforce quotas.
- **Weak references** — target availability, forced-GC access, nondeterministic timing,
  and lack of ephemeron semantics prevent a universal implementation claim. *Mitigate:*
  capability-gate the entire weak profile, test the pinned adapter, publish the
  limitation, and never count unsupported forced-GC cases as passes.
- **Scope creep** — ES2025 is huge. *Mitigate:* phase gates, test262 pass-rate targets,
  a versioned feature/profile manifest, and explicit exclusions rather than an ambiguous
  “almost ES2025” claim.
- **Transpiler semantic masking** — Node can make code pass with JavaScript Numbers,
  RegExp, Unicode, or GC behavior that the ABAP kernel does not share. *Mitigate:* a
  host-adapter boundary, shared capability suite, and mandatory real-ABAP release gate.
- **Regex fidelity (PCRE shim)** — the chosen shim diverges from JS in edge cases
  (`u`/`v` Unicode semantics, sticky `y`, `d` indices, some class/escape differences),
  and behavior may differ between the transpiled-Node runtime and a real ABAP PCRE2
  stack. *Mitigate:* select PCRE explicitly, keep JS state semantics in the shim, use one
  cross-host contract, and reject unsupported constructs. Porting `libregexp` remains a
  fallback if a concrete requirement demands full fidelity.
- **Unicode via ABAP facilities** — `to_upper`/`to_lower` may diverge from JS full
  case mapping (`ß`→`SS`, final sigma, Turkish `i`), and `String.prototype.normalize`
  has no standard ABAP backing. *Mitigate:* pin the Unicode version, validate the full
  supported mapping, generate corrections, declare locale support, and leave normalize
  explicitly unsupported until it is real.
- **Native-recursion limits** — deep JS calls and hostile syntax. *Mitigate:* an explicit
  VM frame table from Phase 2 plus a separate parser-depth limit.
- **Version-bound bytecode/upstream drift** — QuickJS bytecode and internals change.
  *Mitigate:* pin release+commit, generate metadata, compare normalized disassembly, and
  rebase deliberately rather than promising serialized compatibility.

---

## 11. Recommended immediate next steps

1. Write the target/profile manifest and pin QuickJS release+commit, test262, Unicode,
   open-abap, npm dependencies, and the minimum real ABAP target.
2. Stand up both CI lanes, the host-capability probe, and minimal test262 reporting before
   relying on Node results for semantic claims.
3. Prototype and benchmark the flat value/special-Number representation, string backing,
   completion model, atom lifecycle, and limits on both hosts.
4. Generate opcodes/atoms/identifier ranges and build the normalized QuickJS disassembly
   helper.
5. Implement the `1 + 2 * 3` vertical slice under a step budget, then add control flow,
   functions/closures, and exceptions as successive end-to-end increments.

---

## 12. Sources

- QuickJS repository — <https://github.com/bellard/quickjs>
- QuickJS engine documentation (features, architecture, memory model) —
  <https://bellard.org/quickjs/quickjs.html>
- "QuickJS: An Overview and Guide to Adding a New Feature", Igalia —
  <https://blogs.igalia.com/compilers/2023/06/12/quickjs-an-overview-and-guide-to-adding-a-new-feature/>
- QuickJS internals (supplementary, non-authoritative) — <https://deepwiki.com/bellard/quickjs>
- abaplint / open-abap toolchain — <https://abaplint.org> · <https://github.com/open-abap>
- SAP ABAP numeric types —
  <https://help.sap.com/doc/abapdocu_740_index_htm/7.40/en-US/abenbuiltin_types_numeric.htm>
- SAP ABAP weak references —
  <https://help.sap.com/docs/SAP_NETWEAVER_AS_ABAP_752/7bfe8cdcfbb040dcb6702dada8c3e2f0/a221990a8f754fc083b3728cdec81dcc.html>
- SAP ABAP POSIX/PCRE selection —
  <https://help.sap.com/docs/ABAP_PLATFORM_NEW/b5670aaaa2364a29935f40b16499972d/ae4f0ab4f11f4c6fa8ecf59fb8823d74.html>
