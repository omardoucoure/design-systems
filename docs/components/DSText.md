# DSText

[`DSText`](../../ios/Sources/DesignSystem/Components/DSText.swift) is a themed text view applying a typography token and color in one line.

## Purpose

Use `DSText` for:

- quick text rendering with theme tokens
- replacing `.font(...).foregroundStyle(...)` chains
- consistent text styling throughout the app

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `content` | `LocalizedStringKey` or `String` | — | Text content |
| `style` | `DSTypographyToken` | — | Typography token |
| `color` | `Color` | — | Text color |

## Example

```swift
DSText("Welcome back", style: theme.typography.h4, color: theme.colors.textNeutral9)
DSText("Subtitle", style: theme.typography.caption, color: theme.colors.textNeutral5)
```

---

## AI Reference

> **For AI agents implementing this component:** Always consult these files before writing code.
>
> | Resource | Path | Purpose |
> |----------|------|---------|
> | CLAUDE.md | [`CLAUDE.md`](../../CLAUDE.md) | Component rules, layout patterns, anti-patterns, token mapping |
> | Contract | [`docs/ai/design-system-contract.yaml`](../ai/design-system-contract.yaml) | Machine-readable component registry, variants, ai_roles |
> | Component YAML | [`docs/ai/components/DSText.yaml`](../ai/components/DSText.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSText
  category: typography
  path: ../../ios/Sources/DesignSystem/Components/DSText.swift
  ai_roles: [tokenized_text]
```

### Key rules

- Use instead of `Text().font(theme.typography.x.font).tracking(theme.typography.x.tracking)` when no extra modifiers are needed.
- Never use `.font(.system(size:))` or `.font(.custom("DMSans-...", size:))` anywhere — always use typography tokens.
- Never add `.bold()` on top of a typography token — the token already encodes font weight.
