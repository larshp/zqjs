import assert from "node:assert/strict";
import {
  parseTest262Metadata,
  stripJavaScriptComments,
  unsupportedReasons
} from "./test262-metadata.mjs";

const parsed = parseTest262Metadata(`/*---
flags: [noStrict]
features: [
  Symbol,
  BigInt
]
includes: [assert.js, sta.js]
negative:
  phase: parse
  type: SyntaxError
---*/
var value = "/* preserved */"; // removed
`);
assert.deepEqual(parsed.metadata.flags, ["noStrict"]);
assert.deepEqual(parsed.metadata.features, ["Symbol", "BigInt"]);
assert.deepEqual(parsed.metadata.includes, ["assert.js", "sta.js"]);
assert.deepEqual(parsed.metadata.negative, { phase: "parse", type: "SyntaxError" });
assert(!parsed.source.includes("flags:"));
assert.equal(
  stripJavaScriptComments(parsed.source).trim(),
  'var value = "/* preserved */";'
);
assert.deepEqual(
  unsupportedReasons(parsed.metadata, ["Symbol"]),
  ["unsupported feature: BigInt"]
);

const inlineNegative = parseTest262Metadata(`/*---
negative: { phase: runtime, type: TypeError }
---*/
null.x;
`);
assert.deepEqual(inlineNegative.metadata.negative, { phase: "runtime", type: "TypeError" });

console.log("test262 metadata parser: pass");
