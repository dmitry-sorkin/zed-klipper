# Contributing

Thanks for your interest in `zed-klipper`. This document is for
human contributors. AI coding agents should read
[`AGENTS.md`](AGENTS.md) instead.

## Scope

This repository bundles a Zed extension **and** the tree-sitter
grammar it depends on (under `grammars/klipper/`). Both live in
the same repo by design — there is no separate grammar repository.

If you change the grammar, you change the extension, and vice
versa. Test both together.

## Bug reports

Open an issue with:

1. Your Zed version (`zed --version`).
2. The smallest `.cfg` snippet that reproduces the problem.
3. A screenshot or copy of what the highlighting looks like, plus
   what you expected.

## Pull requests

Before sending a PR, please:

1. Open an issue first for non-trivial changes so we can agree on
   the approach.
2. Run the corpus tests:
   ```sh
   cd grammars/klipper
   tree-sitter test
   tree-sitter build --wasm
   ```
3. Verify the extension installs and highlights correctly in Zed:
   - run `zed: install dev extension` against your clone
   - open a representative `.cfg` file
   - confirm sections, settings, comments, and `SAVE_CONFIG`
     blocks render in distinct colours
4. If you bumped the grammar, update the `commit` pin in
   `extension.toml` to the new SHA.

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(grammar): support [include extras/*.cfg] in outline
fix(highlights): keep # trailing comment in comment colour
docs: rewrite install instructions for file picker
chore: rebuild parser.c and wasm
```

## Development setup

You need:

- A C11 compiler.
- The `tree-sitter` CLI, version **0.22 or newer**:
  ```sh
  cargo install tree-sitter-cli
  # or
  npm install -g tree-sitter-cli
  ```
- Zed editor.

Clone and build:

```sh
git clone https://github.com/dmitry-sorkin/zed-klipper
cd zed-klipper
cd grammars/klipper
tree-sitter generate
tree-sitter test
tree-sitter build --wasm
```

Then in Zed: `zed: install dev extension` → pick the repository root.

## Coding style

- `grammars/klipper/grammar.js` is JavaScript (CommonJS). 2-space
  indentation, no semicolons, JSDoc comments on each rule.
- `*.scm` files use Tree-sitter's S-expression syntax. Match the
  existing style.

## Licence

By contributing, you agree that your contributions will be licensed
under the GNU General Public License v3.0 or later. Fluidd, on
whose work the grammar is based, is GPL-3.0, and we cannot accept
contributions under more permissive terms.
