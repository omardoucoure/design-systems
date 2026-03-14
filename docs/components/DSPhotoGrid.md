# DSPhotoGrid

[`DSPhotoGrid`](../../ios/Sources/DesignSystem/Components/DSPhotoGrid.swift) is a media grid supporting dynamic and compact layouts with video thumbnail generation.

## Purpose

Use `DSPhotoGrid` for:

- photo galleries
- media grids with mixed photo/video content
- alternating row layouts (3/2 pattern)

## Styles

- `dynamic` — alternating rows of 3 and 2 items
- `compact(columns: Int)` — fixed N-column grid

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `photos` | `[String]` | — | Image asset names (photo-only) |
| `items` | `[DSMediaItem]` | — | Mixed photo/video items |
| `style` | `DSPhotoGridStyle` | `.dynamic` | Grid layout style |
| `rowHeight3` | `CGFloat` | `88` | Row height for 3-item rows |
| `rowHeight2` | `CGFloat` | `96` | Row height for 2-item rows |
| `onTap` | `((Int) -> Void)?` | `nil` | Item tap handler |

## Data Model

```swift
DSMediaItem.photo("sunset")
DSMediaItem.video("clip.mp4")
```

## Example

```swift
DSPhotoGrid(
    items: mediaItems,
    style: .dynamic,
    onTap: { index in showFullScreen(index) }
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
- name: DSPhotoGrid
  category: layout
  path: ../../ios/Sources/DesignSystem/Components/DSPhotoGrid.swift
  ai_roles: [photo_video_grid]
```

### Key rules

- Dynamic or compact layout; supports video thumbnails with play overlay.
- Never build a custom photo grid with `LazyVGrid` manually; always use `DSPhotoGrid`.
- Read layout mode (dynamic vs compact) from Figma grid structure.
