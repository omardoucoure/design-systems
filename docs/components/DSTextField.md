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
