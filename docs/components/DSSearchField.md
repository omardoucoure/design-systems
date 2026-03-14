# DSSearchField

[`DSSearchField`](../../ios/Sources/DesignSystem/Components/DSSearchField.swift) is a themed search field with magnifying glass icon and clear button.

## Purpose

Use `DSSearchField` for:

- search bars at the top of lists
- filter inputs
- any text input with search semantics

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | `Binding<String>` | — | Search text |
| `placeholder` | `LocalizedStringKey` | `"Search"` | Placeholder text |
| `variant` | `InputVariant` | `.filled` | Visual variant (filled/lined) |
| `onSubmit` | `(() -> Void)?` | `nil` | Submit handler |

## Example

```swift
DSSearchField(
    text: $query,
    placeholder: "Search products",
    variant: .filled,
    onSubmit: { performSearch() }
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
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSSearchField
  category: forms
  path: ../../ios/Sources/DesignSystem/Components/DSSearchField.swift
  ai_roles: [search_input]
```

### Key rules

- Has a built-in clear button and magnifying glass — never build a custom search field with a manual `TextField` + button.
- Bind the search query to a `@State<String>`; filtering logic stays in the page.
- Use `DSTopAppBar` with `style: .search` for full top-bar search; use `DSSearchField` for inline search within content.
