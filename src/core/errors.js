export class CommandError extends Error {
  constructor(message, exitCode = 1) {
    super(message);
    this.exitCode = exitCode;
  }
}

export class AmbiguousCommandError extends CommandError {
  constructor(message) {
    super(message, 2);
    this.name = "AmbiguousCommandError";
  }
}
