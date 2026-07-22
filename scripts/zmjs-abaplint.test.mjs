import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import vm from "node:vm";

const fixturePath = resolve("fixtures", "zmjs-abaplint.js");
const fixture = readFileSync(fixturePath, "utf8");
const expectedBlob = "81bd3b4c1aa2c56d44be1c9ffe4929a398da7d56";
const actualBlob = createHash("sha1")
  .update(`blob ${Buffer.byteLength(fixture)}\0`)
  .update(fixture)
  .digest("hex");

if (actualBlob !== expectedBlob) {
  throw new Error(
    `zmjs abaplint fixture mismatch: expected ${expectedBlob}, got ${actualBlob}`
  );
}

const messages = [];
const started = process.hrtime.bigint();
new vm.Script(fixture, { filename: fixturePath }).runInNewContext({
  console: { log: value => messages.push(String(value)) }
});
const elapsedMs = Number(process.hrtime.bigint() - started) / 1_000_000;

const expectedMessages = [
  "Running statement parser...",
  "Tokens: 3",
  "Statements: 1",
  "Done"
];
if (JSON.stringify(messages) !== JSON.stringify(expectedMessages)) {
  throw new Error(`unexpected zmjs abaplint output: ${JSON.stringify(messages)}`);
}

console.log(`zmjs abaplint testcase runtime (Node reference): ${elapsedMs.toFixed(1)} ms`);

// zqjs cannot execute this fixture yet because it contains RegExp literals;
// keep that compatibility boundary visible until the RegExp phase lands.
await import("../output/init.mjs");
const { zcl_qjs } = await import("../output/zcl_qjs.clas.mjs");
const probeStarted = process.hrtime.bigint();
try {
  await zcl_qjs.compile({ source: fixture });
  throw new Error("zqjs unexpectedly compiled the RegExp-dependent fixture");
} catch (error) {
  const reason = error?.reason?.value ?? String(error);
  if (reason !== "Unexpected character in JavaScript source") throw error;
}
const probeMs = Number(process.hrtime.bigint() - probeStarted) / 1_000_000;
console.log(`zmjs abaplint zqjs capability probe: RegExp unsupported (${probeMs.toFixed(1)} ms)`);
