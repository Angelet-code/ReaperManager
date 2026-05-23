export function buildRockTemplateCommand({ clear = true } = {}) {
  return {
    type: "create_rock_template",
    clearExisting: clear !== false && clear !== "false"
  };
}

export function buildUndoCommand({ count = 1 } = {}) {
  const numeric = Number(count);
  if (!Number.isInteger(numeric) || numeric < 1 || numeric > 100) {
    throw new Error("Undo count must be an integer between 1 and 100.");
  }

  return {
    type: "undo",
    count: numeric
  };
}
