import { rmSync } from "node:fs";
import { dirname, resolve } from "node:path";

const workspace = resolve(process.cwd());
const output = resolve(workspace, "output");

if (dirname(output) !== workspace) {
  throw new Error(`Refusing to clean unexpected path: ${output}`);
}

rmSync(output, { recursive: true, force: true });

