# DSButton

[`DSButton`](../../ios/Sources/DesignSystem/Components/DSButton.swift) is the primary action primitive for the system.

## Purpose

Use `DSButton` for:

- primary and secondary actions
- text actions
- icon-only actions
- asset-based icon actions

Avoid rebuilding button visuals inline in pages unless the pattern is intentionally outside the system.

## Variants

- `filledA`: secondary-colored emphasis action
- `filledB`: primary-colored filled action
- `filledC`: stronger dark primary surface action
- `neutral`: neutral filled action
- `neutralLight`: light neutral filled action for dark surfaces
- `outlined`: bordered action for light surfaces
- `outlinedLight`: bordered action for dark surfaces
- `text`: low-emphasis text action

## Sizes

- `big`
- `medium`
- `small`

Sizing and press metrics are resolved through [`ComponentTokens`](../../ios/Sources/DesignSystem/Tokens/ComponentTokens.swift).

## Accessibility

- Prefer text buttons when possible.
- Add `.accessibilityLabel(...)` when using icon-only buttons.
- Keep the action meaning specific, for example "Close warning" instead of "Close".

## Example

```swift
DSButton("Continue", style: .filledA, size: .big, iconRight: "arrow.right", isFullWidth: true) {
    submit()
}
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
- name: DSButton
  category: actions
  path: ../../ios/Sources/DesignSystem/Components/DSButton.swift
  variants: [filledA, filledB, filledC, neutral, neutralLight, outlined, outlinedLight, text]
  sizes: [big, medium, small]
  content_modes: [text, icon_only_system, icon_only_asset, text_with_left_icon, text_with_right_icon]
  ai_roles: [primary_cta, secondary_cta, tertiary_action, social_action, dismiss_action, toolbar_action]
```

### Key rules

- Read background color from Figma to pick style: `surfaceSecondary100` → `.filledA`, `surfacePrimary100` → `.filledB`, `surfacePrimary120` → `.filledC`, `surfaceNeutral2` → `.neutral` — never guess the style.
- Never rebuild button visuals inline with `RoundedRectangle` or manual `HStack` — always use `DSButton`.
- Add `accessibilityLabel` for icon-only buttons.
- Use `assetIcon:` for custom Figma vector icons; use `systemIcon:` for SF Symbols only.
