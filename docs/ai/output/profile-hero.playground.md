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
- Page type: `profile`
- Page name: `AI Generated Profile Hero`
- Description: Profile screen combining the profile.hero and profile.stats patterns.

## Section Blueprint
- `profile.hero` uses pattern `profile.hero` and renders as a vertical section frame.
  Title: Profile header
  Component order: `profile.header`, `profile.carousel`, `profile.summary`
  - `profile.header` => `DSTopAppBar` role `screen_header` (variant=small) with props {"title": "Profile"}
  - `profile.carousel` => `DSCarousel` role `hero_carousel` (variant=standard) with props {"images": ["profile-photo-1", "profile-photo-2"]}
  - `profile.summary` => `DSCard` role `section_card` (default) with props {"background": "surfacePrimary100", "padding": "spacingXl", "radius": "radiusXl"}
- `profile.stats` uses pattern `profile.stats` and renders as a vertical section frame.
  Title: Profile metrics
  Component order: `profile.stats.row`, `profile.stats.progress`
  - `profile.stats.row` => `DSStatRow` role `summary_strip` (default) with props {"items": [{"id": "photos", "label": "photos"}, {"id": "followers", "label": "followers"}, {"id": "following", "label": "following"}]}
  - `profile.stats.progress` => `DSProgressCircle` role `radial_metric` (default) with props {"progress": 0.76, "size": 88}

## Component Mapping Summary
- `profile.header` maps `DSTopAppBar` to Figma component `Top App Bar`.
- `profile.carousel` maps `DSCarousel` to Figma component `Carousel`.
- `profile.summary` maps `DSCard` to Figma component `Card`.
- `profile.stats.row` maps `DSStatRow` to Figma component `Stat Row`.
- `profile.stats.progress` maps `DSProgressCircle` to Figma component `Progress Circle`.

## Playground-Specific Rules
- Never invent a new component when a registered DS component already covers the job.
- Never use raw spacing, radius, or colors outside the registered token names in the page spec.
- Always preserve the explicit theme combination of brand and style.
- Treat section order in the page spec as final unless the spec explicitly allows reordering.
- For icon-only actions, keep the accessibility label in the handoff.
- When a property is unknown in Figma, preserve the intent in a note instead of silently dropping it.

## Accessibility Notes
- Hero media should remain decorative unless it communicates essential content.
- Stats should read as coherent grouped values.

## Implementation Notes
- Use the profile.hero and profile.stats patterns before inventing new profile composition grammar.

## Machine-Readable Page Spec
```yaml
page_id: profile.hero.generated
page_name: AI Generated Profile Hero
page_type: profile
description: Profile screen combining the profile.hero and profile.stats patterns.
theme:
  brand: mistyRose
  style: darkRounded
sections:
- id: profile.hero
  pattern_id: profile.hero
  title: Profile header
  component_refs:
  - profile.header
  - profile.carousel
  - profile.summary
- id: profile.stats
  pattern_id: profile.stats
  title: Profile metrics
  component_refs:
  - profile.stats.row
  - profile.stats.progress
components:
- id: profile.header
  component: DSTopAppBar
  role: screen_header
  variant: small
  props:
    title: Profile
- id: profile.carousel
  component: DSCarousel
  role: hero_carousel
  variant: standard
  props:
    images:
    - profile-photo-1
    - profile-photo-2
- id: profile.summary
  component: DSCard
  role: section_card
  props:
    background: surfacePrimary100
    radius: radiusXl
    padding: spacingXl
- id: profile.stats.row
  component: DSStatRow
  role: summary_strip
  props:
    items:
    - id: photos
      label: photos
    - id: followers
      label: followers
    - id: following
      label: following
- id: profile.stats.progress
  component: DSProgressCircle
  role: radial_metric
  props:
    progress: 0.76
    size: 88
accessibility:
  notes:
  - Hero media should remain decorative unless it communicates essential content.
  - Stats should read as coherent grouped values.
implementation_notes:
- Use the profile.hero and profile.stats patterns before inventing new profile composition
  grammar.
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
    "id": "profile.hero.generated",
    "name": "AI Generated Profile Hero",
    "type": "profile",
    "description": "Profile screen combining the profile.hero and profile.stats patterns.",
    "theme": {
      "brand": "mistyRose",
      "style": "darkRounded"
    }
  },
  "figma": {
    "rootPageNodeType": "PAGE",
    "screenNodeType": "FRAME",
    "screenFrame": {
      "name": "AI Generated Profile Hero",
      "layoutMode": "VERTICAL",
      "primaryAxisSizingMode": "AUTO",
      "counterAxisSizingMode": "FIXED"
    },
    "sections": [
      {
        "id": "profile.hero",
        "patternId": "profile.hero",
        "title": "Profile header",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "profile.header",
            "nodeType": "INSTANCE",
            "component": "DSTopAppBar",
            "figmaComponent": "Top App Bar",
            "role": "screen_header",
            "variantProperties": {
              "Variant": "small"
            },
            "componentProperties": {
              "Title": "Profile"
            },
            "accessibility": {}
          },
          {
            "id": "profile.carousel",
            "nodeType": "INSTANCE",
            "component": "DSCarousel",
            "figmaComponent": "Carousel",
            "role": "hero_carousel",
            "variantProperties": {
              "Variant": "standard"
            },
            "componentProperties": {
              "Images": [
                "profile-photo-1",
                "profile-photo-2"
              ]
            },
            "accessibility": {}
          },
          {
            "id": "profile.summary",
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
          }
        ]
      },
      {
        "id": "profile.stats",
        "patternId": "profile.stats",
        "title": "Profile metrics",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "profile.stats.row",
            "nodeType": "INSTANCE",
            "component": "DSStatRow",
            "figmaComponent": "Stat Row",
            "role": "summary_strip",
            "variantProperties": {},
            "componentProperties": {
              "Items": [
                {
                  "id": "photos",
                  "label": "photos"
                },
                {
                  "id": "followers",
                  "label": "followers"
                },
                {
                  "id": "following",
                  "label": "following"
                }
              ]
            },
            "accessibility": {}
          },
          {
            "id": "profile.stats.progress",
            "nodeType": "INSTANCE",
            "component": "DSProgressCircle",
            "figmaComponent": "Progress Circle",
            "role": "radial_metric",
            "variantProperties": {},
            "componentProperties": {
              "Progress": 0.76,
              "Size": 88
            },
            "accessibility": {}
          }
        ]
      }
    ],
    "instances": [
      {
        "id": "profile.header",
        "nodeType": "INSTANCE",
        "component": "DSTopAppBar",
        "figmaComponent": "Top App Bar",
        "role": "screen_header",
        "variantProperties": {
          "Variant": "small"
        },
        "componentProperties": {
          "Title": "Profile"
        },
        "accessibility": {}
      },
      {
        "id": "profile.carousel",
        "nodeType": "INSTANCE",
        "component": "DSCarousel",
        "figmaComponent": "Carousel",
        "role": "hero_carousel",
        "variantProperties": {
          "Variant": "standard"
        },
        "componentProperties": {
          "Images": [
            "profile-photo-1",
            "profile-photo-2"
          ]
        },
        "accessibility": {}
      },
      {
        "id": "profile.summary",
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
        "id": "profile.stats.row",
        "nodeType": "INSTANCE",
        "component": "DSStatRow",
        "figmaComponent": "Stat Row",
        "role": "summary_strip",
        "variantProperties": {},
        "componentProperties": {
          "Items": [
            {
              "id": "photos",
              "label": "photos"
            },
            {
              "id": "followers",
              "label": "followers"
            },
            {
              "id": "following",
              "label": "following"
            }
          ]
        },
        "accessibility": {}
      },
      {
        "id": "profile.stats.progress",
        "nodeType": "INSTANCE",
        "component": "DSProgressCircle",
        "figmaComponent": "Progress Circle",
        "role": "radial_metric",
        "variantProperties": {},
        "componentProperties": {
          "Progress": 0.76,
          "Size": 88
        },
        "accessibility": {}
      }
    ]
  },
  "copy": [],
  "assets": [],
  "accessibility": {
    "notes": [
      "Hero media should remain decorative unless it communicates essential content.",
      "Stats should read as coherent grouped values."
    ]
  },
  "implementation_notes": [
    "Use the profile.hero and profile.stats patterns before inventing new profile composition grammar."
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
