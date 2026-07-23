# Contributing

Thanks for your interest in `zed-klipper`. This document is for
human contributors. If you are an AI coding agent, please read
[`AGENTS.md`](AGENTS.md) instead.

## Scope

This repository is intentionally minimal — it is a Zed extension
shell around the [tree-sitter-klipper](https://github.com/dmitry-sorkin/tree-sitter-klipper)
grammar. There is no Rust or TypeScript code; everything is a
declarative config file. Most actual grammar improvements
(lexing, parsing, query files) belong in the grammar repo, not
here.

If you are unsure whether a change belongs in this repo or in
the grammar repo, ask in an issue first.

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
2. Verify your changes locally by installing the dev extension in
   Zed (`zed: install dev extension` → point at your clone).
3. Do not bump the `tree-sitter-klipper` commit pin without first
   confirming the upstream commit builds and its tests pass.

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
docs: clarify file association setup in README
fix: include *.conf suffix for moonraker
chore: bump tree-sitter-klipper to 5b0166d
```

## Licence

By contributing, you agree that your contributions will be licensed
under the GNU General Public License v3.0 or later. Fluidd, on
whose work the underlying grammar is based, is GPL-3.0, and we
cannot accept contributions under more permissive terms.
