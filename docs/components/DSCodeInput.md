# DSCodeInput

[`DSCodeInput`](../../ios/Sources/DesignSystem/Components/DSCodeInput.swift) is a themed verification code input with individual digit boxes.

## Purpose

Use `DSCodeInput` for:

- OTP/verification code entry
- PIN inputs
- numeric code confirmation

## Properties

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `code` | `Binding<String>` | — | Entered code string |
| `digitCount` | `Int` | `4` | Number of digit boxes |

The component uses a numeric keyboard and auto-advances focus between boxes.

## Example

```swift
DSCodeInput(code: $verificationCode, digitCount: 6)
```

---

## AI Reference

> **For AI agents implementing this component:** Always consult these files before writing code.
>
> | Resource | Path | Purpose |
> |----------|------|---------|
> | CLAUDE.md | [`CLAUDE.md`](../../CLAUDE.md) | Component rules, layout patterns, anti-patterns, token mapping |
> | Contract | [`docs/ai/design-system-contract.yaml`](../ai/design-system-contract.yaml) | Machine-readable component registry, variants, ai_roles |
> | Component YAML | [`docs/ai/components/DSCodeInput.yaml`](../ai/components/DSCodeInput.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSCodeInput
  category: forms
  path: ../../ios/Sources/DesignSystem/Components/DSCodeInput.swift
  ai_roles: [otp, passcode, verification]
```

### Key rules

- Always uses a numeric keyboard; digit count is fixed at init — never build a custom OTP input manually.
- Read the number of digits from Figma (count the visible input boxes).
- Bind the completed code string to a `@State` for submission handling.
