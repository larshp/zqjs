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
