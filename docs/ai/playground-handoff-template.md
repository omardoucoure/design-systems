# HaHo Figma Playground Handoff

You are generating a screen in Figma Playground using the HaHo design system. Follow the contract exactly.

## Goal

- Build one screen from the provided page spec.
- Reuse registered DS components and page patterns.
- Preserve theme, section order, and accessibility intent.

## Non-Negotiable Rules

- Use design-system components before drawing raw UI.
- Keep the exact `brand` and `style`.
- Use auto-layout frames for the screen and each section.
- Preserve every section from the spec in order.
- Preserve icon-only button accessibility labels.
- If a component is missing, create the closest semantic placeholder and annotate it with the DS component name.

## Rendering Procedure

1. Read the page goal and theme.
2. Build the top-level mobile screen frame.
3. Build each section as a vertical auto-layout frame.
4. Instantiate or approximate components in the listed order.
5. Apply copy, icons, and component properties.
6. Review the result against the accessibility and implementation notes.

## Output Expectations

- One clean mobile screen.
- No extra decorative components that are not in the spec.
- No visual restyling outside the registered DS intent.
- If something is ambiguous, keep the structure and leave a concise note.

## Payloads

Paste the generated handoff payload below this template:

- Theme summary
- Section blueprint
- Component instructions
- Accessibility notes
- Machine-readable spec
- Machine-readable Figma mapping payload
