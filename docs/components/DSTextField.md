# DSTextField

[`DSTextField`](../../ios/Sources/DesignSystem/Components/DSTextField.swift) is the shared input primitive for text entry.

## Purpose

Use `DSTextField` for:

- standard text input
- secure input
- filled and lined field variants
- helper and validation messaging

## States

- `empty`
- `filled`
- `active`
- `error`
- `validated`

The visual state should be driven by the actual screen state. Do not use the component as a static mock when a real interactive binding is available.

## Variants

- `filled`
- `lined`

## Accessibility

- Provide a meaningful `label` when placeholder text is not enough.
- Error state should always include helper text, not just red color.
- Secure fields should communicate that they are password fields and expose a show/hide affordance clearly.

## Example

```swift
DSTextField(
    text: $password,
    placeholder: "Enter your password",
    label: "Password",
    helperText: "Must contain at least 8 characters",
    variant: .filled,
    state: .active,
    isSecure: true
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
> | Component YAML | [`docs/ai/components/DSTextField.yaml`](../ai/components/DSTextField.yaml) | AI decision guide: use_when, variants, padding, color mapping, rules |
> | Theming | [`docs/theming.md`](../theming.md) | Theme system, custom color overrides, all token tables |

### Contract entry

```yaml
- name: DSTextField
  category: forms
  path: ../../ios/Sources/DesignSystem/Components/DSTextField.swift
  variants: [filled, lined]
  states: [empty, filled, active, error, validated]
  ai_roles: [text_input, email_input, password_input, validated_field]
```

### Key rules

- Use `isSecure: true` when Figma shows dots (`••••`) — never show plaintext for password fields.
- Error state must include `helperText`, not just a color change.
- Read variant and state directly from Figma — never default to `.empty` when content is shown.
- `.filled` variant background is `surfaceNeutral0_5` (white/cream) to contrast against a `surfaceNeutral2` card background.
