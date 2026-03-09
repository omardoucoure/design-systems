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

## Theme Summary
- Brand: `mistyRose`
- Style: `darkRounded`
- Page type: `alerts`
- Page name: `AI Generated Warning Dialog`
- Description: Warning dialog overlay with stacked actions using the alert.dialog pattern.

## Section Blueprint
- `alerts.dialog` uses pattern `alert.dialog` and renders as a vertical section frame.
  Title: Warning dialog
  Component order: `alerts.dialog.surface`, `alerts.dialog.modal`, `alerts.dialog.primary`, `alerts.dialog.secondary`, `alerts.dialog.cancel`
  - `alerts.dialog.surface` => `DSCard` role `overlay_surface` (default) with props {"background": "surfaceNeutral2", "padding": "spacingXl", "radius": "radiusXl"}
  - `alerts.dialog.modal` => `DSAlertDialog` role `modal_alert` (default) with props {"icon": "batterySlash", "message": "Keep going and risk a system tantrum, or take a break? Your call.", "severity": "warning", "title": "HaHo's been a battery hog!"}
  - `alerts.dialog.primary` => `DSButton` role `primary_cta` (variant=filledA, size=medium) with props {"iconRight": "log.out", "isFullWidth": true, "label": "Delete App"}
  - `alerts.dialog.secondary` => `DSButton` role `secondary_cta` (variant=neutral, size=medium) with props {"isFullWidth": true, "label": "Disable Background Usage"}
  - `alerts.dialog.cancel` => `DSButton` role `dismiss_action` (variant=neutral, size=medium) with props {"isFullWidth": true, "label": "Cancel"}

## Component Mapping Summary
- `alerts.dialog.surface` maps `DSCard` to Figma component `Card`.
- `alerts.dialog.modal` maps `DSAlertDialog` to Figma component `Alert Dialog`.
- `alerts.dialog.primary` maps `DSButton` to Figma component `Button`.
- `alerts.dialog.secondary` maps `DSButton` to Figma component `Button`.
- `alerts.dialog.cancel` maps `DSButton` to Figma component `Button`.

## Playground-Specific Rules
- Never invent a new component when a registered DS component already covers the job.
- Never use raw spacing, radius, or colors outside the registered token names in the page spec.
- Always preserve the explicit theme combination of brand and style.
- Treat section order in the page spec as final unless the spec explicitly allows reordering.
- For icon-only actions, keep the accessibility label in the handoff.
- When a property is unknown in Figma, preserve the intent in a note instead of silently dropping it.

## Accessibility Notes
- Focus should land on the dialog before the background content.
- The stacked actions should read in destructive-to-safe order.

## Implementation Notes
- Treat the background surface as dimmed context and the dialog as the primary focus.
- Keep all actions full width and vertically stacked.

## Machine-Readable Page Spec
```yaml
page_id: alerts.dialog.warning.generated
page_name: AI Generated Warning Dialog
page_type: alerts
description: Warning dialog overlay with stacked actions using the alert.dialog pattern.
theme:
  brand: mistyRose
  style: darkRounded
sections:
- id: alerts.dialog
  pattern_id: alert.dialog
  title: Warning dialog
  component_refs:
  - alerts.dialog.surface
  - alerts.dialog.modal
  - alerts.dialog.primary
  - alerts.dialog.secondary
  - alerts.dialog.cancel
components:
- id: alerts.dialog.surface
  component: DSCard
  role: overlay_surface
  props:
    background: surfaceNeutral2
    radius: radiusXl
    padding: spacingXl
- id: alerts.dialog.modal
  component: DSAlertDialog
  role: modal_alert
  props:
    title: HaHo's been a battery hog!
    message: Keep going and risk a system tantrum, or take a break? Your call.
    severity: warning
    icon: batterySlash
- id: alerts.dialog.primary
  component: DSButton
  role: primary_cta
  variant: filledA
  size: medium
  props:
    label: Delete App
    iconRight: log.out
    isFullWidth: true
- id: alerts.dialog.secondary
  component: DSButton
  role: secondary_cta
  variant: neutral
  size: medium
  props:
    label: Disable Background Usage
    isFullWidth: true
- id: alerts.dialog.cancel
  component: DSButton
  role: dismiss_action
  variant: neutral
  size: medium
  props:
    label: Cancel
    isFullWidth: true
accessibility:
  notes:
  - Focus should land on the dialog before the background content.
  - The stacked actions should read in destructive-to-safe order.
implementation_notes:
- Treat the background surface as dimmed context and the dialog as the primary focus.
- Keep all actions full width and vertically stacked.
```

## Machine-Readable Figma Payload
```json
{
  "meta": {
    "generator": "HaHo AI page-spec transformer",
    "contractVersion": 0.1,
    "mappingVersion": 0.1
  },
  "page": {
    "id": "alerts.dialog.warning.generated",
    "name": "AI Generated Warning Dialog",
    "type": "alerts",
    "description": "Warning dialog overlay with stacked actions using the alert.dialog pattern.",
    "theme": {
      "brand": "mistyRose",
      "style": "darkRounded"
    }
  },
  "figma": {
    "rootPageNodeType": "PAGE",
    "screenNodeType": "FRAME",
    "screenFrame": {
      "name": "AI Generated Warning Dialog",
      "layoutMode": "VERTICAL",
      "primaryAxisSizingMode": "AUTO",
      "counterAxisSizingMode": "FIXED"
    },
    "sections": [
      {
        "id": "alerts.dialog",
        "patternId": "alert.dialog",
        "title": "Warning dialog",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "alerts.dialog.surface",
            "nodeType": "INSTANCE",
            "component": "DSCard",
            "figmaComponent": "Card",
            "role": "overlay_surface",
            "variantProperties": {},
            "componentProperties": {
              "Background": "surfaceNeutral2",
              "Radius": "radiusXl",
              "Padding": "spacingXl"
            },
            "accessibility": {}
          },
          {
            "id": "alerts.dialog.modal",
            "nodeType": "INSTANCE",
            "component": "DSAlertDialog",
            "figmaComponent": "Alert Dialog",
            "role": "modal_alert",
            "variantProperties": {},
            "componentProperties": {
              "Title": "HaHo's been a battery hog!",
              "Message": "Keep going and risk a system tantrum, or take a break? Your call.",
              "Severity": "warning",
              "Icon": "batterySlash"
            },
            "accessibility": {}
          },
          {
            "id": "alerts.dialog.primary",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "primary_cta",
            "variantProperties": {
              "Variant": "filledA",
              "Size": "medium",
              "Content": "text+icon"
            },
            "componentProperties": {
              "Label": "Delete App",
              "Right icon": "log.out",
              "Full width": true
            },
            "accessibility": {}
          },
          {
            "id": "alerts.dialog.secondary",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "secondary_cta",
            "variantProperties": {
              "Variant": "neutral",
              "Size": "medium",
              "Content": "text"
            },
            "componentProperties": {
              "Label": "Disable Background Usage",
              "Full width": true
            },
            "accessibility": {}
          },
          {
            "id": "alerts.dialog.cancel",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "dismiss_action",
            "variantProperties": {
              "Variant": "neutral",
              "Size": "medium",
              "Content": "text"
            },
            "componentProperties": {
              "Label": "Cancel",
              "Full width": true
            },
            "accessibility": {}
          }
        ]
      }
    ],
    "instances": [
      {
        "id": "alerts.dialog.surface",
        "nodeType": "INSTANCE",
        "component": "DSCard",
        "figmaComponent": "Card",
        "role": "overlay_surface",
        "variantProperties": {},
        "componentProperties": {
          "Background": "surfaceNeutral2",
          "Radius": "radiusXl",
          "Padding": "spacingXl"
        },
        "accessibility": {}
      },
      {
        "id": "alerts.dialog.modal",
        "nodeType": "INSTANCE",
        "component": "DSAlertDialog",
        "figmaComponent": "Alert Dialog",
        "role": "modal_alert",
        "variantProperties": {},
        "componentProperties": {
          "Title": "HaHo's been a battery hog!",
          "Message": "Keep going and risk a system tantrum, or take a break? Your call.",
          "Severity": "warning",
          "Icon": "batterySlash"
        },
        "accessibility": {}
      },
      {
        "id": "alerts.dialog.primary",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "primary_cta",
        "variantProperties": {
          "Variant": "filledA",
          "Size": "medium",
          "Content": "text+icon"
        },
        "componentProperties": {
          "Label": "Delete App",
          "Right icon": "log.out",
          "Full width": true
        },
        "accessibility": {}
      },
      {
        "id": "alerts.dialog.secondary",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "secondary_cta",
        "variantProperties": {
          "Variant": "neutral",
          "Size": "medium",
          "Content": "text"
        },
        "componentProperties": {
          "Label": "Disable Background Usage",
          "Full width": true
        },
        "accessibility": {}
      },
      {
        "id": "alerts.dialog.cancel",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "dismiss_action",
        "variantProperties": {
          "Variant": "neutral",
          "Size": "medium",
          "Content": "text"
        },
        "componentProperties": {
          "Label": "Cancel",
          "Full width": true
        },
        "accessibility": {}
      }
    ]
  },
  "copy": [],
  "assets": [],
  "accessibility": {
    "notes": [
      "Focus should land on the dialog before the background content.",
      "The stacked actions should read in destructive-to-safe order."
    ]
  },
  "implementation_notes": [
    "Treat the background surface as dimmed context and the dialog as the primary focus.",
    "Keep all actions full width and vertically stacked."
  ]
}
```

## Playground Rules Payload
```yaml
version: 0.1
target: figma-playground
goal: 'Give an external AI enough precision to compose a new screen in Figma Playground
  using the HaHo design system without reading Swift source.

  '
execution_model:
  input_order:
  - read_theme
  - read_page_goal
  - read_sections
  - instantiate_components
  - apply_layout
  - apply_copy
  - check_accessibility
  output_shape:
  - one mobile screen unless spec says otherwise
  - use auto-layout frames for screen and sections
  - prefer component instances over redrawn primitives
hard_rules:
- Never invent a new component when a registered DS component already covers the job.
- Never use raw spacing, radius, or colors outside the registered token names in the
  page spec.
- Always preserve the explicit theme combination of brand and style.
- Treat section order in the page spec as final unless the spec explicitly allows
  reordering.
- For icon-only actions, keep the accessibility label in the handoff.
- When a property is unknown in Figma, preserve the intent in a note instead of silently
  dropping it.
layout_rules:
  screen:
    device: iPhone portrait
    width_px: 390
    min_height_px: 844
    outer_padding_px: 24
    section_gap_px: 16
  section:
    layout: vertical
    item_gap_px: 12
    stretch_children: true
  cards:
    prefer_component_instance: true
    avoid_manual_rectangle_reconstruction: true
  buttons:
    full_width_means_horizontal_fill: true
  text_fields:
    stack_label_and_control_in_component: true
interpretation_rules:
  component_priority:
  - DSCard
  - DSButton
  - DSTextField
  - DSCheckbox
  - DSText
  pattern_behavior:
    auth.form-card:
      notes:
      - Card-backed auth form with one clear primary CTA.
      - Keep text fields vertically stacked.
      - Social sign-in belongs in its own section when present.
    auth.social-sign-in:
      notes:
      - Keep provider actions visually balanced.
      - Prefer equal-width controls.
    alert.banner:
      notes:
      - Feedback should feel immediate and compact.
    profile.hero:
      notes:
      - Lead with media or summary content before secondary stats.
failure_behavior:
- If a component instance cannot be found in Playground, create the closest semantic
  placeholder and label it with the DS component name.
- If an icon asset cannot be resolved, keep the button and annotate the missing icon
  name.
- If nested slot content is ambiguous, preserve hierarchy and add a short implementation
  note.
review_checklist:
- Theme is explicit and unchanged.
- All sections from the spec exist in the output.
- All component ids map to one visual element or instance.
- No raw custom button visuals replaced DSButton.
- Accessibility notes from the spec are preserved.
```

## Final Instruction To Playground
Create this screen as a clean iPhone portrait layout using registered design-system components and auto-layout frames. Do not invent new primitives unless the exact component is unavailable.
