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
- Brand: `coralCamo`
- Style: `darkSharp`
- Page type: `walkthrough`
- Page name: `AI Generated Onboarding`
- Description: Onboarding walkthrough screen using card-backed messaging, page control, and navigation actions.

## Section Blueprint
- `walkthrough.hero` uses pattern `onboarding.walkthrough` and renders as a vertical section frame.
  Title: Walkthrough hero
  Component order: `walkthrough.hero.card`, `walkthrough.hero.heading`, `walkthrough.hero.divider`, `walkthrough.hero.body`, `walkthrough.hero.progress`, `walkthrough.hero.prev`, `walkthrough.hero.next`
  - `walkthrough.hero.card` => `DSCard` role `hero_surface` (default) with props {"background": "surfaceNeutral2", "padding": "spacingXl", "radius": "radiusXl"}
  - `walkthrough.hero.heading` => `DSText` role `heading` (default) with props {"color_token": "textNeutral9", "style_token": "display2", "text": "Design Systems That Scale. Build once, use everywhere with confidence."}
  - `walkthrough.hero.divider` => `DSDivider` role `separator` (default) with props {"label": ""}
  - `walkthrough.hero.body` => `DSText` role `supporting_copy` (default) with props {"color_token": "textNeutral9", "style_token": "bodyRegular", "text": "Consistency across every screen."}
  - `walkthrough.hero.progress` => `DSPageControl` role `onboarding_progress` (default) with props {"count": 3, "currentIndex": 1}
  - `walkthrough.hero.prev` => `DSButton` role `toolbar_action` (variant=filledA, size=big) with props {"systemIcon": "arrow.left"}
  - `walkthrough.hero.next` => `DSButton` role `toolbar_action` (variant=filledA, size=big) with props {"systemIcon": "arrow.right"}
- `walkthrough.footer` uses pattern `onboarding.walkthrough` and renders as a vertical section frame.
  Title: Walkthrough footer
  Component order: `walkthrough.footer.card`, `walkthrough.footer.caption`, `walkthrough.footer.skip`
  - `walkthrough.footer.card` => `DSCard` role `footer_surface` (default) with props {"background": "surfacePrimary100", "padding": "spacingXl", "radius": "radiusXl"}
  - `walkthrough.footer.caption` => `DSText` role `supporting_copy` (default) with props {"color_token": "textNeutral0_5", "style_token": "bodyRegular", "text": "For designers who dare to think differently."}
  - `walkthrough.footer.skip` => `DSButton` role `secondary_cta` (variant=filledA, size=medium) with props {"label": "Skip"}

## Component Mapping Summary
- `walkthrough.hero.card` maps `DSCard` to Figma component `Card`.
- `walkthrough.hero.heading` maps `DSText` to Figma component `Text Primitive`.
- `walkthrough.hero.divider` maps `DSDivider` to Figma component `Divider`.
- `walkthrough.hero.body` maps `DSText` to Figma component `Text Primitive`.
- `walkthrough.hero.progress` maps `DSPageControl` to Figma component `Page Control`.
- `walkthrough.hero.prev` maps `DSButton` to Figma component `Button`.
- `walkthrough.hero.next` maps `DSButton` to Figma component `Button`.
- `walkthrough.footer.card` maps `DSCard` to Figma component `Card`.
- `walkthrough.footer.caption` maps `DSText` to Figma component `Text Primitive`.
- `walkthrough.footer.skip` maps `DSButton` to Figma component `Button`.

## Playground-Specific Rules
- Never invent a new component when a registered DS component already covers the job.
- Never use raw spacing, radius, or colors outside the registered token names in the page spec.
- Always preserve the explicit theme combination of brand and style.
- Treat section order in the page spec as final unless the spec explicitly allows reordering.
- For icon-only actions, keep the accessibility label in the handoff.
- When a property is unknown in Figma, preserve the intent in a note instead of silently dropping it.

## Accessibility Notes
- The previous and next actions are icon-only and need explicit accessibility labels.
- Keep onboarding progress exposed as a distinct page-control element.

## Implementation Notes
- The hero card should dominate the screen vertically.
- The footer card is a compact secondary section with one supporting CTA.

## Machine-Readable Page Spec
```yaml
page_id: walkthrough.onboarding.generated
page_name: AI Generated Onboarding
page_type: walkthrough
description: Onboarding walkthrough screen using card-backed messaging, page control,
  and navigation actions.
theme:
  brand: coralCamo
  style: darkSharp
sections:
- id: walkthrough.hero
  pattern_id: onboarding.walkthrough
  title: Walkthrough hero
  component_refs:
  - walkthrough.hero.card
  - walkthrough.hero.heading
  - walkthrough.hero.divider
  - walkthrough.hero.body
  - walkthrough.hero.progress
  - walkthrough.hero.prev
  - walkthrough.hero.next
- id: walkthrough.footer
  pattern_id: onboarding.walkthrough
  title: Walkthrough footer
  component_refs:
  - walkthrough.footer.card
  - walkthrough.footer.caption
  - walkthrough.footer.skip
components:
- id: walkthrough.hero.card
  component: DSCard
  role: hero_surface
  props:
    background: surfaceNeutral2
    radius: radiusXl
    padding: spacingXl
- id: walkthrough.hero.heading
  component: DSText
  role: heading
  props:
    text: Design Systems That Scale. Build once, use everywhere with confidence.
    style_token: display2
    color_token: textNeutral9
- id: walkthrough.hero.divider
  component: DSDivider
  role: separator
  props:
    label: ''
- id: walkthrough.hero.body
  component: DSText
  role: supporting_copy
  props:
    text: Consistency across every screen.
    style_token: bodyRegular
    color_token: textNeutral9
- id: walkthrough.hero.progress
  component: DSPageControl
  role: onboarding_progress
  props:
    count: 3
    currentIndex: 1
- id: walkthrough.hero.prev
  component: DSButton
  role: toolbar_action
  variant: filledA
  size: big
  props:
    systemIcon: arrow.left
  accessibility:
    label: Previous page
- id: walkthrough.hero.next
  component: DSButton
  role: toolbar_action
  variant: filledA
  size: big
  props:
    systemIcon: arrow.right
  accessibility:
    label: Next page
- id: walkthrough.footer.card
  component: DSCard
  role: footer_surface
  props:
    background: surfacePrimary100
    radius: radiusXl
    padding: spacingXl
- id: walkthrough.footer.caption
  component: DSText
  role: supporting_copy
  props:
    text: For designers who dare to think differently.
    style_token: bodyRegular
    color_token: textNeutral0_5
- id: walkthrough.footer.skip
  component: DSButton
  role: secondary_cta
  variant: filledA
  size: medium
  props:
    label: Skip
accessibility:
  notes:
  - The previous and next actions are icon-only and need explicit accessibility labels.
  - Keep onboarding progress exposed as a distinct page-control element.
implementation_notes:
- The hero card should dominate the screen vertically.
- The footer card is a compact secondary section with one supporting CTA.
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
    "id": "walkthrough.onboarding.generated",
    "name": "AI Generated Onboarding",
    "type": "walkthrough",
    "description": "Onboarding walkthrough screen using card-backed messaging, page control, and navigation actions.",
    "theme": {
      "brand": "coralCamo",
      "style": "darkSharp"
    }
  },
  "figma": {
    "rootPageNodeType": "PAGE",
    "screenNodeType": "FRAME",
    "screenFrame": {
      "name": "AI Generated Onboarding",
      "layoutMode": "VERTICAL",
      "primaryAxisSizingMode": "AUTO",
      "counterAxisSizingMode": "FIXED"
    },
    "sections": [
      {
        "id": "walkthrough.hero",
        "patternId": "onboarding.walkthrough",
        "title": "Walkthrough hero",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "walkthrough.hero.card",
            "nodeType": "INSTANCE",
            "component": "DSCard",
            "figmaComponent": "Card",
            "role": "hero_surface",
            "variantProperties": {},
            "componentProperties": {
              "Background": "surfaceNeutral2",
              "Radius": "radiusXl",
              "Padding": "spacingXl"
            },
            "accessibility": {}
          },
          {
            "id": "walkthrough.hero.heading",
            "nodeType": "INSTANCE",
            "component": "DSText",
            "figmaComponent": "Text Primitive",
            "role": "heading",
            "variantProperties": {},
            "componentProperties": {
              "Text": "Design Systems That Scale. Build once, use everywhere with confidence.",
              "style_token": "display2",
              "color_token": "textNeutral9"
            },
            "accessibility": {}
          },
          {
            "id": "walkthrough.hero.divider",
            "nodeType": "INSTANCE",
            "component": "DSDivider",
            "figmaComponent": "Divider",
            "role": "separator",
            "variantProperties": {},
            "componentProperties": {
              "Label": ""
            },
            "accessibility": {}
          },
          {
            "id": "walkthrough.hero.body",
            "nodeType": "INSTANCE",
            "component": "DSText",
            "figmaComponent": "Text Primitive",
            "role": "supporting_copy",
            "variantProperties": {},
            "componentProperties": {
              "Text": "Consistency across every screen.",
              "style_token": "bodyRegular",
              "color_token": "textNeutral9"
            },
            "accessibility": {}
          },
          {
            "id": "walkthrough.hero.progress",
            "nodeType": "INSTANCE",
            "component": "DSPageControl",
            "figmaComponent": "Page Control",
            "role": "onboarding_progress",
            "variantProperties": {},
            "componentProperties": {
              "Count": 3,
              "Current index": 1
            },
            "accessibility": {}
          },
          {
            "id": "walkthrough.hero.prev",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "toolbar_action",
            "variantProperties": {
              "Variant": "filledA",
              "Size": "big",
              "Content": "text"
            },
            "componentProperties": {
              "System icon": "arrow.left"
            },
            "accessibility": {
              "label": "Previous page"
            }
          },
          {
            "id": "walkthrough.hero.next",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "toolbar_action",
            "variantProperties": {
              "Variant": "filledA",
              "Size": "big",
              "Content": "text"
            },
            "componentProperties": {
              "System icon": "arrow.right"
            },
            "accessibility": {
              "label": "Next page"
            }
          }
        ]
      },
      {
        "id": "walkthrough.footer",
        "patternId": "onboarding.walkthrough",
        "title": "Walkthrough footer",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "walkthrough.footer.card",
            "nodeType": "INSTANCE",
            "component": "DSCard",
            "figmaComponent": "Card",
            "role": "footer_surface",
            "variantProperties": {},
            "componentProperties": {
              "Background": "surfacePrimary100",
              "Radius": "radiusXl",
              "Padding": "spacingXl"
            },
            "accessibility": {}
          },
          {
            "id": "walkthrough.footer.caption",
            "nodeType": "INSTANCE",
            "component": "DSText",
            "figmaComponent": "Text Primitive",
            "role": "supporting_copy",
            "variantProperties": {},
            "componentProperties": {
              "Text": "For designers who dare to think differently.",
              "style_token": "bodyRegular",
              "color_token": "textNeutral0_5"
            },
            "accessibility": {}
          },
          {
            "id": "walkthrough.footer.skip",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "secondary_cta",
            "variantProperties": {
              "Variant": "filledA",
              "Size": "medium",
              "Content": "text"
            },
            "componentProperties": {
              "Label": "Skip"
            },
            "accessibility": {}
          }
        ]
      }
    ],
    "instances": [
      {
        "id": "walkthrough.hero.card",
        "nodeType": "INSTANCE",
        "component": "DSCard",
        "figmaComponent": "Card",
        "role": "hero_surface",
        "variantProperties": {},
        "componentProperties": {
          "Background": "surfaceNeutral2",
          "Radius": "radiusXl",
          "Padding": "spacingXl"
        },
        "accessibility": {}
      },
      {
        "id": "walkthrough.hero.heading",
        "nodeType": "INSTANCE",
        "component": "DSText",
        "figmaComponent": "Text Primitive",
        "role": "heading",
        "variantProperties": {},
        "componentProperties": {
          "Text": "Design Systems That Scale. Build once, use everywhere with confidence.",
          "style_token": "display2",
          "color_token": "textNeutral9"
        },
        "accessibility": {}
      },
      {
        "id": "walkthrough.hero.divider",
        "nodeType": "INSTANCE",
        "component": "DSDivider",
        "figmaComponent": "Divider",
        "role": "separator",
        "variantProperties": {},
        "componentProperties": {
          "Label": ""
        },
        "accessibility": {}
      },
      {
        "id": "walkthrough.hero.body",
        "nodeType": "INSTANCE",
        "component": "DSText",
        "figmaComponent": "Text Primitive",
        "role": "supporting_copy",
        "variantProperties": {},
        "componentProperties": {
          "Text": "Consistency across every screen.",
          "style_token": "bodyRegular",
          "color_token": "textNeutral9"
        },
        "accessibility": {}
      },
      {
        "id": "walkthrough.hero.progress",
        "nodeType": "INSTANCE",
        "component": "DSPageControl",
        "figmaComponent": "Page Control",
        "role": "onboarding_progress",
        "variantProperties": {},
        "componentProperties": {
          "Count": 3,
          "Current index": 1
        },
        "accessibility": {}
      },
      {
        "id": "walkthrough.hero.prev",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "toolbar_action",
        "variantProperties": {
          "Variant": "filledA",
          "Size": "big",
          "Content": "text"
        },
        "componentProperties": {
          "System icon": "arrow.left"
        },
        "accessibility": {
          "label": "Previous page"
        }
      },
      {
        "id": "walkthrough.hero.next",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "toolbar_action",
        "variantProperties": {
          "Variant": "filledA",
          "Size": "big",
          "Content": "text"
        },
        "componentProperties": {
          "System icon": "arrow.right"
        },
        "accessibility": {
          "label": "Next page"
        }
      },
      {
        "id": "walkthrough.footer.card",
        "nodeType": "INSTANCE",
        "component": "DSCard",
        "figmaComponent": "Card",
        "role": "footer_surface",
        "variantProperties": {},
        "componentProperties": {
          "Background": "surfacePrimary100",
          "Radius": "radiusXl",
          "Padding": "spacingXl"
        },
        "accessibility": {}
      },
      {
        "id": "walkthrough.footer.caption",
        "nodeType": "INSTANCE",
        "component": "DSText",
        "figmaComponent": "Text Primitive",
        "role": "supporting_copy",
        "variantProperties": {},
        "componentProperties": {
          "Text": "For designers who dare to think differently.",
          "style_token": "bodyRegular",
          "color_token": "textNeutral0_5"
        },
        "accessibility": {}
      },
      {
        "id": "walkthrough.footer.skip",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "secondary_cta",
        "variantProperties": {
          "Variant": "filledA",
          "Size": "medium",
          "Content": "text"
        },
        "componentProperties": {
          "Label": "Skip"
        },
        "accessibility": {}
      }
    ]
  },
  "copy": [],
  "assets": [],
  "accessibility": {
    "notes": [
      "The previous and next actions are icon-only and need explicit accessibility labels.",
      "Keep onboarding progress exposed as a distinct page-control element."
    ]
  },
  "implementation_notes": [
    "The hero card should dominate the screen vertically.",
    "The footer card is a compact secondary section with one supporting CTA."
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
