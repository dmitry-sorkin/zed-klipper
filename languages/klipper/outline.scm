; Outline / breadcrumbs for Klipper.
; Sections are top-level items; settings are children.

(section
  "[" @context.extra
  name: (_) @name
  "]" @context.extra
) @item

(setting
  key: (_) @name
  separator: (_) @context.extra
  value: (_) @context.extra
) @item
