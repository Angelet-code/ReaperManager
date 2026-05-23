export function buildRockTemplateCommand({ clear = true } = {}) {
  return {
    type: "create_rock_template",
    clearExisting: clear !== false && clear !== "false"
  };
}
