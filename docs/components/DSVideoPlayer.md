# DSVideoPlayer

[`DSVideoPlayer`](../../ios/Sources/DesignSystem/Components/DSVideoPlayer.swift) is a full-screen video player overlay with dismiss button.

## Purpose

Use `DSVideoPlayer` for:

- full-screen video playback modals
- media preview overlays
- video content from URL strings

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `urlString` | `String` | — | Video URL string |
| `onDismiss` | `() -> Void` | — | Close handler |

## Example

```swift
DSVideoPlayer(
    urlString: "https://example.com/video.mp4",
    onDismiss: { showVideo = false }
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
> | Component YAML | [`docs/ai/components/DSVideoPlayer.yaml`](../ai/components/DSVideoPlayer.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSVideoPlayer
  category: layout
  path: ../../ios/Sources/DesignSystem/Components/DSVideoPlayer.swift
  ai_roles: [fullscreen_video_overlay]
```

### Key rules

- Full-screen overlay — always presented modally (`.fullScreenCover`); never embedded inline in a list.
- Never use `VideoPlayer` from `AVKit` directly; always use `DSVideoPlayer` for consistent controls.
- Dismiss is handled internally; provide the video URL and optional title.
