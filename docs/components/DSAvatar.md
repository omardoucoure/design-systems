# DSAvatar

[`DSAvatar`](../../ios/Sources/DesignSystem/Components/DSAvatar.swift) is a themed avatar with three style variants and configurable shape.

## Purpose

Use `DSAvatar` for:

- user profile pictures
- initials/monogram placeholders
- icon-based placeholders

## Styles

- `monogram(String)` — displays initials on a themed background
- `icon(String)` — displays an SF Symbol on a themed background
- `image(Image)` — displays a custom image, clipped to shape

## Shapes

- `circle` — circular clip (default)
- `roundedRect(CGFloat)` — rounded rectangle with custom corner radius

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `style` | `DSAvatarStyle` | — | Visual content style |
| `size` | `CGFloat` or `CGSize` | `40` | Avatar dimensions |
| `shape` | `DSAvatarShape` | `.circle` | Clip shape |

## Accessibility

- Add `.accessibilityLabel(...)` with the user's name when using image avatars.

## Example

```swift
DSAvatar(style: .monogram("OD"), size: 48)
DSAvatar(style: .image(Image("profile")), size: 64, shape: .roundedRect(12))
DSAvatar(style: .icon("person.fill"), size: 32)
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
- name: DSAvatar
  category: media
  path: ../../ios/Sources/DesignSystem/Components/DSAvatar.swift
  variants: [monogram, icon, image]
  shapes: [circle, roundedRect]
  ai_roles: [user_avatar, contact_avatar]
```

### Key rules

- Never use `Image().clipShape(Circle())` for avatars — always use `DSAvatar`.
- `size` is a `CGFloat` in points; read the exact pixel dimension from Figma.
- Choose variant based on Figma content: photo → `.image`, initials → `.monogram`, icon → `.icon`.
