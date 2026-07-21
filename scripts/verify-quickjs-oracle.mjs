import { readFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { resolve } from "node:path";
import assert from "node:assert/strict";

const workspace = resolve(process.cwd());
const fixture = JSON.parse(readFileSync(resolve(workspace, "generated", "quickjs-oracle.json"), "utf8"));
const executable = resolve(workspace, ".cache", "quickjs-oracle", process.platform === "win32" ? "qjs.exe" : "qjs");

function normalize(output) {
  const stackMatch = output.match(/^[ \t]*stack_size:[ \t]*(\d+)[ \t]*$/m);
  const opcodeHeader = output.match(/^[ \t]*opcodes:[ \t]*$/m);
  if (!stackMatch || !opcodeHeader) {
    throw new Error(`Unexpected QuickJS disassembly:\n${output}`);
  }
  const opcodeText = output.slice(opcodeHeader.index + opcodeHeader[0].length)
    .replace(/^\r?\n/, "").split(/\r?\n[ \t]*\r?\n/, 1)[0];
  const instructions = [];
  for (const raw of opcodeText.split(/\r?\n/)) {
    const line = raw.trim();
    if (!line || /^(set_loc\d*|put_loc\d*)\b.*"<ret>"$/.test(line)) continue;
    let match = line.match(/^push_(-?\d+)\s/);
    if (match) {
      instructions.push({ opcode: "push_i32", operand: Number(match[1]) });
      continue;
    }
    match = line.match(/^push_i32\s+(-?\d+)/);
    if (match) {
      instructions.push({ opcode: "push_i32", operand: Number(match[1]) });
      continue;
    }
    const opcode = line.split(/\s+/, 1)[0];
    const names = { mul: "multiply", sub: "subtract", div: "divide", neg: "negate" };
    instructions.push({ opcode: names[opcode] ?? opcode });
  }
  return { stackSize: Number(stackMatch[1]), instructions };
}

for (const item of fixture.cases) {
  const run = spawnSync(executable, ["-e", item.source], { encoding: "utf8" });
  if (run.status !== 0) {
    throw new Error(`QuickJS oracle failed for ${item.name}:\n${run.stderr}`);
  }
  assert.deepEqual(normalize(run.stdout), item.normalized, item.name);
}

console.log(`verified ${fixture.cases.length} normalized QuickJS oracle case(s)`);
