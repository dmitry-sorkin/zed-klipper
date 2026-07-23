# zed-klipper

[Klipper](https://www.klipper3d.org/) configuration file support for the
[Zed](https://zed.dev) editor. Highlights `.cfg` files correctly — sections,
keys, values, comments, and the auto-written `SAVE_CONFIG` block — using
the dedicated [tree-sitter-klipper](https://github.com/dmitry-sorkin/tree-sitter-klipper)
grammar.

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Zed](https://img.shields.io/badge/Zed-extension-blueviolet)](https://zed.dev)

## What you get

Once installed, Zed recognises `printer.cfg` (and any other file you map
to the `Klipper` file type) and applies Tree-sitter-based highlighting:

- **Sections** like `[stepper_x]`, `[gcode_macro MY_STARTUP]`,
  `[include extras/*.cfg]`.
- **Settings** with both Klipper-accepted forms: `key = value` and
  `key: value`.
- **Comments** starting with `#` or `;`, including the `#*#` `SAVE_CONFIG`
  marker block that Klipper writes automatically after a
  `SAVE_CONFIG` command.
- **Values** containing URLs (`mqtt://broker:1883`), negation
  (`!PE3`), pull-up resistors (`^EXP1_5`), and virtual pins
  (`tmc2209_stepper_x:virtual_endstop`).
- Code folding on sections, and an outline / breadcrumb view.

## Installation

The extension is published as a Git repository. To install it:

1. Open Zed.
2. Open the command palette (`Ctrl+Shift+P` / `Cmd+Shift+P`).
3. Run `zed: install dev extension`.
4. Paste the repository URL:
   `https://github.com/dmitry-sorkin/zed-klipper`
5. Wait for Zed to clone, build, and activate the extension.

Alternatively, you can clone the repo into a directory of your choice
and point `zed: install dev extension` at the local path.

## File association

Klipper config files are stored with the `.cfg` extension, which many
other tools also use. The existing Zed INI extension claims every
`.cfg` file by default. To make Zed open Klipper configs with this
extension, add the following to `~/.config/zed/settings.json`:

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

## Known limitations

The grammar deliberately agrees with Klipper's own
`configparser.RawConfigParser` behaviour rather than with Fluidd's
Monarch highlighter on three edge cases. These do not break
highlighting; they only affect the structural correctness of the
parse tree:

1. **Inline comments are absorbed into the value.** The line
   `kinematics: corexy  # cartesian` produces one value token,
   `corexy: corexy  # cartesian`. The trailing `# cartesian` is part
   of the value-coloured run rather than a separate comment run.
2. **A `;` line immediately inside a section.** The parser ends the
   section at the `;`, so the next setting falls outside the
   section. A `#` line in the same position works correctly.
3. **Multi-line `gcode:` continuations.** A `gcode:` block can span
   multiple lines in Klipper. The grammar only recognises the
   first line as the value; subsequent indented lines are parsed
   individually.

The companion grammar repository documents these in detail:
[tree-sitter-klipper#limitations](https://github.com/dmitry-sorkin/tree-sitter-klipper#limitations).

## Repository layout

```
.
├── extension.toml             # Zed extension manifest (schema 1)
├── languages/klipper/         # Per-language metadata
│   └── config.toml
├── LICENSE                    # GPL-3.0
├── README.md                  # This file
├── AGENTS.md                  # Operating manual for AI coding agents
└── CONTRIBUTING.md            # How humans contribute
```

This extension's only "code" is the `extension.toml` manifest and the
`languages/klipper/config.toml` file. All actual parsing happens in
the pinned grammar repository.

## Updating the grammar pin

When [tree-sitter-klipper](https://github.com/dmitry-sorkin/tree-sitter-klipper)
gets a new release:

1. Pick the commit SHA from the grammar repo.
2. Update `extension.toml` under `[grammars.klipper]` → `commit`.
3. Re-install the dev extension.

## Contributing

Issues and pull requests are welcome. Please read
[`CONTRIBUTING.md`](CONTRIBUTING.md) before sending changes. AI coding
agents should read [`AGENTS.md`](AGENTS.md).

## Licence

This extension is a derivative work of
[fluidd-core/fluidd](https://github.com/fluidd-core/fluidd)'s
Monarch highlighter (GPL-3.0) and the
[tree-sitter-klipper](https://github.com/dmitry-sorkin/tree-sitter-klipper)
grammar (also GPL-3.0). It is therefore released under the
**GNU General Public License v3.0 or later**. See
[`LICENSE`](LICENSE) for the full text.

## Credits

- [Klipper](https://www.klipper3d.org/) — the 3D-printer firmware
  whose config files this extension handles.
- [fluidd-core/fluidd](https://github.com/fluidd-core/fluidd) —
  the original Monarch highlighter.
- [tree-sitter-klipper](https://github.com/dmitry-sorkin/tree-sitter-klipper) —
  the Tree-sitter grammar this extension depends on.
- [Zed](https://zed.dev) — the editor this extension plugs into.
