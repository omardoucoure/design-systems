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
- Page type: `auth`
- Page name: `AI Generated Verification`
- Description: Verification screen using the auth.verification pattern with supporting legal copy.

## Section Blueprint
- `auth.verify` uses pattern `auth.verification` and renders as a vertical section frame.
  Title: Verify identity
  Component order: `auth.verify.card`, `auth.verify.appbar`, `auth.verify.heading`, `auth.verify.body`, `auth.verify.code`, `auth.verify.resend`, `auth.verify.next`, `auth.verify.terms`
  - `auth.verify.card` => `DSCard` role `section_card` (default) with props {"background": "surfaceNeutral2", "padding": "spacingXl", "radius": "radiusXl"}
  - `auth.verify.appbar` => `DSTopAppBar` role `page_header` (default) with props {"title": "Forgot password"}
  - `auth.verify.heading` => `DSText` role `heading` (default) with props {"color_token": "textNeutral9", "style_token": "h4", "text": "Verify your identity"}
  - `auth.verify.body` => `DSText` role `supporting_copy` (default) with props {"color_token": "textNeutral9", "style_token": "caption", "text": "An authentication code has been sent to hristov123@gmail.com"}
  - `auth.verify.code` => `DSCodeInput` role `verification` (default) with props {"code": "", "digitCount": 4}
  - `auth.verify.resend` => `DSButton` role `tertiary_action` (variant=text, size=medium) with props {"label": "Resend Code"}
  - `auth.verify.next` => `DSButton` role `primary_cta` (variant=filledA, size=big) with props {"iconRight": "arrow.right", "isFullWidth": true, "label": "Next"}
  - `auth.verify.terms` => `DSButton` role `tertiary_action` (variant=text, size=medium) with props {"label": "Terms and Conditions"}

## Component Mapping Summary
- `auth.verify.card` maps `DSCard` to Figma component `Card`.
- `auth.verify.appbar` maps `DSTopAppBar` to Figma component `Top App Bar`.
- `auth.verify.heading` maps `DSText` to Figma component `Text Primitive`.
- `auth.verify.body` maps `DSText` to Figma component `Text Primitive`.
- `auth.verify.code` maps `DSCodeInput` to Figma component `Code Input`.
- `auth.verify.resend` maps `DSButton` to Figma component `Button`.
- `auth.verify.next` maps `DSButton` to Figma component `Button`.
- `auth.verify.terms` maps `DSButton` to Figma component `Button`.

## Playground-Specific Rules
- Never invent a new component when a registered DS component already covers the job.
- Never use raw spacing, radius, or colors outside the registered token names in the page spec.
- Always preserve the explicit theme combination of brand and style.
- Treat section order in the page spec as final unless the spec explicitly allows reordering.
- For icon-only actions, keep the accessibility label in the handoff.
- When a property is unknown in Figma, preserve the intent in a note instead of silently dropping it.

## Accessibility Notes
- The verification code input should expose each digit field in reading order.
- The resend code action should remain discoverable as a secondary text action.

## Implementation Notes
- Keep the verification flow card-backed and vertically stacked.
- Preserve the supporting legal copy below the primary CTA.

## Machine-Readable Page Spec
```yaml
page_id: auth.verification.generated
page_name: AI Generated Verification
page_type: auth
description: Verification screen using the auth.verification pattern with supporting
  legal copy.
theme:
  brand: seaLime
  style: lightRounded
sections:
- id: auth.verify
  pattern_id: auth.verification
  title: Verify identity
  component_refs:
  - auth.verify.card
  - auth.verify.appbar
  - auth.verify.heading
  - auth.verify.body
  - auth.verify.code
  - auth.verify.resend
  - auth.verify.next
  - auth.verify.terms
components:
- id: auth.verify.card
  component: DSCard
  role: section_card
  props:
    background: surfaceNeutral2
    radius: radiusXl
    padding: spacingXl
- id: auth.verify.appbar
  component: DSTopAppBar
  role: page_header
  props:
    title: Forgot password
- id: auth.verify.heading
  component: DSText
  role: heading
  props:
    text: Verify your identity
    style_token: h4
    color_token: textNeutral9
- id: auth.verify.body
  component: DSText
  role: supporting_copy
  props:
    text: An authentication code has been sent to hristov123@gmail.com
    style_token: caption
    color_token: textNeutral9
- id: auth.verify.code
  component: DSCodeInput
  role: verification
  props:
    digitCount: 4
    code: ''
- id: auth.verify.resend
  component: DSButton
  role: tertiary_action
  variant: text
  size: medium
  props:
    label: Resend Code
- id: auth.verify.next
  component: DSButton
  role: primary_cta
  variant: filledA
  size: big
  props:
    label: Next
    iconRight: arrow.right
    isFullWidth: true
- id: auth.verify.terms
  component: DSButton
  role: tertiary_action
  variant: text
  size: medium
  props:
    label: Terms and Conditions
copy:
- id: auth.verify.caption
  text: I didn't receive code?
  style_token: bodyRegular
  color_token: textNeutral9
- id: auth.verify.legal
  text: By Signing In, you agree to our
  style_token: bodyRegular
  color_token: textNeutral9
accessibility:
  notes:
  - The verification code input should expose each digit field in reading order.
  - The resend code action should remain discoverable as a secondary text action.
implementation_notes:
- Keep the verification flow card-backed and vertically stacked.
- Preserve the supporting legal copy below the primary CTA.
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
    "id": "auth.verification.generated",
    "name": "AI Generated Verification",
    "type": "auth",
    "description": "Verification screen using the auth.verification pattern with supporting legal copy.",
    "theme": {
      "brand": "seaLime",
      "style": "lightRounded"
    }
  },
  "figma": {
    "rootPageNodeType": "PAGE",
    "screenNodeType": "FRAME",
    "screenFrame": {
      "name": "AI Generated Verification",
      "layoutMode": "VERTICAL",
      "primaryAxisSizingMode": "AUTO",
      "counterAxisSizingMode": "FIXED"
    },
    "sections": [
      {
        "id": "auth.verify",
        "patternId": "auth.verification",
        "title": "Verify identity",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "auth.verify.card",
            "nodeType": "INSTANCE",
            "component": "DSCard",
            "figmaComponent": "Card",
            "role": "section_card",
            "variantProperties": {},
            "componentProperties": {
              "Background": "surfaceNeutral2",
              "Radius": "radiusXl",
              "Padding": "spacingXl"
            },
            "accessibility": {}
          },
          {
            "id": "auth.verify.appbar",
            "nodeType": "INSTANCE",
            "component": "DSTopAppBar",
            "figmaComponent": "Top App Bar",
            "role": "page_header",
            "variantProperties": {},
            "componentProperties": {
              "Title": "Forgot password"
            },
            "accessibility": {}
          },
          {
            "id": "auth.verify.heading",
            "nodeType": "INSTANCE",
            "component": "DSText",
            "figmaComponent": "Text Primitive",
            "role": "heading",
            "variantProperties": {},
            "componentProperties": {
              "Text": "Verify your identity",
              "style_token": "h4",
              "color_token": "textNeutral9"
            },
            "accessibility": {}
          },
          {
            "id": "auth.verify.body",
            "nodeType": "INSTANCE",
            "component": "DSText",
            "figmaComponent": "Text Primitive",
            "role": "supporting_copy",
            "variantProperties": {},
            "componentProperties": {
              "Text": "An authentication code has been sent to hristov123@gmail.com",
              "style_token": "caption",
              "color_token": "textNeutral9"
            },
            "accessibility": {}
          },
          {
            "id": "auth.verify.code",
            "nodeType": "INSTANCE",
            "component": "DSCodeInput",
            "figmaComponent": "Code Input",
            "role": "verification",
            "variantProperties": {},
            "componentProperties": {
              "Digits": 4,
              "Value": ""
            },
            "accessibility": {}
          },
          {
            "id": "auth.verify.resend",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "tertiary_action",
            "variantProperties": {
              "Variant": "text",
              "Size": "medium",
              "Content": "text"
            },
            "componentProperties": {
              "Label": "Resend Code"
            },
            "accessibility": {}
          },
          {
            "id": "auth.verify.next",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "primary_cta",
            "variantProperties": {
              "Variant": "filledA",
              "Size": "big",
              "Content": "text+icon"
            },
            "componentProperties": {
              "Label": "Next",
              "Right icon": "arrow.right",
              "Full width": true
            },
            "accessibility": {}
          },
          {
            "id": "auth.verify.terms",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "tertiary_action",
            "variantProperties": {
              "Variant": "text",
              "Size": "medium",
              "Content": "text"
            },
            "componentProperties": {
              "Label": "Terms and Conditions"
            },
            "accessibility": {}
          }
        ]
      }
    ],
    "instances": [
      {
        "id": "auth.verify.card",
        "nodeType": "INSTANCE",
        "component": "DSCard",
        "figmaComponent": "Card",
        "role": "section_card",
        "variantProperties": {},
        "componentProperties": {
          "Background": "surfaceNeutral2",
          "Radius": "radiusXl",
          "Padding": "spacingXl"
        },
        "accessibility": {}
      },
      {
        "id": "auth.verify.appbar",
        "nodeType": "INSTANCE",
        "component": "DSTopAppBar",
        "figmaComponent": "Top App Bar",
        "role": "page_header",
        "variantProperties": {},
        "componentProperties": {
          "Title": "Forgot password"
        },
        "accessibility": {}
      },
      {
        "id": "auth.verify.heading",
        "nodeType": "INSTANCE",
        "component": "DSText",
        "figmaComponent": "Text Primitive",
        "role": "heading",
        "variantProperties": {},
        "componentProperties": {
          "Text": "Verify your identity",
          "style_token": "h4",
          "color_token": "textNeutral9"
        },
        "accessibility": {}
      },
      {
        "id": "auth.verify.body",
        "nodeType": "INSTANCE",
        "component": "DSText",
        "figmaComponent": "Text Primitive",
        "role": "supporting_copy",
        "variantProperties": {},
        "componentProperties": {
          "Text": "An authentication code has been sent to hristov123@gmail.com",
          "style_token": "caption",
          "color_token": "textNeutral9"
        },
        "accessibility": {}
      },
      {
        "id": "auth.verify.code",
        "nodeType": "INSTANCE",
        "component": "DSCodeInput",
        "figmaComponent": "Code Input",
        "role": "verification",
        "variantProperties": {},
        "componentProperties": {
          "Digits": 4,
          "Value": ""
        },
        "accessibility": {}
      },
      {
        "id": "auth.verify.resend",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "tertiary_action",
        "variantProperties": {
          "Variant": "text",
          "Size": "medium",
          "Content": "text"
        },
        "componentProperties": {
          "Label": "Resend Code"
        },
        "accessibility": {}
      },
      {
        "id": "auth.verify.next",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "primary_cta",
        "variantProperties": {
          "Variant": "filledA",
          "Size": "big",
          "Content": "text+icon"
        },
        "componentProperties": {
          "Label": "Next",
          "Right icon": "arrow.right",
          "Full width": true
        },
        "accessibility": {}
      },
      {
        "id": "auth.verify.terms",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "tertiary_action",
        "variantProperties": {
          "Variant": "text",
          "Size": "medium",
          "Content": "text"
        },
        "componentProperties": {
          "Label": "Terms and Conditions"
        },
        "accessibility": {}
      }
    ]
  },
  "copy": [
    {
      "id": "auth.verify.caption",
      "text": "I didn't receive code?",
      "style_token": "bodyRegular",
      "color_token": "textNeutral9"
    },
    {
      "id": "auth.verify.legal",
      "text": "By Signing In, you agree to our",
      "style_token": "bodyRegular",
      "color_token": "textNeutral9"
    }
  ],
  "assets": [],
  "accessibility": {
    "notes": [
      "The verification code input should expose each digit field in reading order.",
      "The resend code action should remain discoverable as a secondary text action."
    ]
  },
  "implementation_notes": [
    "Keep the verification flow card-backed and vertically stacked.",
    "Preserve the supporting legal copy below the primary CTA."
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
