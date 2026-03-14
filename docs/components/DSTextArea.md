# DSTextArea

[`DSTextArea`](../../ios/Sources/DesignSystem/Components/DSTextArea.swift) is a themed multi-line text area with optional title.

## Purpose

Use `DSTextArea` for:

- multi-line text input (comments, descriptions, notes)
- form fields requiring paragraph-length input
- text areas with labeled headers

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | `Binding<String>` | — | Input text |
| `title` | `LocalizedStringKey?` | `nil` | Optional title above the field |
| `placeholder` | `LocalizedStringKey` | `"Enter text..."` | Placeholder text |
| `minHeight` | `CGFloat` | `120` | Minimum field height |

## Example

```swift
DSTextArea(
    text: $notes,
    title: "Notes",
    placeholder: "Add your notes here...",
    minHeight: 160
)
```

---

## AI Reference

> **For AI agents implementing this component:** Always consult these files before writing code.
>
> | Resource | Path | Purpose |
> |----------|------|---------|
> | CLAUDE.md | [`CLAUDE.md`](../../CLAUDE.md) | Component rules, layout patterns, anti-patterns, token mapping |
> | Contract | [`docs/ai/design-system-contract.yaml`](../ai/design-system-contract.yaml) | Machine-readable component registry, variants, ai_roles |
> | Component YAML | [`docs/ai/components/DSTextArea.yaml`](../ai/components/DSTextArea.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSTextArea
  category: forms
  path: ../../ios/Sources/DesignSystem/Components/DSTextArea.swift
  ai_roles: [multiline_input, notes_field]
```

### Key rules

- Multiline input — bind to a `String` with `@Binding`; never use a multi-line `TextField` manually.
- Read min/max height constraints from Figma.
- Use for notes, bio, and comment fields where the input spans multiple lines.
