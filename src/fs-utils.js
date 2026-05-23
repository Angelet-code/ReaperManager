import fs from "node:fs";
import path from "node:path";

export function readJson(file, fallback = null) {
  try {
    return JSON.parse(fs.readFileSync(file, "utf8"));
  } catch (error) {
    if (error.code === "ENOENT") return fallback;
    throw error;
  }
}

export function writeJsonAtomic(file, data) {
  fs.mkdirSync(path.dirname(file), { recursive: true });
  const tmp = `${file}.${process.pid}.${Date.now()}.tmp`;
  fs.writeFileSync(tmp, `${JSON.stringify(data, null, 2)}\n`, "utf8");
  fs.renameSync(tmp, file);
}

export function copyFileAtomic(source, target) {
  fs.mkdirSync(path.dirname(target), { recursive: true });
  const tmp = `${target}.${process.pid}.${Date.now()}.tmp`;
  fs.copyFileSync(source, tmp);
  fs.renameSync(tmp, target);
}

export function timestamp() {
  return new Date().toISOString().replace(/[-:]/g, "").replace(/\..+/, "").replace("T", "-");
}

export function backupFile(file, backupDir) {
  if (!fs.existsSync(file)) return null;
  fs.mkdirSync(backupDir, { recursive: true });
  const target = path.join(backupDir, `${path.basename(file)}.${timestamp()}.bak`);
  fs.copyFileSync(file, target);
  return target;
}
