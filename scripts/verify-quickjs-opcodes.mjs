import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const workspace = resolve(process.cwd());
const header = readFileSync(resolve(workspace, ".cache", "quickjs", "quickjs-opcode.h"), "utf8");
const expected = JSON.parse(readFileSync(resolve(workspace, "generated", "quickjs-opcodes.json"), "utf8"));
const abap = readFileSync(resolve(workspace, "src", "zif_qjs_opcodes.intf.abap"), "utf8");

const definitions = [];
for (const match of header.matchAll(/^(?:DEF|def)\(\s*([A-Za-z0-9_]+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*,\s*([A-Za-z0-9_]+)/gm)) {
  definitions.push({
    name: match[1],
    size: Number(match[2]),
    pops: Number(match[3]),
    pushes: Number(match[4]),
    format: match[5]
  });
}

for (const item of expected) {
  const index = definitions.findIndex(definition => definition.name === item.upstreamName);
  if (index < 0) {
    throw new Error(`QuickJS opcode ${item.upstreamName} is missing`);
  }
  const actual = { opcode: index, ...definitions[index] };
  for (const key of ["opcode", "size", "pops", "pushes", "format"]) {
    if (actual[key] !== item[key]) {
      throw new Error(`${item.upstreamName}.${key}: expected ${item[key]}, got ${actual[key]}`);
    }
  }
  const pattern = new RegExp(`CONSTANTS\\s+${item.abapName}\\s+TYPE i VALUE\\s+${item.opcode}\\.`, "i");
  if (!pattern.test(abap)) {
    throw new Error(`ABAP opcode ${item.abapName} does not match QuickJS value ${item.opcode}`);
  }
}

console.log(`verified ${expected.length} QuickJS opcode definitions`);

