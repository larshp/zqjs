import { existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";
import { spawnSync } from "node:child_process";
import {
  parseTest262Metadata,
  stripJavaScriptComments,
  unsupportedReasons
} from "./test262-metadata.mjs";

const workspace = resolve(process.cwd());
const config = JSON.parse(readFileSync(resolve(workspace, "test262-smoke.json"), "utf8"));
const lock = JSON.parse(readFileSync(resolve(workspace, "upstream-lock.json"), "utf8"));
const checkout = resolve(workspace, ".cache", "test262");
const baseHarness = `
function Test262Error(message) { this.message = message; }
function __zqjsSameValue(actual, expected, message) {
  if (actual === expected) {
    if (actual === 0 && 1 / actual !== 1 / expected) {
      throw new Test262Error(message);
    }
    return;
  }
  if (actual !== actual && expected !== expected) return;
  throw new Test262Error(message);
}
function __zqjsNotSameValue(actual, unexpected, message) {
  if (actual === unexpected
      && !(actual === 0 && 1 / actual !== 1 / unexpected)) {
    throw new Test262Error(message);
  }
}
function assert(mustBeTrue, message) {
  if (!mustBeTrue) throw new Test262Error(message);
}
assert.sameValue = __zqjsSameValue;
assert.notSameValue = __zqjsNotSameValue;
assert.compareArray = function (actual, expected, message) {
  if (actual.length !== expected.length) throw new Test262Error(message);
  for (var index = 0; index < actual.length; index++) {
    __zqjsSameValue(actual[index], expected[index], message);
  }
};
`;

function git(args) {
  const result = spawnSync("git", args, { cwd: checkout, encoding: "utf8" });
  if (result.status !== 0) throw new Error(result.stderr.trim());
  return result.stdout.trim();
}

function normalizeTest(entry) {
  if (typeof entry === "string") {
    return { path: entry, expectedOutcome: config.expectedOutcome ?? "pass" };
  }
  return {
    path: entry.path ?? entry.test,
    expectedOutcome: entry.expectedOutcome ?? config.expectedOutcome ?? "pass"
  };
}

function errorText(error) {
  const parts = [error?.name, error?.message, error?.constructor?.name];
  for (const value of [error?.reason, error?.value]) {
    if (typeof value === "string") parts.push(value);
    else if (typeof value?.value === "string") parts.push(value.value);
  }
  return parts.filter(Boolean).join(": ");
}

function expectedErrorMatches(error, type, phase) {
  if (!type) return true;
  const text = errorText(error);
  if (text.includes(type)) return true;
  return phase === "parse" && type === "SyntaxError"
    && error?.constructor?.name === "zcx_qjs_error";
}

function emitResult(actualCommit, test, outcome, reason = "") {
  const result = { commit: actualCommit, test, outcome };
  if (reason) result.reason = reason;
  console.log(JSON.stringify(result));
}

function loadHarness(metadata) {
  const sources = [];
  for (const include of metadata.includes) {
    const path = resolve(checkout, "harness", include);
    if (!existsSync(path)) return { reason: `missing harness include: ${include}` };
    sources.push(readFileSync(path, "utf8"));
  }
  return { source: sources.join("\n") };
}

const actualCommit = git(["rev-parse", "HEAD"]);
if (actualCommit !== lock.test262.commit) {
  throw new Error(`test262 pin mismatch: expected ${lock.test262.commit}, got ${actualCommit}`);
}

await import("../output/init.mjs");
const { zcl_qjs } = await import("../output/zcl_qjs.clas.mjs");
let mismatches = 0;
const totals = { pass: 0, fail: 0, unsupported: 0, "infrastructure-skip": 0 };

for (const configured of config.tests) {
  const test = normalizeTest(configured);
  const fixture = resolve(checkout, test.path);
  let outcome = "pass";
  let reason = "";

  if (!test.path || !existsSync(fixture)) {
    outcome = "infrastructure-skip";
    reason = test.path ? "fixture is missing" : "test path is missing";
  } else {
    const raw = readFileSync(fixture, "utf8").replaceAll("\r\n", "\n");
    const parsed = parseTest262Metadata(raw);
    const unsupported = unsupportedReasons(parsed.metadata, config.supportedFeatures ?? []);
    if (unsupported.length) {
      outcome = "unsupported";
      reason = unsupported.join("; ");
    } else {
      const harness = loadHarness(parsed.metadata);
      if (harness.reason) {
        outcome = "infrastructure-skip";
        reason = harness.reason;
      } else {
        const source = stripJavaScriptComments(
          `${baseHarness}\n${harness.source}\n${parsed.source}`
        );
        const negative = parsed.metadata.negative;
        if (negative && !["parse", "runtime"].includes(negative.phase)) {
          outcome = "unsupported";
          reason = `unsupported negative phase: ${negative.phase ?? "unspecified"}`;
        } else if (negative?.phase === "parse") {
          try {
            await zcl_qjs.compile({ source });
            outcome = "fail";
            reason = `expected parse ${negative.type ?? "error"}`;
          } catch (error) {
            if (!expectedErrorMatches(error, negative.type, "parse")) {
              outcome = "fail";
              reason = `wrong parse error: ${errorText(error)}`;
            }
          }
        } else if (negative?.phase === "runtime") {
          try {
            await zcl_qjs.compile({ source });
          } catch (error) {
            outcome = "fail";
            reason = `unexpected parse error: ${errorText(error)}`;
          }
          if (outcome === "pass") {
            try {
              await zcl_qjs.eval({ source, max_steps: 100000 });
              outcome = "fail";
              reason = `expected runtime ${negative.type ?? "error"}`;
            } catch (error) {
              if (!expectedErrorMatches(error, negative.type, "runtime")) {
                outcome = "fail";
                reason = `wrong runtime error: ${errorText(error)}`;
              }
            }
          }
        } else {
          try {
            await zcl_qjs.eval({ source, max_steps: 100000 });
          } catch (error) {
            outcome = "fail";
            reason = errorText(error);
          }
        }
      }
    }
  }

  totals[outcome] += 1;
  emitResult(actualCommit, test.path ?? "", outcome, reason);
  if (outcome !== test.expectedOutcome) {
    mismatches += 1;
    console.error(`expected ${test.expectedOutcome}, got ${outcome}: ${test.path}`);
  }
}

console.log(JSON.stringify({ commit: actualCommit, totals }));
if (mismatches) process.exitCode = 1;
