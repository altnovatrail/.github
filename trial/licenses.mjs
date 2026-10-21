// Trial (T22, never merged): what R19 asks of ci-licenses. Every package of package-lock.json,
// development tools too, has a license in ALLOWED_LICENSES, or is a named exception. The one
// exception is lightningcss and its builds for each platform, MPL-2.0: Vite's CSS minifier, a
// development tool that ships nothing, as R48 canvas-api excepts it. An expression is read only
// as identifiers joined by OR, which is all this lock file holds.
import fs from "node:fs";

const allowed = new Set((process.env.ALLOWED_LICENSES ?? "").split(",").filter(Boolean));
if (allowed.size === 0) {
  console.error("licenses: ALLOWED_LICENSES is not set; typescript.yml sets it.");
  process.exit(1);
}
const exceptions = [{ name: /^lightningcss(-[a-z0-9-]+)?$/, license: "MPL-2.0" }];

const lock = JSON.parse(fs.readFileSync("package-lock.json", "utf8"));
if (!lock.packages) {
  console.error("licenses: package-lock.json has no packages: it takes lockfileVersion 2 or later.");
  process.exit(1);
}
const refused = [];
let count = 0;
for (const [where, entry] of Object.entries(lock.packages)) {
  if (where === "" || entry.link) continue;
  count++;
  const name = entry.name ?? where.slice(where.lastIndexOf("node_modules/") + "node_modules/".length);
  const license = entry.license;
  if (!license) {
    refused.push(`${name}@${entry.version}: no license in the lock file`);
    continue;
  }
  if (license.replace(/[()]/g, "").split(/\s+OR\s+/).some((id) => allowed.has(id))) continue;
  if (entry.dev && exceptions.some((e) => e.name.test(name) && e.license === license)) continue;
  refused.push(`${name}@${entry.version}: ${license}`);
}
for (const line of refused) console.log(line);
console.log(`licenses: ${count} packages, ${refused.length} refused`);
process.exit(refused.length ? 1 : 0);
