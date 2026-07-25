import { createHash } from "node:crypto";
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import vm from "node:vm";

const fixturePath = resolve("fixtures", "zmjs-abaplint.js");
const fixture = readFileSync(fixturePath, "utf8");
const normalizedFixture = fixture.replaceAll("\r\n", "\n");
const expectedBlob = "81bd3b4c1aa2c56d44be1c9ffe4929a398da7d56";
const actualBlob = createHash("sha1")
  .update(`blob ${Buffer.byteLength(normalizedFixture)}\0`)
  .update(normalizedFixture)
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

await import("../output/init.mjs");
const { zcl_qjs } = await import("../output/zcl_qjs.clas.mjs");
const probeStarted = process.hrtime.bigint();
const zqjsSource = `
var __zqjsMessages = [];
var console = { log: function(value) { __zqjsMessages.push(String(value)); } };
${fixture}
__zqjsMessages.join("\\n");
`;
const zqjsResult = await zcl_qjs.eval({
  source: zqjsSource,
  max_steps: 100_000_000,
  max_objects: 250_000,
  max_frames: 64,
  max_operand_stack: 65_536
});
const zqjsMessages = (await zqjsResult.get().string_ref.get().as_string()).get();
if (zqjsMessages !== expectedMessages.join("\n")) {
  throw new Error(`unexpected zqjs abaplint output: ${JSON.stringify(zqjsMessages)}`);
}
const probeMs = Number(process.hrtime.bigint() - probeStarted) / 1_000_000;
console.log(`zmjs abaplint testcase runtime (zqjs): ${probeMs.toFixed(1)} ms`);
