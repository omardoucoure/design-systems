# DSUserCard

Profile card with avatar, name, bio, a stat column, and sign-out / edit action buttons. Matches the Figma "Text" card component (node 1017:70585).

## Usage

```swift
DSUserCard(
    name: "Hristo Hristov",
    bio: "Sports superhero. Training for the office chair Olympics…",
    avatarImage: Image("avatar"),
    stat: DSUserCardStat(value: "98%", label: "done"),
    onSignOut: { /* handle sign out */ },
    onEdit: { /* handle edit */ }
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `LocalizedStringKey` | — | User's display name |
| `bio` | `LocalizedStringKey` | — | Short bio text |
| `readMoreLabel` | `LocalizedStringKey` | `"read more"` | Inline link appended to bio |
| `avatarImage` | `Image?` | `nil` | Optional avatar photo |
| `stat` | `DSUserCardStat` | — | Single stat shown in the bottom row |
| `signOutLabel` | `LocalizedStringKey` | `"Sign Out"` | Label for the sign-out button |
| `editLabel` | `LocalizedStringKey` | `"Edit"` | Label for the edit button |
| `onSignOut` | `() -> Void` | — | Called when sign-out is tapped |
| `onEdit` | `() -> Void` | — | Called when edit is tapped |

## DSUserCardStat

```swift
DSUserCardStat(value: "98%", label: "done")
```

| Property | Type | Description |
|----------|------|-------------|
| `value` | `LocalizedStringKey` | Large numeric/text value |
| `label` | `LocalizedStringKey` | Small label below the value |

## Layout

```
┌──────────────────────────────────────┐
│  Name                    [Avatar]    │
│  Bio text… read more                 │
├──────────────────────────────────────┤
│  98%          [Sign Out]  [Edit]     │
│  done                                │
└──────────────────────────────────────┘
```

- Outer container: `DSCard` with `surfaceNeutral2` background, `radius.xl`, zero padding
- Top section: name in `h4`, bio in `bodyRegular` with inline `readMoreLabel` in `label` weight
- Avatar: 61×64pt, clipped to `radius.md` rounded rectangle
- Separator: `DSDivider(style: .fullBleed)`
- Bottom row: stat column + `.neutralLight` sign-out button + `.filledA` edit button

## Token usage

| Element | Token |
|---------|-------|
| Card background | `theme.colors.surfaceNeutral2` |
| Card radius | `theme.radius.xl` |
| Inner padding | `theme.spacing.xl` |
| Section gap | `theme.spacing.lg` |
| Name font | `theme.typography.h4` |
| Bio font | `theme.typography.bodyRegular` |
| Read more font | `theme.typography.label` |
| Stat value font | `theme.typography.largeSemiBold` |
| Stat label font | `theme.typography.smallRegular` |
| Sign-out button | `DSButton(style: .neutralLight, size: .medium, icon: .logOut)` |
| Edit button | `DSButton(style: .filledA, size: .medium, icon: .editPencil)` |
