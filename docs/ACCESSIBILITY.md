# Accessibility Guide

This design system is iOS-first, so accessibility requirements should be treated as part of the component contract rather than optional polish.

## Minimum Bar

Every public component and showcase page should satisfy these checks:

- interactive controls expose a meaningful accessibility label
- icon-only actions add explicit labels in the consuming view
- color and state are not the only signal for validation, errors, or selection
- controls remain usable in light and dark styles
- text styles respect the system font pipeline used by the design system

## Component Expectations

### Buttons

- Text buttons should rely on visible text as the primary accessible name.
- Icon-only buttons must receive an explicit `.accessibilityLabel(...)` from the caller unless the component provides one.
- Disabled state should remain visually distinct and semantically disabled.

### Inputs

- Inputs should expose label, placeholder, helper text, and validation state clearly.
- Error state should pair color with helper text.
- Secure entry toggles should have a readable label such as "Show password" or "Hide password" when possible.

### Lists and Navigation

- Tappable rows should provide a single coherent reading order.
- Trailing affordances such as arrows should not become the only accessible name of a list row.

## Page Composition Rules

- Prefer DS primitives because their semantics and state model can be improved once and reused everywhere.
- Avoid rebuilding custom buttons from raw `Button`, `Image`, and `Capsule` when `DSButton` already covers the case.
- Add page-specific labels for decorative icon-only actions such as dismiss, close, settings, or social sign-in shortcuts.

## Current Gaps

The system still needs broader accessibility auditing in these areas:

- dynamic type behavior across all components
- VoiceOver flow validation in sample pages
- explicit accessibility hooks for some icon-only component APIs
- color contrast verification for all 16 theme combinations
