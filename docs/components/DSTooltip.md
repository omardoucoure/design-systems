# DSTooltip

[`DSTooltip`](../../ios/Sources/DesignSystem/Components/DSTooltip.swift) is a themed tooltip with arrow that appears from a given direction.

## Purpose

Use `DSTooltip` for:

- contextual help text
- feature explanations
- rich tooltips with title, body, image, and action

## Directions

- `top` — arrow points down, tooltip above target
- `bottom` — arrow points up, tooltip below target
- `left` — arrow points right, tooltip left of target
- `right` — arrow points left, tooltip right of target

## Styles

- `simple(LocalizedStringKey)` — text-only tooltip
- `rich(title:, body:, image:, actionLabel:, onAction:)` — tooltip with title, body, image, and CTA

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `style` | `DSTooltipStyle` | — | Content style |
| `direction` | `DSTooltipDirection` | `.top` | Arrow direction |

## Example

```swift
DSTooltip(style: .simple("Tap to save"), direction: .bottom)
DSTooltip(
    style: .rich(
        title: "New feature",
        body: "Try our new export tool.",
        actionLabel: "Learn more",
        onAction: { showHelp() }
    ),
    direction: .top
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
- name: DSTooltip
  category: feedback
  path: ../../ios/Sources/DesignSystem/Components/DSTooltip.swift
  variants: [simple, rich]
  directions: [top, bottom, left, right]
  ai_roles: [context_help, hint]
```

### Key rules

- Direction affects the arrow position — read from Figma to determine which side the tooltip appears on relative to the trigger.
- `.rich` variant supports a custom content closure for multi-line or mixed content.
- Attach to the triggering element using `.overlay` or a `ZStack`; never place the tooltip statically.
