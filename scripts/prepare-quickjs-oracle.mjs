import { cpSync, existsSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { resolve } from "node:path";

const workspace = resolve(process.cwd());
const source = resolve(workspace, ".cache", "quickjs");
const target = resolve(workspace, ".cache", "quickjs-oracle");
const lock = JSON.parse(readFileSync(resolve(workspace, "upstream-lock.json"), "utf8"));
const commit = lock.quickjs.commit;
const marker = resolve(target, ".zqjs-oracle-commit");
const executable = resolve(target, process.platform === "win32" ? "qjs.exe" : "qjs");

if (!existsSync(source)) {
  throw new Error("Pinned QuickJS source is missing; run prepare:quickjs first");
}

if (existsSync(executable) && existsSync(marker)
    && readFileSync(marker, "utf8").trim() === commit) {
  console.log(`QuickJS oracle ${commit}`);
  process.exit(0);
}

rmSync(target, { recursive: true, force: true });
cpSync(source, target, {
  recursive: true,
  filter(path) {
    const relative = path.slice(source.length).replaceAll("\\", "/");
    return !relative.startsWith("/.git")
      && !relative.startsWith("/.obj")
      && relative !== "/qjs"
      && relative !== "/qjs.exe"
      && relative !== "/qjsc"
      && relative !== "/qjsc.exe"
      && relative !== "/repl.c";
  }
});

const enginePath = resolve(target, "quickjs.c");
const engine = readFileSync(enginePath, "utf8");
const patched = engine.replace("//#define DUMP_BYTECODE  (1)", "#define DUMP_BYTECODE  (1)");
if (patched === engine) {
  throw new Error("Pinned QuickJS bytecode-dump switch was not found");
}
writeFileSync(enginePath, patched);

let build;
if (process.platform === "win32") {
  const bashCandidates = [
    "C:\\msys64\\usr\\bin\\bash.exe",
    "C:\\Program Files\\Git\\bin\\bash.exe"
  ];
  const bash = bashCandidates.find(existsSync);
  if (!bash) {
    throw new Error("Building the QuickJS oracle on Windows requires MSYS2 or Git Bash");
  }
  const unixTarget = target.replace(/^([A-Za-z]):/, (_, drive) => `/${drive.toLowerCase()}`).replaceAll("\\", "/");
  build = spawnSync(bash, ["-lc", `export PATH=/mingw64/bin:/usr/bin:$PATH; cd '${unixTarget}' && make qjs.exe`], {
    encoding: "utf8",
    env: { ...process.env, MSYSTEM: "MINGW64" }
  });
} else {
  build = spawnSync("make", ["qjs"], { cwd: target, encoding: "utf8" });
}

if (build.status !== 0) {
  throw new Error(`QuickJS oracle build failed:\n${build.stdout}\n${build.stderr}`);
}
writeFileSync(marker, `${commit}\n`);
console.log(`QuickJS oracle ${commit}`);
