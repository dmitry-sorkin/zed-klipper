# AGENTS.md — operating manual for AI coding agents

This file is read by AI coding agents (Hermes, Claude Code, Codex,
Cursor, etc.) before they touch the repository. If you are a human,
[`README.md`](README.md) is what you want.

## Project overview

`zed-klipper` is a Zed editor extension that lights up Klipper
`.cfg` files. It is a thin wrapper around
[tree-sitter-klipper](https://github.com/dmitry-sorkin/tree-sitter-klipper).
The only "code" in this repo is:

- `extension.toml` — the Zed extension manifest
- `languages/klipper/config.toml` — per-language metadata (file
  suffixes, comment tokens, indent settings)
- `LICENSE` — GPL-3.0, inherited from Fluidd
- `README.md`, `AGENTS.md`, `CONTRIBUTING.md` — documentation

There is no Rust, no TypeScript, no build step. Zed pulls the
tree-sitter grammar from the upstream grammar repo at install time
and compiles the WASM itself.

## What you may edit

| File                          | Edit? | Notes                                                                 |
| ----------------------------- | ----- | --------------------------------------------------------------------- |
| `extension.toml`              | yes   | Bump `version`, update the `[grammars.klipper].commit` pin, edit authors/description. |
| `languages/klipper/config.toml` | yes | Change `path_suffixes`, `line_comments`, `tab_size` to match Klipper conventions. |
| `README.md`, `LICENSE`, `AGENTS.md`, `CONTRIBUTING.md` | yes | Docs and meta. |
| anything else                 | NO    | This repo is intentionally minimal. New files belong in the grammar repo. |

## Common operations

### Update the grammar pin

1. Pick a commit from
   <https://github.com/dmitry-sorkin/tree-sitter-klipper/commits>.
2. Edit `extension.toml`:

   ```toml
   [grammars.klipper]
   repository = "https://github.com/dmitry-sorkin/tree-sitter-klipper"
   commit = "<full sha>"
   ```

3. Bump `version` in `extension.toml` (semver, minor bump for
   grammar refresh).
4. Commit with a Conventional Commits message:
   `chore: bump tree-sitter-klipper to <sha>`.
5. Push and, if the user has publishing rights, tag a release.

### Add a new file association

1. Edit `languages/klipper/config.toml` and add the suffix or glob
   to `path_suffixes`.
2. Update the example in `README.md` (`file_types` block in
   `settings.json`).

## Things to avoid

- **Do not add a build step** (npm, cargo, scripts/). This repo is
  intentionally just declarative config.
- **Do not vendor the grammar.** Zed fetches the grammar from the
  upstream repo at install time. Vendoring breaks the grammar
  update story.
- **Do not switch to a different grammar source** (e.g. by writing
  `tree-sitter.ini` with `:` compensation). That approach was tried
  and rejected upstream; see
  [tree-sitter-klipper AGENTS.md](https://github.com/dmitry-sorkin/tree-sitter-klipper/blob/main/AGENTS.md).

## Output conventions

When you make a change, your final assistant message should be:

1. one-line summary
2. the command(s) you ran to verify (`cat extension.toml`,
   `git status`)
3. confirmation that `git push` was successful

Do not paste the full `git diff`. Do not narrate every edit.
