# zed-klipper

[Klipper](https://www.klipper3d.org/) configuration file support for the
[Zed](https://zed.dev) editor. Highlights `.cfg` files correctly — sections,
keys, values, comments, and the auto-written `SAVE_CONFIG` block — using
a tree-sitter grammar derived from
[Fluidd](https://github.com/fluidd-core/fluidd)'s Monarch highlighter.

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Zed](https://img.shields.io/badge/Zed-extension-blueviolet)](https://zed.dev)

## What you get

After installation, Zed colours `printer.cfg` and similar files with:

- **Section headers** like `[stepper_x]`, `[gcode_macro MY_STARTUP]`,
  `[include extras/*.cfg]`.
- **Settings** with both Klipper-accepted forms: `key = value` and
  `key: value`.
- **Comments** starting with `#` or `;`, including the `SAVE_CONFIG`
  marker block that Klipper writes after a `SAVE_CONFIG` command.
- **Trailing inline comments** in a distinct colour from the value:
  `kinematics: corexy  # cartesian` shows `# cartesian` as a comment,
  not as part of the value.
- **Values** like URLs (`mqtt://broker:1883`), negation (`!PE3`),
  pull-ups (`^EXP1_5`), and virtual pins
  (`tmc2209_stepper_x:virtual_endstop`).
- Code folding on sections and an outline / breadcrumb view.

## Installation

The extension is **not** on the official Zed registry yet. To install it
you point Zed at a local folder containing `extension.toml`, so you need
to clone the repository first.

### Step 1 — Clone

Pick a folder where you keep dev extensions. The folder name doesn't
matter:

```sh
git clone https://github.com/dmitry-sorkin/zed-klipper \
    ~/code/zed-klipper
```

### Step 2 — Install as a dev extension

In Zed:

1. Open the command palette (`Ctrl+Shift+P` / `Cmd+Shift+P`).
2. Run `zed: install dev extension`.
3. Zed opens a system file picker. Navigate to the folder you cloned
   into (`~/code/zed-klipper` in the example) and pick **the folder
   itself**, not a file inside it.
4. Wait for Zed to clone the embedded grammar, compile the WASM, and
   register the language.

The `Extensions` page will show `Klipper` listed with the green
"Overridden by dev extension" badge once it is active. To get rid of
the dev install, run `zed: uninstall dev extension` and pick the same
folder.

### Updating

Inside the cloned folder, run:

```sh
git pull
```

then re-run `zed: install dev extension` against the same folder. Zed
will recompile the grammar against the new commit.

## File association

Klipper config files share the `.cfg` extension with many other tools.
Zed's built-in INI grammar normally claims `.cfg`. To make Zed open
Klipper configs with this extension, add the following to
`~/.config/zed/settings.json`:

```json
{
  "file_types": {
    "Klipper": [
      "printer.cfg",
      "printer*.cfg",
      "moonraker.conf",
      "fluidd.cfg",
      "fluidd-*.conf",
      "mainsail.cfg"
    ]
  }
}
```

After saving, restart Zed or run `zed: reload` to pick up the change.

## How the grammar is shipped

The tree-sitter grammar source — `grammar.js`, `src/parser.c`,
`tree-sitter-klipper.wasm` and the corpus tests — lives **inside this
same repository** under `grammars/klipper/`. `extension.toml` references
it as a sub-path of this very repo:

```toml
[grammars.klipper]
repository = "https://github.com/dmitry-sorkin/zed-klipper"
commit     = "<pinned sha>"
path       = "grammars/klipper"
```

When Zed installs the extension it fetches the repo, checks out the
pinned commit, and uses `grammars/klipper/` as the grammar source.
No separate grammar repository is published.

## Known limitations

The grammar deliberately matches Klipper's
`configparser.RawConfigParser` behaviour rather than splitting values
on `[whitespace][#;]` perfectly. Two edge cases to be aware of:

1. **A `;` line immediately inside a section.** The parser ends the
   section at the `;` and the next setting falls outside it. A `#`
   line in the same position is handled correctly.
2. **Multi-line `gcode:` continuations.** A `gcode:` block can span
   multiple lines in Klipper. The grammar only recognises the first
   line as the value; subsequent indented lines are parsed individually.

The corpus tests report `12/13`; the failing case is (1) and is
documented. Neither case breaks highlighting — they only affect the
structural correctness of the parse tree.

## Repository layout

```
zed-klipper/
├── extension.toml              # Zed extension manifest
├── grammars/klipper/           # Embedded tree-sitter grammar source
│   ├── grammar.js
│   ├── src/parser.c
│   ├── tree-sitter-klipper.wasm
│   ├── tree-sitter.json
│   ├── queries/                # upstream queries
│   └── test/corpus/            # corpus tests
├── languages/klipper/          # Per-language metadata for Zed
│   ├── config.toml
│   ├── highlights.scm
│   ├── folds.scm
│   ├── outline.scm
│   ├── indents.scm
│   └── brackets.scm
├── LICENSE                     # GPL-3.0
├── README.md
├── AGENTS.md                   # Operating manual for AI coding agents
└── CONTRIBUTING.md             # How humans contribute
```

## Contributing

Issues and pull requests are welcome. Read
[`CONTRIBUTING.md`](CONTRIBUTING.md) before sending changes. AI coding
agents should read [`AGENTS.md`](AGENTS.md).

## Licence

This extension is a derivative work of
[fluidd-core/fluidd](https://github.com/fluidd-core/fluidd)'s
Monarch highlighter (GPL-3.0) and is therefore released under the
**GNU General Public License v3.0 or later**. See
[`LICENSE`](LICENSE) for the full text.

## Credits

- [Klipper](https://www.klipper3d.org/) — the 3D-printer firmware
  whose config files this extension handles.
- [fluidd-core/fluidd](https://github.com/fluidd-core/fluidd) —
  the original Monarch highlighter, ported into the grammar.
- [tree-sitter](https://tree-sitter.github.io/) — the parsing
  library Zed uses.
- [Zed](https://zed.dev) — the editor this extension plugs into.
