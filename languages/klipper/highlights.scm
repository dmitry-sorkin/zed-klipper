; Klipper syntax highlighting for tree-sitter / Zed.
; Ported from fluidd-core/fluidd's `klipper-config.monarch.ts`.
;
; Grammar node names:
;   section_name, setting_key, setting_separator, value_text,
;   line_comment, save_config_line, comment.
;
; The grammar collapses `key: value # comment` and `key: value#nospace`
; into a single value_text token. Tree-sitter regex predicates
; (#match?) split it visually so the trailing inline comment
; appears in a different colour from the value.

; ---------------------------------------------------------------------------
; Section headers: [name]
; ---------------------------------------------------------------------------
"[" @punctuation.bracket
"]" @punctuation.bracket
(section_name) @type

; ---------------------------------------------------------------------------
; SAVE_CONFIG marker (`#*# ...`). Must win over line_comment in the grammar,
; and we colour it distinctly here.
; ---------------------------------------------------------------------------
(save_config_line) @keyword.control.save-config

; ---------------------------------------------------------------------------
; Full-line comments (lines that start with `#` or `;` outside any value).
; ---------------------------------------------------------------------------
(line_comment) @comment

; ---------------------------------------------------------------------------
; Setting: key, separator, value
; ---------------------------------------------------------------------------
(setting_key) @keyword
(setting_separator) @punctuation.delimiter

; The whole value gets @string as a baseline colour.
(value_text) @string

; Inside a value, the substring " # ..." / " ; ..." is a trailing inline
; comment per the configparser semantics Fluidd follows. tree-sitter
; queries can layer a more-specific capture on top of @string using
; the #match? predicate. The regex anchors to end-of-line so it only
; catches the comment part, not a `#` in the middle of a value.
(value_text)
  (#match? @string "[ \t]+[#;][^\n\r]*$")

; And `#*#` inside a value (mid-line SAVE_CONFIG, rare) takes the
; keyword colour so it visually matches standalone SAVE_CONFIG lines.
(value_text)
  (#match? @string "[ \t]+#\\*#[^\n\r]*$")
