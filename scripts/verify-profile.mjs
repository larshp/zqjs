import { readFileSync } from "node:fs";
import { resolve } from "node:path";

const workspace = resolve(process.cwd());
const readJson = path => JSON.parse(readFileSync(resolve(workspace, path), "utf8"));
const profile = readJson("compatibility-profile.json");
const packageJson = readJson("package.json");
const lock = readJson("upstream-lock.json");
const test262 = readJson(profile.conformance?.test262?.selectionFile ?? "");

const failures = [];
const check = (condition, message) => {
  if (!condition) failures.push(message);
};
const equal = (actual, expected, label) =>
  check(actual === expected, `${label}: expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);

equal(profile.schemaVersion, 1, "profile schemaVersion");
equal(profile.profileVersion, packageJson.version, "profile/package version");
equal(profile.languageTarget.quickjsRelease, lock.quickjs.release, "QuickJS release pin");
equal(profile.pins.quickjsCommit, lock.quickjs.commit, "QuickJS commit pin");
equal(profile.pins.test262Commit, lock.test262.commit, "test262 commit pin");
equal(profile.pins.openAbapCoreCommit, lock.openAbapCore.commit, "open-abap-core commit pin");
equal(profile.pins.unicodeVersion, lock.unicode.version, "Unicode version pin");
equal(`>=${profile.hosts.development.minimumVersion}`, packageJson.engines.node, "Node minimum");

const selected = test262.tests?.length ?? -1;
const expected = profile.conformance.test262.expected;
equal(selected, profile.conformance.test262.selected, "test262 selected count");
equal(
  expected.pass + expected.fail + expected.unsupported + expected.infrastructureSkip,
  selected,
  "test262 outcome denominator"
);
check(expected.fail === 0, "published profile baseline must not contain expected failures");

const allowedStatuses = new Set(["enabled", "partial", "deferred", "unsupported", "conditional"]);
for (const [feature, status] of Object.entries(profile.features ?? {})) {
  check(allowedStatuses.has(status), `feature ${feature} has invalid status ${JSON.stringify(status)}`);
}
for (const requiredFeature of [
  "scripts",
  "directEval",
  "withStatement",
  "annexB",
  "bigInt",
  "intl",
  "sharedArrayBufferAtomics",
  "classes",
  "generators",
  "promises",
  "asyncFunctions",
  "asyncGenerators",
  "modules",
  "regexp",
  "proxy",
  "typedArrays",
  "arrayBufferDataView",
  "date",
  "weakReferences"
]) {
  check(requiredFeature in (profile.features ?? {}), `profile omits feature ${requiredFeature}`);
}
check(profile.hosts.abap.unicodeOnly === true, "ABAP profile must require Unicode");
check(profile.hosts.abap.minimumSapBasis !== "", "minimum SAP_BASIS must be recorded");
check(profile.hosts.abap.releaseGate === "required-unverified", "real-ABAP release gate must remain explicit until verified");

if (failures.length) {
  for (const failure of failures) console.error(failure);
  process.exitCode = 1;
} else {
  console.log(
    `verified compatibility profile ${profile.profileVersion}: ` +
      `${selected} test262 cases, ${Object.keys(profile.features).length} feature declarations`
  );
}
