import test from "node:test";
import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import { mkdtempSync, readFileSync, rmSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";

for (const template of ["orquesta", "banda", "beat"]) {
  test(`new-piece: the ${template} scaffold runs and writes bridge commands`, () => {
    const dir = mkdtempSync(join(tmpdir(), `rm-piece-${template}-`));
    try {
      const made = spawnSync(process.execPath, ["scripts/new-piece.mjs", "--dir", dir, "--template", template, "--force"], { encoding: "utf8" });
      assert.equal(made.status, 0, made.stderr);
      const run = spawnSync(process.execPath, [join(dir, "piece.mjs")], { encoding: "utf8" });
      assert.equal(run.status, 0, run.stdout + run.stderr);
      assert.match(run.stdout, /errors: 0/);
      const build = JSON.parse(readFileSync(join(dir, "out", "build.json"), "utf8"));
      assert.equal(build.type, "build_beat");
      assert.ok(build.tracks.length >= 5);
      const midi = JSON.parse(readFileSync(join(dir, "out", "midi.json"), "utf8"));
      assert.ok(Object.keys(midi).length >= 4);
    } finally {
      rmSync(dir, { recursive: true, force: true });
    }
  });
}
