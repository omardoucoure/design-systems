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
- Brand: `seaLime`
- Style: `lightRounded`
- Page type: `alerts`
- Page name: `AI Generated Warning Banner`
- Description: Alert screen using a dashboard metrics layout and an inline warning banner.

## Section Blueprint
- `dashboard.metrics` uses pattern `dashboard.metrics-grid` and renders as a vertical section frame.
  Title: Daily metrics
  Component order: `metrics.walk`, `metrics.water`, `metrics.heart`
  - `metrics.walk` => `DSMetricCard` role `dashboard_metric` (default) with props {"background": "surfacePrimary100", "icon": "walking", "title": "Walk"}
  - `metrics.water` => `DSMetricCard` role `dashboard_metric` (default) with props {"background": "surfaceSecondary100", "icon": "droplet", "title": "Water"}
  - `metrics.heart` => `DSMetricCard` role `dashboard_metric` (default) with props {"background": "surfaceNeutral3", "icon": "heart", "title": "Heart"}
- `alert.banner` uses pattern `alert.banner` and renders as a vertical section frame.
  Title: Warning banner
  Component order: `alert.banner.container`, `alert.banner.close`
  - `alert.banner.container` => `DSBanner` role `banner_notice` (default) with props {"background": "warning", "message": "You're about to step into uncharted territory. Proceed with caution.", "title": "Heads up!"}
  - `alert.banner.close` => `DSButton` role `dismiss_action` (variant=text, size=medium) with props {"icon": "xmark"}

## Component Mapping Summary
- `metrics.walk` maps `DSMetricCard` to Figma component `Metric Card`.
- `metrics.water` maps `DSMetricCard` to Figma component `Metric Card`.
- `metrics.heart` maps `DSMetricCard` to Figma component `Metric Card`.
- `alert.banner.container` maps `DSBanner` to Figma component `Banner`.
- `alert.banner.close` maps `DSButton` to Figma component `Button`.

## Playground-Specific Rules
- Never invent a new component when a registered DS component already covers the job.
- Never use raw spacing, radius, or colors outside the registered token names in the page spec.
- Always preserve the explicit theme combination of brand and style.
- Treat section order in the page spec as final unless the spec explicitly allows reordering.
- For icon-only actions, keep the accessibility label in the handoff.
- When a property is unknown in Figma, preserve the intent in a note instead of silently dropping it.

## Accessibility Notes
- Dismiss action is icon-only and must expose a label.
- Warning state is communicated with both iconography and copy, not only color.

## Implementation Notes
- Favor DSBanner semantics over a custom banner shell when possible.

## Machine-Readable Page Spec
```yaml
page_id: alerts.warning.generated
page_name: AI Generated Warning Banner
page_type: alerts
description: Alert screen using a dashboard metrics layout and an inline warning banner.
theme:
  brand: seaLime
  style: lightRounded
sections:
- id: dashboard.metrics
  pattern_id: dashboard.metrics-grid
  title: Daily metrics
  component_refs:
  - metrics.walk
  - metrics.water
  - metrics.heart
- id: alert.banner
  pattern_id: alert.banner
  title: Warning banner
  component_refs:
  - alert.banner.container
  - alert.banner.close
components:
- id: metrics.walk
  component: DSMetricCard
  role: dashboard_metric
  props:
    title: Walk
    icon: walking
    background: surfacePrimary100
- id: metrics.water
  component: DSMetricCard
  role: dashboard_metric
  props:
    title: Water
    icon: droplet
    background: surfaceSecondary100
- id: metrics.heart
  component: DSMetricCard
  role: dashboard_metric
  props:
    title: Heart
    icon: heart
    background: surfaceNeutral3
- id: alert.banner.container
  component: DSBanner
  role: banner_notice
  props:
    title: Heads up!
    message: You're about to step into uncharted territory. Proceed with caution.
    background: warning
- id: alert.banner.close
  component: DSButton
  role: dismiss_action
  variant: text
  size: medium
  props:
    icon: xmark
  accessibility:
    label: Close warning
accessibility:
  notes:
  - Dismiss action is icon-only and must expose a label.
  - Warning state is communicated with both iconography and copy, not only color.
implementation_notes:
- Favor DSBanner semantics over a custom banner shell when possible.
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
    "id": "alerts.warning.generated",
    "name": "AI Generated Warning Banner",
    "type": "alerts",
    "description": "Alert screen using a dashboard metrics layout and an inline warning banner.",
    "theme": {
      "brand": "seaLime",
      "style": "lightRounded"
    }
  },
  "figma": {
    "rootPageNodeType": "PAGE",
    "screenNodeType": "FRAME",
    "screenFrame": {
      "name": "AI Generated Warning Banner",
      "layoutMode": "VERTICAL",
      "primaryAxisSizingMode": "AUTO",
      "counterAxisSizingMode": "FIXED"
    },
    "sections": [
      {
        "id": "dashboard.metrics",
        "patternId": "dashboard.metrics-grid",
        "title": "Daily metrics",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "metrics.walk",
            "nodeType": "INSTANCE",
            "component": "DSMetricCard",
            "figmaComponent": "Metric Card",
            "role": "dashboard_metric",
            "variantProperties": {},
            "componentProperties": {
              "Title": "Walk",
              "Icon": "walking",
              "Background": "surfacePrimary100"
            },
            "accessibility": {}
          },
          {
            "id": "metrics.water",
            "nodeType": "INSTANCE",
            "component": "DSMetricCard",
            "figmaComponent": "Metric Card",
            "role": "dashboard_metric",
            "variantProperties": {},
            "componentProperties": {
              "Title": "Water",
              "Icon": "droplet",
              "Background": "surfaceSecondary100"
            },
            "accessibility": {}
          },
          {
            "id": "metrics.heart",
            "nodeType": "INSTANCE",
            "component": "DSMetricCard",
            "figmaComponent": "Metric Card",
            "role": "dashboard_metric",
            "variantProperties": {},
            "componentProperties": {
              "Title": "Heart",
              "Icon": "heart",
              "Background": "surfaceNeutral3"
            },
            "accessibility": {}
          }
        ]
      },
      {
        "id": "alert.banner",
        "patternId": "alert.banner",
        "title": "Warning banner",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "alert.banner.container",
            "nodeType": "INSTANCE",
            "component": "DSBanner",
            "figmaComponent": "Banner",
            "role": "banner_notice",
            "variantProperties": {},
            "componentProperties": {
              "Title": "Heads up!",
              "Message": "You're about to step into uncharted territory. Proceed with caution.",
              "background": "warning"
            },
            "accessibility": {}
          },
          {
            "id": "alert.banner.close",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "dismiss_action",
            "variantProperties": {
              "Variant": "text",
              "Size": "medium",
              "Content": "icon-only"
            },
            "componentProperties": {
              "icon": "xmark"
            },
            "accessibility": {
              "label": "Close warning"
            }
          }
        ]
      }
    ],
    "instances": [
      {
        "id": "metrics.walk",
        "nodeType": "INSTANCE",
        "component": "DSMetricCard",
        "figmaComponent": "Metric Card",
        "role": "dashboard_metric",
        "variantProperties": {},
        "componentProperties": {
          "Title": "Walk",
          "Icon": "walking",
          "Background": "surfacePrimary100"
        },
        "accessibility": {}
      },
      {
        "id": "metrics.water",
        "nodeType": "INSTANCE",
        "component": "DSMetricCard",
        "figmaComponent": "Metric Card",
        "role": "dashboard_metric",
        "variantProperties": {},
        "componentProperties": {
          "Title": "Water",
          "Icon": "droplet",
          "Background": "surfaceSecondary100"
        },
        "accessibility": {}
      },
      {
        "id": "metrics.heart",
        "nodeType": "INSTANCE",
        "component": "DSMetricCard",
        "figmaComponent": "Metric Card",
        "role": "dashboard_metric",
        "variantProperties": {},
        "componentProperties": {
          "Title": "Heart",
          "Icon": "heart",
          "Background": "surfaceNeutral3"
        },
        "accessibility": {}
      },
      {
        "id": "alert.banner.container",
        "nodeType": "INSTANCE",
        "component": "DSBanner",
        "figmaComponent": "Banner",
        "role": "banner_notice",
        "variantProperties": {},
        "componentProperties": {
          "Title": "Heads up!",
          "Message": "You're about to step into uncharted territory. Proceed with caution.",
          "background": "warning"
        },
        "accessibility": {}
      },
      {
        "id": "alert.banner.close",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "dismiss_action",
        "variantProperties": {
          "Variant": "text",
          "Size": "medium",
          "Content": "icon-only"
        },
        "componentProperties": {
          "icon": "xmark"
        },
        "accessibility": {
          "label": "Close warning"
        }
      }
    ]
  },
  "copy": [],
  "assets": [],
  "accessibility": {
    "notes": [
      "Dismiss action is icon-only and must expose a label.",
      "Warning state is communicated with both iconography and copy, not only color."
    ]
  },
  "implementation_notes": [
    "Favor DSBanner semantics over a custom banner shell when possible."
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
