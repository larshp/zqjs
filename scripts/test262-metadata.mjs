function inlineList(value) {
  const trimmed = value.trim();
  if (!trimmed.startsWith("[") || !trimmed.endsWith("]")) return [];
  return trimmed.slice(1, -1).split(",")
    .map(item => item.trim().replace(/^['"]|['"]$/g, ""))
    .filter(Boolean);
}

function inlineObject(value) {
  const result = {};
  const trimmed = value.trim();
  if (!trimmed.startsWith("{") || !trimmed.endsWith("}")) return result;
  for (const field of trimmed.slice(1, -1).split(",")) {
    const separator = field.indexOf(":");
    if (separator < 0) continue;
    result[field.slice(0, separator).trim()] = field.slice(separator + 1).trim()
      .replace(/^['"]|['"]$/g, "");
  }
  return result;
}

export function parseTest262Metadata(source) {
  const match = source.match(/\/\*---\s*\r?\n([\s\S]*?)\r?\n---\*\//);
  const metadata = { flags: [], features: [], includes: [], negative: null };
  if (!match) return { metadata, source };

  const lines = match[1].replaceAll("\r\n", "\n").split("\n");
  let section = "";
  for (let index = 0; index < lines.length; index += 1) {
    const line = lines[index];
    const top = line.match(/^([A-Za-z][A-Za-z0-9_-]*):\s*(.*)$/);
    if (top) {
      section = top[1];
      let value = top[2].trim();
      if (["flags", "features", "includes"].includes(section)) {
        while (value.startsWith("[") && !value.includes("]") && index + 1 < lines.length) {
          value += lines[index += 1].trim();
        }
        metadata[section] = inlineList(value);
      } else if (section === "negative") {
        metadata.negative = value ? inlineObject(value) : {};
      }
      continue;
    }
    const nested = line.match(/^\s+([A-Za-z][A-Za-z0-9_-]*):\s*(.*?)\s*$/);
    if (nested && section === "negative") {
      metadata.negative ??= {};
      metadata.negative[nested[1]] = nested[2].replace(/^['"]|['"]$/g, "");
    }
  }
  return {
    metadata,
    source: source.slice(0, match.index) + source.slice(match.index + match[0].length)
  };
}

export function stripJavaScriptComments(source) {
  let result = "";
  let quote = "";
  for (let index = 0; index < source.length;) {
    const current = source[index];
    const next = source[index + 1];
    if (quote) {
      result += current;
      if (current === "\\") {
        result += next ?? "";
        index += 2;
        continue;
      }
      if (current === quote) quote = "";
      index += 1;
    } else if (current === "'" || current === '"') {
      quote = current;
      result += current;
      index += 1;
    } else if (current === "/" && next === "/") {
      while (index < source.length && source[index] !== "\n") index += 1;
    } else if (current === "/" && next === "*") {
      index += 2;
      while (index < source.length && !(source[index] === "*" && source[index + 1] === "/")) index += 1;
      if (index < source.length) index += 2;
    } else {
      result += current;
      index += 1;
    }
  }
  return result;
}

export function unsupportedReasons(
  metadata,
  supportedFeatures = [],
  supportedFlags = []
) {
  const supported = new Set(supportedFeatures);
  const allowedFlags = new Set(supportedFlags);
  const reasons = metadata.features
    .filter(feature => !supported.has(feature))
    .map(feature => `unsupported feature: ${feature}`);
  for (const flag of metadata.flags) {
    if (["module", "async", "onlyStrict"].includes(flag)
        && !allowedFlags.has(flag)) {
      reasons.push(`unsupported flag: ${flag}`);
    }
  }
  return reasons;
}
