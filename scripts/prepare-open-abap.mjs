import { existsSync, mkdirSync, readFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { spawnSync } from "node:child_process";

const workspace = resolve(process.cwd());
const lock = JSON.parse(readFileSync(resolve(workspace, "upstream-lock.json"), "utf8"));
const target = resolve(workspace, ".cache", "open-abap-core");
const expected = lock.openAbapCore.commit;

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
  git(["remote", "add", "origin", lock.openAbapCore.repository], target);
}

let actual = "";
try {
  actual = git(["rev-parse", "HEAD"], target, true);
} catch {
  actual = "";
}

if (actual !== expected) {
  git(["fetch", "--quiet", "--depth", "1", "origin", expected], target);
  git(["checkout", "--quiet", "--detach", "FETCH_HEAD"], target);
  actual = git(["rev-parse", "HEAD"], target, true);
}

if (actual !== expected) {
  throw new Error(`open-abap-core pin mismatch: expected ${expected}, got ${actual}`);
}

console.log(`open-abap-core ${actual}`);

