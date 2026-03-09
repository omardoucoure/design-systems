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
