import fs from "node:fs";
import path from "node:path";
import {
  buildAddFxCommand,
  buildAdjustVolumeCommand,
  buildAutoBalanceCommand,
  buildColorTracksCommand,
  buildCopyBalanceCommand,
  buildCreateReturnsCommand,
  buildCreateTracksCommand,
  buildDeleteTracksCommand,
  buildDetectArrangementCommand,
  buildFolderCommand,
  buildFxBypassCommand,
  buildGainStageCommand,
  buildInspectProjectCommand,
  buildItemVolumeCommand,
  buildPanCommand,
  buildRemoveFxCommand,
  buildRenameCommand,
  buildRockTemplateCommand,
  buildRouteToBusCommand,
  buildSendVolumeCommand,
  buildSelectTracksCommand,
  buildSelectItemsCommand,
  buildTrackStateCommand,
  buildVocalLevelCommand,
  normalizeCommand
} from "./commands.js";
import { inferRootFromChatRequest, processChatRequestFile, runChatText } from "./chat.js";
import { enqueueCommand, readStatus, waitForResponse } from "./client.js";
import { install } from "./installer.js";
import { loadPluginEntries, writePluginCache } from "./plugin-cache.js";
import { loadPreferences, savePreferences } from "./preferences.js";
import { parseNatural } from "./natural.js";
import { pluginCachePath, reaperResourcePath, workspaceRoot } from "./paths.js";
import { prepareReferenceHierarchy } from "./reference-stems.js";

export async function main(argv) {
  const [command, ...rest] = argv;
  const root = workspaceRoot();

  switch (command) {
    case "install":
      return printInstallReport(install({ root }));
    case "status":
      return printJson(readStatus(root));
    case "inspect-project":
      return inspectProjectCommand(rest, root);
    case "detect-arrangement":
      return detectArrangementCommand(rest, root);
    case "auto-balance":
      return autoBalanceCommand(rest, root);
    case "scan-plugins":
      return printJson({
        resourcePath: reaperResourcePath(),
        pluginCachePath: pluginCachePath(root),
        count: writePluginCache(root).length
      });
    case "prefs":
      return prefsCommand(rest, root);
    case "send":
      return sendCommand(rest, root);
    case "ask":
      return askCommand(rest, root);
    case "chat":
      return chatCommand(rest, root);
    case "color":
      return colorCommand(rest, root);
    case "returns":
      return returnsCommand(rest, root);
    case "add-fx":
      return addFxCommand(rest, root);
    case "remove-fx":
      return removeFxCommand(rest, root);
    case "delete-tracks":
      return deleteTracksCommand(rest, root);
    case "select":
    case "select-tracks":
      return selectTracksCommand(rest, root);
    case "select-items":
      return selectItemsCommand(rest, root);
    case "volume":
      return volumeCommand(rest, root);
    case "pan":
      return panCommand(rest, root);
    case "copy-balance":
    case "copy-track-balance":
      return copyBalanceCommand(rest, root);
    case "send-volume":
      return sendVolumeCommand(rest, root);
    case "item-volume":
      return itemVolumeCommand(rest, root);
    case "gain-stage":
      return gainStageCommand(rest, root);
    case "vocal-level":
      return vocalLevelCommand(rest, root);
    case "track-state":
      return trackStateCommand(rest, root);
    case "rename":
      return renameCommand(rest, root);
    case "create-tracks":
      return createTracksCommand(rest, root);
    case "folder":
      return folderCommand(rest, root);
    case "route-to-bus":
      return routeToBusCommand(rest, root);
    case "fx-bypass":
      return fxBypassCommand(rest, root);
    case "rock-template":
      return rockTemplateCommand(rest, root);
    case "ping":
      return runBuiltCommand({ type: "ping" }, root);
    case "shutdown":
      return runBuiltCommand({ type: "shutdown" }, root);
    case undefined:
    case "help":
    case "--help":
    case "-h":
      return printHelp();
    default:
      throw new Error(`Unknown command "${command}". Run "reaper-manager help".`);
  }
}

function commonContext(root) {
  const prefs = loadPreferences(root);
  return {
    prefs,
    aliases: prefs.aliases,
    pluginEntries: loadPluginEntries(root)
  };
}

async function sendCommand(args, root) {
  const options = parseOptions(args);
  const raw = options._.join(" ");
  const command = readCommandJson(raw);
  return runBuiltCommand(normalizeCommand(command, commonContext(root)), root, options);
}

async function askCommand(args, root) {
  const options = parseOptions(args);
  const text = options._.join(" ");
  const context = commonContext(root);
  return runBuiltCommand(parseNatural(text, context), root, options);
}

async function chatCommand(args, root) {
  const options = parseOptions(args);
  const chatRoot = options.request ? inferRootFromChatRequest(options.request) || root : root;
  const response = options.request
    ? await processChatRequestFile(options.request, { root: chatRoot, timeout: options.timeout })
    : await runChatText(options._.join(" "), { root: chatRoot, timeout: options.timeout });
  printJson(response);
}

async function inspectProjectCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildInspectProjectCommand(options), root, options);
}

async function detectArrangementCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildDetectArrangementCommand(options), root, {
    ...options,
    timeout: options.timeout || 180000
  });
}

async function autoBalanceCommand(args, root) {
  const options = parseOptions(args);
  const inspectResponse = await runCommandForResponse(buildInspectProjectCommand(), root, {
    timeout: options.inspectTimeout || options["inspect-timeout"] || options.timeout || 60000
  });
  if (!inspectResponse.ok) throw new Error(inspectResponse.error || "inspect-project failed.");

  const referenceHierarchy = prepareReferenceHierarchy(inspectResponse.data, {
    force: Boolean(options.forceStems || options["force-stems"]),
    stemModel: options.stemModel || options["stem-model"] || options.model,
    demucsPython: options.demucsPython || options["demucs-python"] || options.python,
    stemTimeout: options.stemTimeout || options["stem-timeout"],
    sampleStride: options.sampleStride || options["sample-stride"],
    topWindowPercent: options.topWindowPercent || options["top-window-percent"],
    windowMs: options.windowMs || options["window-ms"],
    silenceDb: options.silenceDb || options["silence-db"]
  });

  return runBuiltCommand(
    buildAutoBalanceCommand({ ...options, referenceHierarchy, balanceSections: referenceHierarchy.projectSections }),
    root,
    options
  );
}

async function returnsCommand(args, root) {
  const options = parseOptions(args);
  const context = commonContext(root);
  return runBuiltCommand(
    buildCreateReturnsCommand({
      count: options.count || options.n || 1,
      fx: options.fx || options.plugin || "RVerb",
      from: options.from,
      prefs: context.prefs,
      aliases: context.aliases,
      pluginEntries: context.pluginEntries
    }),
    root,
    options
  );
}

async function addFxCommand(args, root) {
  const options = parseOptions(args);
  const context = commonContext(root);
  return runBuiltCommand(
    buildAddFxCommand({
      contains: options.contains,
      selected: Boolean(options.selected),
      fx: options.fx || options.plugin,
      aliases: context.aliases,
      pluginEntries: context.pluginEntries
    }),
    root,
    options
  );
}

async function removeFxCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildRemoveFxCommand(options), root, options);
}

async function deleteTracksCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildDeleteTracksCommand(options), root, options);
}

async function selectTracksCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildSelectTracksCommand(options), root, options);
}

async function selectItemsCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildSelectItemsCommand(options), root, options);
}

async function volumeCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildAdjustVolumeCommand(options), root, options);
}

async function panCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildPanCommand(options), root, options);
}

async function copyBalanceCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildCopyBalanceCommand(options), root, options);
}

async function sendVolumeCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildSendVolumeCommand(options), root, options);
}

async function itemVolumeCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildItemVolumeCommand(options), root, options);
}

async function gainStageCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildGainStageCommand(options), root, options);
}

async function vocalLevelCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildVocalLevelCommand(options), root, options);
}

async function trackStateCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildTrackStateCommand(options), root, options);
}

async function renameCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildRenameCommand(options), root, options);
}

async function createTracksCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildCreateTracksCommand(options), root, options);
}

async function folderCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildFolderCommand(options), root, options);
}

async function routeToBusCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildRouteToBusCommand(options), root, options);
}

async function fxBypassCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildFxBypassCommand(options), root, options);
}

async function rockTemplateCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildRockTemplateCommand(options), root, options);
}

async function colorCommand(args, root) {
  const options = parseOptions(args);
  return runBuiltCommand(buildColorTracksCommand(options), root, options);
}

async function runBuiltCommand(command, root, options = {}) {
  const response = await runCommandForResponse(command, root, options);
  if (options.wait === false || options["no-wait"]) return;
  printJson(response);
}

async function runCommandForResponse(command, root, options = {}) {
  const id = enqueueCommand(command, { root });
  console.log(`Queued ${id}: ${command.type}`);
  if (options.wait === false || options["no-wait"]) return null;

  return waitForResponse(id, {
    root,
    timeoutMs: Number(options.timeout || 60000)
  });
}

function prefsCommand(args, root) {
  const [subcommand, key, value] = args;
  const prefs = loadPreferences(root);

  if (!subcommand || subcommand === "get") {
    return printJson(prefs);
  }

  if (subcommand === "set") {
    if (key !== "defaultSendSource") {
      throw new Error("Supported preference: defaultSendSource");
    }
    if (!["selected", "none", "all-audio", "null"].includes(value)) {
      throw new Error("defaultSendSource must be selected, none, all-audio, or null.");
    }
    prefs.defaultSendSource = value === "null" ? null : value;
    savePreferences(root, prefs);
    return printJson(prefs);
  }

  throw new Error(`Unknown prefs command "${subcommand}".`);
}

function readCommandJson(raw) {
  if (!raw) throw new Error("Missing JSON command.");
  if (fs.existsSync(raw)) {
    return JSON.parse(fs.readFileSync(raw, "utf8"));
  }
  return JSON.parse(raw);
}

export function parseOptions(args) {
  const out = { _: [] };
  for (let i = 0; i < args.length; i += 1) {
    const arg = args[i];
    if (!arg.startsWith("--")) {
      out._.push(arg);
      continue;
    }

    const eq = arg.indexOf("=");
    if (eq !== -1) {
      out[arg.slice(2, eq)] = arg.slice(eq + 1);
      continue;
    }

    const key = arg.slice(2);
    const next = args[i + 1];
    if (!next || next.startsWith("--")) {
      out[key] = true;
    } else {
      out[key] = next;
      i += 1;
    }
  }
  return out;
}

function printInstallReport(report) {
  printJson(report);
}

function printJson(data) {
  console.log(JSON.stringify(data, null, 2));
}

function printHelp() {
  const bin = path.join(".", "bin", "reaper-manager.js");
  console.log(`Usage:
  node ${bin} install
  node ${bin} status
  node ${bin} inspect-project
  node ${bin} detect-arrangement
  node ${bin} auto-balance --genre pop-rock --stem-model htdemucs_6s --preview
  node ${bin} color --contains CLICK --color red
  node ${bin} returns --count 2 --fx RVerb --from selected
  node ${bin} add-fx --selected --fx RVerb
  node ${bin} remove-fx --all
  node ${bin} delete-tracks --selected
  node ${bin} select-tracks --contains FLAUTA
  node ${bin} select-items --selected-tracks
  node ${bin} select-items --contains VOX
  node ${bin} volume --all --db -3
  node ${bin} pan --selected --pan L35
  node ${bin} copy-balance --from "DRUMS 2" --to "DRUMS SOFT"
  node ${bin} send-volume --selected --dest Reverb --db 2
  node ${bin} item-volume --selected --db -3
  node ${bin} gain-stage --all-items
  node ${bin} vocal-level --selected-items
  node ${bin} track-state --contains VOX --mute on
  node ${bin} rename --contains CLICK --prefix REF_
  node ${bin} create-tracks --count 2 --name FX
  node ${bin} folder --selected --name DRUMS
  node ${bin} route-to-bus --selected --bus DRUMS --disable-main
  node ${bin} fx-bypass --selected --fx RVerb --state toggle
  node ${bin} rock-template
  node ${bin} ask "Coloreame todas las pistas que contengan la palabra CLICK de rojo"
  node ${bin} chat "baja guitarras 1 dB"
  node ${bin} prefs set defaultSendSource selected
`);
}
