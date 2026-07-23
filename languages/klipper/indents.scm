; Auto-indent rules for Klipper.
; Sections and SAVE_CONFIG blocks increase indent on the next line;
; closing `]` decreases it.

(section
  "[" @open
  "]" @close) @indent

(line_comment) @indent
(setting) @indent
(comment) @indent
