# AGENTS.md — operating manual for AI coding agents

This file is read by AI coding agents (Hermes, Claude Code, Codex,
Cursor, etc.) before they touch the repository. If you are a human,
[`README.md`](README.md) is what you want.

## Project overview

`zed-klipper` is a Zed editor extension that highlights Klipper
`.cfg` files. The extension bundles the tree-sitter grammar inside
the same repository (`grammars/klipper/`) and ships a complete set of
queries (`languages/klipper/*.scm`). There is no separate grammar
repository, no Rust code, no build step.

The grammar itself is derived from
[fluidd-core/fluidd](https://github.com/fluidd-core/fluidd)'s Monarch
highlighter. Fluidd is GPL-3.0, so this repository must remain
GPL-3.0. Do not introduce a more permissive licence.

## Files you may edit

| File                                                | Edit? | Notes |
| --------------------------------------------------- | ----- | ----- |
| `grammars/klipper/grammar.js`                       | yes   | The grammar source of truth. Run `tree-sitter generate` after editing. |
| `grammars/klipper/queries/*.scm`                    | yes   | Upstream queries. Optional; Zed prefers `languages/klipper/*.scm`. |
| `grammars/klipper/test/corpus/*.txt`                | yes   | Corpus tests. |
| `languages/klipper/highlights.scm`                  | yes   | Per-extension overrides for Zed. |
| `languages/klipper/{folds,outline,indents,brackets}.scm` | yes | Standard Zed query files. |
| `languages/klipper/config.toml`                     | yes   | File suffix, comment tokens, indent. |
| `extension.toml`                                    | yes   | Version bump, authors, description, grammar pin. |
| `README.md`, `LICENSE`, `AGENTS.md`, `CONTRIBUTING.md` | yes | Docs and meta. |
| `grammars/klipper/src/parser.c`, `grammars/klipper/src/grammar.json`, `grammars/klipper/src/node-types.json`, `grammars/klipper/tree-sitter-klipper.wasm` | NO — generated | Regenerate with `tree-sitter generate` / `tree-sitter build --wasm`. |

## Common operations

### Verify a grammar change

```sh
cd grammars/klipper
tree-sitter generate           # rebuild parser.c
tree-sitter test                # run all corpus tests
tree-sitter build --wasm        # rebuild tree-sitter-klipper.wasm
```

The grammar currently passes `12/13` tests. The failing test
("full-line comment with semicolon") is a known GLR limitation
and is documented in `README.md`. Do not attempt to "fix" it.

### Add a new syntax rule

1. Edit `grammars/klipper/grammar.js`. Add a rule and reference it
   from an existing rule.
2. `cd grammars/klipper && tree-sitter generate`. Resolve any
   conflicts the CLI reports.
3. Add a corpus test under `grammars/klipper/test/corpus/`.
4. Update `languages/klipper/highlights.scm` so the new node has a
   capture that maps to a sensible theme token.
5. `tree-sitter test && tree-sitter build --wasm`.
6. Update `README.md` if the change affects user-visible behaviour.
7. Bump the grammar pin in `extension.toml`:
   - commit your changes in this repo
   - copy the new commit SHA into `[grammars.klipper].commit`
   - commit again (the grammar pin is part of the extension repo)

### Bump the version

1. Bump `version` in `extension.toml` (semver, patch level for
   grammar refreshes, minor for new features).
2. Commit. Tagging is optional and only required if you want to
   publish a GitHub release.

## Things to avoid

- **Do not split this repository.** The grammar and the extension
  live in one repo by design. Publishing them separately was tried
  and rejected.
- **Do not add a build step** (npm, cargo, scripts/). There is no
  Rust code; Zed handles compilation of the WASM grammar itself.
- **Do not invent a converter from Monarch to Tree-sitter.** A common
  failure mode is to suggest "first convert the Monarch rules to
  regex, then to Tree-sitter regex". Monarch's state machine and
  Tree-sitter's GLR parser are not isomorphic. Port rules by hand
  from
  <https://github.com/fluidd-core/fluidd/blob/develop/src/monaco/language/klipper-config.monarch.ts>
  instead.
- **Do not switch to an external scanner to recover the value-vs-
  inline-comment split.** Tree-sitter's external scanner API does
  not give the parser the backtracking semantics needed. The current
  "collapse into `value_text` + predicate regex in highlights.scm"
  approach is intentional and documented in `grammar.js`.

## Output conventions

When you make a code change, write your final assistant message as:

1. one-line summary of what you did
2. the command(s) you ran to verify it
3. a short reminder of which files are still tracked vs ignored

Do not paste the entire diff. Do not narrate every `patch` call.
