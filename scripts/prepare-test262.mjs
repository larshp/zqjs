import { existsSync, mkdirSync, readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { spawnSync } from "node:child_process";

const workspace = resolve(process.cwd());
const lock = JSON.parse(readFileSync(resolve(workspace, "upstream-lock.json"), "utf8"));
const target = resolve(workspace, ".cache", "test262");
const expected = lock.test262.commit;

function git(args, cwd = workspace, capture = false) {
  const result = spawnSync("git", args, {
    cwd,
    encoding: "utf8",
    stdio: capture ? "pipe" : "inherit"
  });
  if (result.status !== 0) {
    throw new Error(`git ${args.join(" ")} failed${capture ? `: ${result.stderr}` : ""}`);
  }
  return capture ? result.stdout.trim() : "";
}

if (!existsSync(resolve(target, ".git"))) {
  if (existsSync(target)) {
    throw new Error(`${target} exists but is not a git checkout; remove it manually`);
  }
  mkdirSync(dirname(target), { recursive: true });
  mkdirSync(target);
  git(["init", "--quiet"], target);
  git(["remote", "add", "origin", lock.test262.repository], target);
  git(["sparse-checkout", "init", "--cone"], target);
}

git(["sparse-checkout", "set", "harness",
  "test/built-ins/JSON/parse",
  "test/built-ins/JSON/stringify",
  "test/built-ins/Math/round",
  "test/built-ins/Math/abs",
  "test/built-ins/Math/ceil",
  "test/built-ins/Math/floor",
  "test/built-ins/Math/exp",
  "test/built-ins/Math/log",
  "test/built-ins/Math/log10",
  "test/built-ins/Math/log2",
  "test/built-ins/Math/max",
  "test/built-ins/Math/min",
  "test/built-ins/Math/E",
  "test/built-ins/Math/LN10",
  "test/built-ins/Math/LN2",
  "test/built-ins/Math/LOG10E",
  "test/built-ins/Math/LOG2E",
  "test/built-ins/Math/PI",
  "test/built-ins/Math/SQRT1_2",
  "test/built-ins/Math/SQRT2",
  "test/built-ins/Math/sign",
  "test/built-ins/Math/sqrt",
  "test/built-ins/Math/sin",
  "test/built-ins/Math/cos",
  "test/built-ins/Math/tan",
  "test/built-ins/Math/pow",
  "test/built-ins/Math/cbrt",
  "test/built-ins/Math/expm1",
  "test/built-ins/Math/log1p",
  "test/built-ins/Math/atan",
  "test/built-ins/Math/asin",
  "test/built-ins/Math/acos",
  "test/built-ins/Math/atan2",
  "test/built-ins/Math/sinh",
  "test/built-ins/Math/cosh",
  "test/built-ins/Math/tanh",
  "test/built-ins/Math/asinh",
  "test/built-ins/Math/acosh",
  "test/built-ins/Math/atanh",
  "test/built-ins/Math/clz32",
  "test/built-ins/Math/imul",
  "test/built-ins/Math/hypot",
  "test/built-ins/Math/fround",
  "test/built-ins/Math/f16round",
  "test/built-ins/Math/random",
  "test/built-ins/Math/trunc",
  "test/built-ins/Array/prototype/pop",
  "test/built-ins/Array/prototype/push",
  "test/built-ins/Array/prototype/join",
  "test/built-ins/Array/prototype/indexOf",
  "test/built-ins/Array/prototype/includes",
  "test/built-ins/Array/prototype/shift",
  "test/built-ins/Array/prototype/unshift",
  "test/built-ins/Array/prototype/reverse",
  "test/built-ins/Array/prototype/lastIndexOf",
  "test/built-ins/Array/prototype/at",
  "test/built-ins/Array/prototype/slice",
  "test/built-ins/Array/prototype/forEach",
  "test/built-ins/Array/prototype/map",
  "test/built-ins/Array/prototype/filter",
  "test/built-ins/Array/prototype/some",
  "test/built-ins/Array/prototype/every",
  "test/built-ins/Array/prototype/find",
  "test/built-ins/Array/prototype/findIndex",
  "test/built-ins/Array/prototype/reduce",
  "test/built-ins/Array/prototype/reduceRight",
  "test/built-ins/Array/prototype/fill",
  "test/built-ins/Array/prototype/copyWithin",
  "test/built-ins/Number/isFinite",
  "test/built-ins/Number/isInteger",
  "test/built-ins/Number/isNaN",
  "test/built-ins/Number/isSafeInteger",
  "test/built-ins/Object/assign",
  "test/built-ins/Object/entries",
  "test/built-ins/Object/hasOwn",
  "test/built-ins/Object/is",
  "test/built-ins/Object/getOwnPropertySymbols",
  "test/built-ins/Object/values",
  "test/built-ins/Symbol",
  "test/built-ins/isFinite",
  "test/built-ins/parseFloat",
  "test/built-ins/parseInt",
  "test/built-ins/encodeURI",
  "test/built-ins/encodeURIComponent",
  "test/built-ins/decodeURI",
  "test/built-ins/decodeURIComponent",
  "test/built-ins/Function",
  "test/language/expressions/addition",
  "test/language/expressions/bitwise-and",
  "test/language/expressions/compound-assignment",
  "test/language/expressions/left-shift",
  "test/language/expressions/logical-and",
  "test/language/expressions/postfix-increment"], target);

let actual = "";
try {
  actual = git(["rev-parse", "HEAD"], target, true);
} catch {
  actual = "";
}

if (actual !== expected) {
  git(["fetch", "--quiet", "--depth", "1", "--filter=blob:none", "origin", expected], target);
  git(["checkout", "--quiet", "--detach", "FETCH_HEAD"], target);
  actual = git(["rev-parse", "HEAD"], target, true);
}

if (actual !== expected) {
  throw new Error(`test262 pin mismatch: expected ${expected}, got ${actual}`);
}

console.log(`test262 ${actual}`);
