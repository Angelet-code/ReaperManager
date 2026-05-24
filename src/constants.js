export const APP_NAME = "Reaper Manager";
export const ACTION_KB_ID = "RS5f8ec7eefb29a342a97ac7f8aae8dfc9012cf12d";
export const ACTION_ID = `_${ACTION_KB_ID}`;
export const CHAT_ACTION_KB_ID = "RSa6b6e85d9e9d4d35ad1f7a9f4528f0c32b6cb71c";
export const CHAT_ACTION_ID = `_${CHAT_ACTION_KB_ID}`;
export const GAIN_STAGE_ACTION_KB_ID = "RS94899e1e2a06752801d22ebba3524bac632e364c";
export const GAIN_STAGE_ACTION_ID = `_${GAIN_STAGE_ACTION_KB_ID}`;
export const SELECT_ALL_ITEMS_ACTION_KB_ID = "RS0f2c7d9a733f4be3a1d938db450876f4c40b7856";
export const SELECT_ALL_ITEMS_ACTION_ID = `_${SELECT_ALL_ITEMS_ACTION_KB_ID}`;
export const DETECT_ARRANGEMENT_ACTION_KB_ID = "RS64a1b50c0935466b963c5b26e9b05acb0f9a04b6";
export const DETECT_ARRANGEMENT_ACTION_ID = `_${DETECT_ARRANGEMENT_ACTION_KB_ID}`;
export const BRIDGE_FILE = "Reaper Manager Bridge.lua";
export const CHAT_FILE = "Reaper Manager Chat.lua";
export const GAIN_STAGE_FILE = "Reaper Manager Gain Stage.lua";
export const SELECT_ALL_ITEMS_FILE = "Reaper Manager Select All Items.lua";
export const DETECT_ARRANGEMENT_FILE = "Reaper Manager Detect Arrangement.lua";
export const JSON_FILE = "rm_json.lua";
export const CONFIG_FILE = "rm_config.lua";
export const REAPER_RUNTIME_FILES = [
  JSON_FILE,
  "rm_bridge.lua",
  "rm_registry.lua",
  "rm_fs.lua",
  "rm_core.lua",
  "rm_commands_basic.lua",
  "rm_gain_stage.lua",
  "rm_vocal_level.lua",
  "rm_project_mix.lua"
];

export const COLOR_MAP = {
  red: [255, 0, 0],
  rojo: [255, 0, 0],
  green: [0, 170, 70],
  verde: [0, 170, 70],
  blue: [40, 105, 255],
  azul: [40, 105, 255],
  yellow: [255, 210, 0],
  amarillo: [255, 210, 0],
  orange: [255, 130, 0],
  naranja: [255, 130, 0],
  purple: [145, 75, 230],
  morado: [145, 75, 230],
  pink: [255, 85, 170],
  rosa: [255, 85, 170],
  white: [245, 245, 245],
  blanco: [245, 245, 245],
  gray: [130, 130, 130],
  grey: [130, 130, 130],
  gris: [130, 130, 130],
  black: [20, 20, 20],
  negro: [20, 20, 20]
};

export const DEFAULT_ALIASES = {
  rverb: {
    query: "RVerb",
    prefer: "vst3-stereo",
    fallbackName: "RVerb Stereo (Waves)",
    fallbackFxName: "VST3:RVerb Stereo (Waves)"
  }
};

export const VALID_SEND_SOURCES = new Set(["selected", "none", "all-audio"]);
