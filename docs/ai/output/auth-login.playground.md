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
- Style: `lightRounded`
- Page type: `auth`
- Page name: `AI Generated Login`
- Description: Login screen using the auth form-card and social-sign-in patterns.

## Section Blueprint
- `auth.form` uses pattern `auth.form-card` and renders as a vertical section frame.
  Title: Sign in form
  Component order: `auth.form.card`, `auth.form.heading`, `auth.form.email`, `auth.form.password`, `auth.form.remember`, `auth.form.cta`
  - `auth.form.card` => `DSCard` role `section_card` (default) with props {"background": "surfaceNeutral2", "padding": "spacingXl", "radius": "radiusXl"}
  - `auth.form.heading` => `DSText` role `heading` (default) with props {"color_token": "textNeutral9", "style_token": "h2", "text": "Login"}
  - `auth.form.email` => `DSTextField` role `email_input` (variant=filled, state=filled) with props {"iconRight": "envelope", "label": "Your Email", "placeholder": "Enter your email"}
  - `auth.form.password` => `DSTextField` role `password_input` (variant=filled, state=filled) with props {"isSecure": true, "label": "Your Password", "placeholder": "Enter your password"}
  - `auth.form.remember` => `DSCheckbox` role `remember_me` (default) with props {"isOn": false, "label": "Remember me"}
  - `auth.form.cta` => `DSButton` role `primary_cta` (variant=filledA, size=big) with props {"iconRight": "arrow.right", "isFullWidth": true, "label": "Let's Roll!"}
- `auth.social` uses pattern `auth.social-sign-in` and renders as a vertical section frame.
  Title: Social sign in
  Component order: `auth.social.card`, `auth.social.google`, `auth.social.facebook`, `auth.social.x`
  - `auth.social.card` => `DSCard` role `section_card` (default) with props {"background": "surfacePrimary100", "padding": "spacingXl", "radius": "radiusXl"}
  - `auth.social.google` => `DSButton` role `social_action` (variant=neutral, size=big) with props {"assetIcon": "icon_google", "isFullWidth": true}
  - `auth.social.facebook` => `DSButton` role `social_action` (variant=neutral, size=big) with props {"assetIcon": "icon_facebook", "isFullWidth": true}
  - `auth.social.x` => `DSButton` role `social_action` (variant=neutral, size=big) with props {"assetIcon": "icon_x", "isFullWidth": true}

## Component Mapping Summary
- `auth.form.card` maps `DSCard` to Figma component `Card`.
- `auth.form.heading` maps `DSText` to Figma component `Text Primitive`.
- `auth.form.email` maps `DSTextField` to Figma component `Text Field`.
- `auth.form.password` maps `DSTextField` to Figma component `Text Field`.
- `auth.form.remember` maps `DSCheckbox` to Figma component `Checkbox`.
- `auth.form.cta` maps `DSButton` to Figma component `Button`.
- `auth.social.card` maps `DSCard` to Figma component `Card`.
- `auth.social.google` maps `DSButton` to Figma component `Button`.
- `auth.social.facebook` maps `DSButton` to Figma component `Button`.
- `auth.social.x` maps `DSButton` to Figma component `Button`.

## Playground-Specific Rules
- Never invent a new component when a registered DS component already covers the job.
- Never use raw spacing, radius, or colors outside the registered token names in the page spec.
- Always preserve the explicit theme combination of brand and style.
- Treat section order in the page spec as final unless the spec explicitly allows reordering.
- For icon-only actions, keep the accessibility label in the handoff.
- When a property is unknown in Figma, preserve the intent in a note instead of silently dropping it.

## Accessibility Notes
- Social icon-only actions include explicit accessibility labels.
- Password field is secure and should expose a readable show or hide password affordance.

## Implementation Notes
- Use auth.form-card and auth.social-sign-in patterns without introducing raw SwiftUI buttons.

## Machine-Readable Page Spec
```yaml
page_id: auth.login.generated
page_name: AI Generated Login
page_type: auth
description: Login screen using the auth form-card and social-sign-in patterns.
theme:
  brand: coralCamo
  style: lightRounded
sections:
- id: auth.form
  pattern_id: auth.form-card
  title: Sign in form
  component_refs:
  - auth.form.card
  - auth.form.heading
  - auth.form.email
  - auth.form.password
  - auth.form.remember
  - auth.form.cta
- id: auth.social
  pattern_id: auth.social-sign-in
  title: Social sign in
  component_refs:
  - auth.social.card
  - auth.social.google
  - auth.social.facebook
  - auth.social.x
components:
- id: auth.form.card
  component: DSCard
  role: section_card
  props:
    background: surfaceNeutral2
    radius: radiusXl
    padding: spacingXl
- id: auth.form.heading
  component: DSText
  role: heading
  props:
    text: Login
    style_token: h2
    color_token: textNeutral9
- id: auth.form.email
  component: DSTextField
  role: email_input
  variant: filled
  state: filled
  props:
    label: Your Email
    placeholder: Enter your email
    iconRight: envelope
- id: auth.form.password
  component: DSTextField
  role: password_input
  variant: filled
  state: filled
  props:
    label: Your Password
    placeholder: Enter your password
    isSecure: true
- id: auth.form.remember
  component: DSCheckbox
  role: remember_me
  props:
    label: Remember me
    isOn: false
- id: auth.form.cta
  component: DSButton
  role: primary_cta
  variant: filledA
  size: big
  props:
    label: Let's Roll!
    iconRight: arrow.right
    isFullWidth: true
- id: auth.social.card
  component: DSCard
  role: section_card
  props:
    background: surfacePrimary100
    radius: radiusXl
    padding: spacingXl
- id: auth.social.google
  component: DSButton
  role: social_action
  variant: neutral
  size: big
  props:
    assetIcon: icon_google
    isFullWidth: true
  accessibility:
    label: Continue with Google
- id: auth.social.facebook
  component: DSButton
  role: social_action
  variant: neutral
  size: big
  props:
    assetIcon: icon_facebook
    isFullWidth: true
  accessibility:
    label: Continue with Facebook
- id: auth.social.x
  component: DSButton
  role: social_action
  variant: neutral
  size: big
  props:
    assetIcon: icon_x
    isFullWidth: true
  accessibility:
    label: Continue with X
copy:
- id: auth.caption
  text: Welcome back!
  style_token: caption
  color_token: textNeutral9
accessibility:
  notes:
  - Social icon-only actions include explicit accessibility labels.
  - Password field is secure and should expose a readable show or hide password affordance.
implementation_notes:
- Use auth.form-card and auth.social-sign-in patterns without introducing raw SwiftUI
  buttons.
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
    "id": "auth.login.generated",
    "name": "AI Generated Login",
    "type": "auth",
    "description": "Login screen using the auth form-card and social-sign-in patterns.",
    "theme": {
      "brand": "coralCamo",
      "style": "lightRounded"
    }
  },
  "figma": {
    "rootPageNodeType": "PAGE",
    "screenNodeType": "FRAME",
    "screenFrame": {
      "name": "AI Generated Login",
      "layoutMode": "VERTICAL",
      "primaryAxisSizingMode": "AUTO",
      "counterAxisSizingMode": "FIXED"
    },
    "sections": [
      {
        "id": "auth.form",
        "patternId": "auth.form-card",
        "title": "Sign in form",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "auth.form.card",
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
            "id": "auth.form.heading",
            "nodeType": "INSTANCE",
            "component": "DSText",
            "figmaComponent": "Text Primitive",
            "role": "heading",
            "variantProperties": {},
            "componentProperties": {
              "Text": "Login",
              "style_token": "h2",
              "color_token": "textNeutral9"
            },
            "accessibility": {}
          },
          {
            "id": "auth.form.email",
            "nodeType": "INSTANCE",
            "component": "DSTextField",
            "figmaComponent": "Text Field",
            "role": "email_input",
            "variantProperties": {
              "Variant": "filled",
              "State": "filled"
            },
            "componentProperties": {
              "Label": "Your Email",
              "Placeholder": "Enter your email",
              "Right icon": "envelope"
            },
            "accessibility": {}
          },
          {
            "id": "auth.form.password",
            "nodeType": "INSTANCE",
            "component": "DSTextField",
            "figmaComponent": "Text Field",
            "role": "password_input",
            "variantProperties": {
              "Variant": "filled",
              "State": "filled"
            },
            "componentProperties": {
              "Label": "Your Password",
              "Placeholder": "Enter your password",
              "Secure": true
            },
            "accessibility": {}
          },
          {
            "id": "auth.form.remember",
            "nodeType": "INSTANCE",
            "component": "DSCheckbox",
            "figmaComponent": "Checkbox",
            "role": "remember_me",
            "variantProperties": {},
            "componentProperties": {
              "Label": "Remember me",
              "Checked": false
            },
            "accessibility": {}
          },
          {
            "id": "auth.form.cta",
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
              "Label": "Let's Roll!",
              "Right icon": "arrow.right",
              "Full width": true
            },
            "accessibility": {}
          }
        ]
      },
      {
        "id": "auth.social",
        "patternId": "auth.social-sign-in",
        "title": "Social sign in",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "auth.social.card",
            "nodeType": "INSTANCE",
            "component": "DSCard",
            "figmaComponent": "Card",
            "role": "section_card",
            "variantProperties": {},
            "componentProperties": {
              "Background": "surfacePrimary100",
              "Radius": "radiusXl",
              "Padding": "spacingXl"
            },
            "accessibility": {}
          },
          {
            "id": "auth.social.google",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "social_action",
            "variantProperties": {
              "Variant": "neutral",
              "Size": "big",
              "Content": "icon-only"
            },
            "componentProperties": {
              "Asset icon": "icon_google",
              "Full width": true
            },
            "accessibility": {
              "label": "Continue with Google"
            }
          },
          {
            "id": "auth.social.facebook",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "social_action",
            "variantProperties": {
              "Variant": "neutral",
              "Size": "big",
              "Content": "icon-only"
            },
            "componentProperties": {
              "Asset icon": "icon_facebook",
              "Full width": true
            },
            "accessibility": {
              "label": "Continue with Facebook"
            }
          },
          {
            "id": "auth.social.x",
            "nodeType": "INSTANCE",
            "component": "DSButton",
            "figmaComponent": "Button",
            "role": "social_action",
            "variantProperties": {
              "Variant": "neutral",
              "Size": "big",
              "Content": "icon-only"
            },
            "componentProperties": {
              "Asset icon": "icon_x",
              "Full width": true
            },
            "accessibility": {
              "label": "Continue with X"
            }
          }
        ]
      }
    ],
    "instances": [
      {
        "id": "auth.form.card",
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
        "id": "auth.form.heading",
        "nodeType": "INSTANCE",
        "component": "DSText",
        "figmaComponent": "Text Primitive",
        "role": "heading",
        "variantProperties": {},
        "componentProperties": {
          "Text": "Login",
          "style_token": "h2",
          "color_token": "textNeutral9"
        },
        "accessibility": {}
      },
      {
        "id": "auth.form.email",
        "nodeType": "INSTANCE",
        "component": "DSTextField",
        "figmaComponent": "Text Field",
        "role": "email_input",
        "variantProperties": {
          "Variant": "filled",
          "State": "filled"
        },
        "componentProperties": {
          "Label": "Your Email",
          "Placeholder": "Enter your email",
          "Right icon": "envelope"
        },
        "accessibility": {}
      },
      {
        "id": "auth.form.password",
        "nodeType": "INSTANCE",
        "component": "DSTextField",
        "figmaComponent": "Text Field",
        "role": "password_input",
        "variantProperties": {
          "Variant": "filled",
          "State": "filled"
        },
        "componentProperties": {
          "Label": "Your Password",
          "Placeholder": "Enter your password",
          "Secure": true
        },
        "accessibility": {}
      },
      {
        "id": "auth.form.remember",
        "nodeType": "INSTANCE",
        "component": "DSCheckbox",
        "figmaComponent": "Checkbox",
        "role": "remember_me",
        "variantProperties": {},
        "componentProperties": {
          "Label": "Remember me",
          "Checked": false
        },
        "accessibility": {}
      },
      {
        "id": "auth.form.cta",
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
          "Label": "Let's Roll!",
          "Right icon": "arrow.right",
          "Full width": true
        },
        "accessibility": {}
      },
      {
        "id": "auth.social.card",
        "nodeType": "INSTANCE",
        "component": "DSCard",
        "figmaComponent": "Card",
        "role": "section_card",
        "variantProperties": {},
        "componentProperties": {
          "Background": "surfacePrimary100",
          "Radius": "radiusXl",
          "Padding": "spacingXl"
        },
        "accessibility": {}
      },
      {
        "id": "auth.social.google",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "social_action",
        "variantProperties": {
          "Variant": "neutral",
          "Size": "big",
          "Content": "icon-only"
        },
        "componentProperties": {
          "Asset icon": "icon_google",
          "Full width": true
        },
        "accessibility": {
          "label": "Continue with Google"
        }
      },
      {
        "id": "auth.social.facebook",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "social_action",
        "variantProperties": {
          "Variant": "neutral",
          "Size": "big",
          "Content": "icon-only"
        },
        "componentProperties": {
          "Asset icon": "icon_facebook",
          "Full width": true
        },
        "accessibility": {
          "label": "Continue with Facebook"
        }
      },
      {
        "id": "auth.social.x",
        "nodeType": "INSTANCE",
        "component": "DSButton",
        "figmaComponent": "Button",
        "role": "social_action",
        "variantProperties": {
          "Variant": "neutral",
          "Size": "big",
          "Content": "icon-only"
        },
        "componentProperties": {
          "Asset icon": "icon_x",
          "Full width": true
        },
        "accessibility": {
          "label": "Continue with X"
        }
      }
    ]
  },
  "copy": [
    {
      "id": "auth.caption",
      "text": "Welcome back!",
      "style_token": "caption",
      "color_token": "textNeutral9"
    }
  ],
  "assets": [],
  "accessibility": {
    "notes": [
      "Social icon-only actions include explicit accessibility labels.",
      "Password field is secure and should expose a readable show or hide password affordance."
    ]
  },
  "implementation_notes": [
    "Use auth.form-card and auth.social-sign-in patterns without introducing raw SwiftUI buttons."
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
