# Homebrew Tap for tiffany-loop

Install:

```bash
brew tap macguffinQ/tap
brew install tiffany-loop
```

Run:

```bash
tiffany-loop setup
tiffany-loop
```

This tap publishes `tiffany-loop`, which installs three commands:

- `tiffany-loop` - primary terminal UI.
- `tiffany` - compatibility alias for older scripts.
- `orchestrator` - lower-level runtime/config CLI.

If Homebrew reports the package is installed but your shell cannot find the
command, refresh your shell environment and verify the package prefix:

```bash
eval "$(brew shellenv)"
brew --prefix tiffany-loop
tiffany-loop doctor
```
