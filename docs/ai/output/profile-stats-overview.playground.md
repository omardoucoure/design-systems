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
- Brand: `blueHaze`
- Style: `lightSharp`
- Page type: `profile`
- Page name: `AI Generated Profile Stats`
- Description: Profile analytics screen using the profile.stats pattern with summary cards and historical list items.

## Section Blueprint
- `profile.header` uses pattern `profile.stats` and renders as a vertical section frame.
  Title: Profile summary
  Component order: `profile.header.card`, `profile.header.appbar`, `profile.header.name`, `profile.header.bio`, `profile.header.stats`, `profile.header.follow`
  - `profile.header.card` => `DSCard` role `section_card` (default) with props {"background": "surfaceNeutral2", "padding": "spacingXl", "radius": "radiusXl"}
  - `profile.header.appbar` => `DSTopAppBar` role `page_header` (default) with props {"title": "Profile"}
  - `profile.header.name` => `DSText` role `heading` (default) with props {"color_token": "textNeutral9", "style_token": "h4", "text": "Hristo Hristov"}
  - `profile.header.bio` => `DSText` role `supporting_copy` (default) with props {"color_token": "textNeutral9", "style_token": "caption", "text": "Sports superhero. Training for the office chair Olympics and holds the world record in sock throwing."}
  - `profile.header.stats` => `DSStatRow` role `stats_summary` (default) with props {"items": "photos:1200|followers:2980|following:1600"}
  - `profile.header.follow` => `DSButton` role `primary_cta` (variant=filledA, size=medium) with props {"iconRight": "plus", "label": "Follow"}
- `profile.analytics` uses pattern `profile.stats` and renders as a vertical section frame.
  Title: Performance summary
  Component order: `profile.analytics.card`, `profile.analytics.progress`, `profile.analytics.metric`
  - `profile.analytics.card` => `DSCard` role `section_card` (default) with props {"background": "surfacePrimary100", "padding": "spacingXl", "radius": "radiusXl"}
  - `profile.analytics.progress` => `DSProgressCircle` role `radial_metric` (default) with props {"customLabel": "560", "progress": 0.65, "size": 88}
  - `profile.analytics.metric` => `DSMetricCard` role `metric_summary` (default) with props {"background": "surfacePrimary120", "title": "560 works done", "unit": "done", "value": "560"}
- `profile.history` uses pattern `profile.stats` and renders as a vertical section frame.
  Title: Historical entries
  Component order: `profile.history.card`, `profile.history.item1`, `profile.history.divider1`, `profile.history.item2`
  - `profile.history.card` => `DSCard` role `section_card` (default) with props {"background": "surfaceNeutral2", "padding": "spacingXl", "radius": "radiusXl"}
  - `profile.history.item1` => `DSListItem` role `history_entry` (default) with props {"headline": "12,380 reviews", "metadata": "12K", "overline": "April, 2030"}
  - `profile.history.divider1` => `DSDivider` role `separator` (default) with props {"label": ""}
  - `profile.history.item2` => `DSListItem` role `history_entry` (default) with props {"headline": "560 works done", "metadata": "560", "overline": "March, 2030"}

## Component Mapping Summary
- `profile.header.card` maps `DSCard` to Figma component `Card`.
- `profile.header.appbar` maps `DSTopAppBar` to Figma component `Top App Bar`.
- `profile.header.name` maps `DSText` to Figma component `Text Primitive`.
- `profile.header.bio` maps `DSText` to Figma component `Text Primitive`.
- `profile.header.stats` maps `DSStatRow` to Figma component `Stat Row`.
- `profile.header.follow` maps `DSButton` to Figma component `Button`.
- `profile.analytics.card` maps `DSCard` to Figma component `Card`.
- `profile.analytics.progress` maps `DSProgressCircle` to Figma component `Progress Circle`.
- `profile.analytics.metric` maps `DSMetricCard` to Figma component `Metric Card`.
- `profile.history.card` maps `DSCard` to Figma component `Card`.
- `profile.history.item1` maps `DSListItem` to Figma component `List Item`.
- `profile.history.divider1` maps `DSDivider` to Figma component `Divider`.
- `profile.history.item2` maps `DSListItem` to Figma component `List Item`.

## Playground-Specific Rules
- Never invent a new component when a registered DS component already covers the job.
- Never use raw spacing, radius, or colors outside the registered token names in the page spec.
- Always preserve the explicit theme combination of brand and style.
- Treat section order in the page spec as final unless the spec explicitly allows reordering.
- For icon-only actions, keep the accessibility label in the handoff.
- When a property is unknown in Figma, preserve the intent in a note instead of silently dropping it.

## Accessibility Notes
- The stats summary should read as grouped profile metrics before the follow action.
- Historical entries should remain distinguishable as separate rows.

## Implementation Notes
- Keep the profile header, analytics summary, and history list as three separate card-backed sections.
- Preserve the sharp shape treatment implied by the selected style.

## Machine-Readable Page Spec
```yaml
page_id: profile.stats.overview.generated
page_name: AI Generated Profile Stats
page_type: profile
description: Profile analytics screen using the profile.stats pattern with summary
  cards and historical list items.
theme:
  brand: blueHaze
  style: lightSharp
sections:
- id: profile.header
  pattern_id: profile.stats
  title: Profile summary
  component_refs:
  - profile.header.card
  - profile.header.appbar
  - profile.header.name
  - profile.header.bio
  - profile.header.stats
  - profile.header.follow
- id: profile.analytics
  pattern_id: profile.stats
  title: Performance summary
  component_refs:
  - profile.analytics.card
  - profile.analytics.progress
  - profile.analytics.metric
- id: profile.history
  pattern_id: profile.stats
  title: Historical entries
  component_refs:
  - profile.history.card
  - profile.history.item1
  - profile.history.divider1
  - profile.history.item2
components:
- id: profile.header.card
  component: DSCard
  role: section_card
  props:
    background: surfaceNeutral2
    radius: radiusXl
    padding: spacingXl
- id: profile.header.appbar
  component: DSTopAppBar
  role: page_header
  props:
    title: Profile
- id: profile.header.name
  component: DSText
  role: heading
  props:
    text: Hristo Hristov
    style_token: h4
    color_token: textNeutral9
- id: profile.header.bio
  component: DSText
  role: supporting_copy
  props:
    text: Sports superhero. Training for the office chair Olympics and holds the world
      record in sock throwing.
    style_token: caption
    color_token: textNeutral9
- id: profile.header.stats
  component: DSStatRow
  role: stats_summary
  props:
    items: photos:1200|followers:2980|following:1600
- id: profile.header.follow
  component: DSButton
  role: primary_cta
  variant: filledA
  size: medium
  props:
    label: Follow
    iconRight: plus
- id: profile.analytics.card
  component: DSCard
  role: section_card
  props:
    background: surfacePrimary100
    radius: radiusXl
    padding: spacingXl
- id: profile.analytics.progress
  component: DSProgressCircle
  role: radial_metric
  props:
    progress: 0.65
    size: 88
    customLabel: '560'
- id: profile.analytics.metric
  component: DSMetricCard
  role: metric_summary
  props:
    title: 560 works done
    value: '560'
    unit: done
    background: surfacePrimary120
- id: profile.history.card
  component: DSCard
  role: section_card
  props:
    background: surfaceNeutral2
    radius: radiusXl
    padding: spacingXl
- id: profile.history.item1
  component: DSListItem
  role: history_entry
  props:
    overline: April, 2030
    headline: 12,380 reviews
    metadata: 12K
- id: profile.history.divider1
  component: DSDivider
  role: separator
  props:
    label: ''
- id: profile.history.item2
  component: DSListItem
  role: history_entry
  props:
    overline: March, 2030
    headline: 560 works done
    metadata: '560'
copy:
- id: profile.analytics.caption
  text: 268 works in progress
  style_token: smallRegular
  color_token: textNeutral0_5
accessibility:
  notes:
  - The stats summary should read as grouped profile metrics before the follow action.
  - Historical entries should remain distinguishable as separate rows.
implementation_notes:
- Keep the profile header, analytics summary, and history list as three separate card-backed
  sections.
- Preserve the sharp shape treatment implied by the selected style.
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
    "id": "profile.stats.overview.generated",
    "name": "AI Generated Profile Stats",
    "type": "profile",
    "description": "Profile analytics screen using the profile.stats pattern with summary cards and historical list items.",
    "theme": {
      "brand": "blueHaze",
      "style": "lightSharp"
    }
  },
  "figma": {
    "rootPageNodeType": "PAGE",
    "screenNodeType": "FRAME",
    "screenFrame": {
      "name": "AI Generated Profile Stats",
      "layoutMode": "VERTICAL",
      "primaryAxisSizingMode": "AUTO",
      "counterAxisSizingMode": "FIXED"
    },
    "sections": [
      {
        "id": "profile.header",
        "patternId": "profile.stats",
        "title": "Profile summary",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "profile.header.card",
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
            "id": "profile.header.appbar",
            "nodeType": "INSTANCE",
            "component": "DSTopAppBar",
            "figmaComponent": "Top App Bar",
            "role": "page_header",
            "variantProperties": {},
            "componentProperties": {
              "Title": "Profile"
            },
            "accessibility": {}
          },
          {
            "id": "profile.header.name",
            "nodeType": "INSTANCE",
            "component": "DSText",
            "figmaComponent": "Text Primitive",
            "role": "heading",
            "variantProperties": {},
            "componentProperties": {
              "Text": "Hristo Hristov",
              "style_token": "h4",
              "color_token": "textNeutral9"
            },
            "accessibility": {}
          },
          {
            "id": "profile.header.bio",
            "nodeType": "INSTANCE",
            "component": "DSText",
            "figmaComponent": "Text Primitive",
            "role": "supporting_copy",
            "variantProperties": {},
            "componentProperties": {
              "Text": "Sports superhero. Training for the office chair Olympics and holds the world record in sock throwing.",
              "style_token": "caption",
              "color_token": "textNeutral9"
            },
            "accessibility": {}
          },
          {
            "id": "profile.header.stats",
            "nodeType": "INSTANCE",
            "component": "DSStatRow",
            "figmaComponent": "Stat Row",
            "role": "stats_summary",
            "variantProperties": {},
            "componentProperties": {
              "Items": "photos:1200|followers:2980|following:1600"
            },
            "accessibility": {}
          },
          {
            "id": "profile.header.follow",
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
              "Label": "Follow",
              "Right icon": "plus"
            },
            "accessibility": {}
          }
        ]
      },
      {
        "id": "profile.analytics",
        "patternId": "profile.stats",
        "title": "Performance summary",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "profile.analytics.card",
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
            "id": "profile.analytics.progress",
            "nodeType": "INSTANCE",
            "component": "DSProgressCircle",
            "figmaComponent": "Progress Circle",
            "role": "radial_metric",
            "variantProperties": {},
            "componentProperties": {
              "Progress": 0.65,
              "Size": 88,
              "Label": "560"
            },
            "accessibility": {}
          },
          {
            "id": "profile.analytics.metric",
            "nodeType": "INSTANCE",
            "component": "DSMetricCard",
            "figmaComponent": "Metric Card",
            "role": "metric_summary",
            "variantProperties": {},
            "componentProperties": {
              "Title": "560 works done",
              "Value": "560",
              "Unit": "done",
              "Background": "surfacePrimary120"
            },
            "accessibility": {}
          }
        ]
      },
      {
        "id": "profile.history",
        "patternId": "profile.stats",
        "title": "Historical entries",
        "nodeType": "FRAME",
        "layoutMode": "VERTICAL",
        "children": [
          {
            "id": "profile.history.card",
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
            "id": "profile.history.item1",
            "nodeType": "INSTANCE",
            "component": "DSListItem",
            "figmaComponent": "List Item",
            "role": "history_entry",
            "variantProperties": {},
            "componentProperties": {
              "Overline": "April, 2030",
              "Headline": "12,380 reviews",
              "Metadata": "12K"
            },
            "accessibility": {}
          },
          {
            "id": "profile.history.divider1",
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
            "id": "profile.history.item2",
            "nodeType": "INSTANCE",
            "component": "DSListItem",
            "figmaComponent": "List Item",
            "role": "history_entry",
            "variantProperties": {},
            "componentProperties": {
              "Overline": "March, 2030",
              "Headline": "560 works done",
              "Metadata": "560"
            },
            "accessibility": {}
          }
        ]
      }
    ],
    "instances": [
      {
        "id": "profile.header.card",
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
        "id": "profile.header.appbar",
        "nodeType": "INSTANCE",
        "component": "DSTopAppBar",
        "figmaComponent": "Top App Bar",
        "role": "page_header",
        "variantProperties": {},
        "componentProperties": {
          "Title": "Profile"
        },
        "accessibility": {}
      },
      {
        "id": "profile.header.name",
        "nodeType": "INSTANCE",
        "component": "DSText",
        "figmaComponent": "Text Primitive",
        "role": "heading",
        "variantProperties": {},
        "componentProperties": {
          "Text": "Hristo Hristov",
          "style_token": "h4",
          "color_token": "textNeutral9"
        },
        "accessibility": {}
      },
      {
        "id": "profile.header.bio",
        "nodeType": "INSTANCE",
        "component": "DSText",
        "figmaComponent": "Text Primitive",
        "role": "supporting_copy",
        "variantProperties": {},
        "componentProperties": {
          "Text": "Sports superhero. Training for the office chair Olympics and holds the world record in sock throwing.",
          "style_token": "caption",
          "color_token": "textNeutral9"
        },
        "accessibility": {}
      },
      {
        "id": "profile.header.stats",
        "nodeType": "INSTANCE",
        "component": "DSStatRow",
        "figmaComponent": "Stat Row",
        "role": "stats_summary",
        "variantProperties": {},
        "componentProperties": {
          "Items": "photos:1200|followers:2980|following:1600"
        },
        "accessibility": {}
      },
      {
        "id": "profile.header.follow",
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
          "Label": "Follow",
          "Right icon": "plus"
        },
        "accessibility": {}
      },
      {
        "id": "profile.analytics.card",
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
        "id": "profile.analytics.progress",
        "nodeType": "INSTANCE",
        "component": "DSProgressCircle",
        "figmaComponent": "Progress Circle",
        "role": "radial_metric",
        "variantProperties": {},
        "componentProperties": {
          "Progress": 0.65,
          "Size": 88,
          "Label": "560"
        },
        "accessibility": {}
      },
      {
        "id": "profile.analytics.metric",
        "nodeType": "INSTANCE",
        "component": "DSMetricCard",
        "figmaComponent": "Metric Card",
        "role": "metric_summary",
        "variantProperties": {},
        "componentProperties": {
          "Title": "560 works done",
          "Value": "560",
          "Unit": "done",
          "Background": "surfacePrimary120"
        },
        "accessibility": {}
      },
      {
        "id": "profile.history.card",
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
        "id": "profile.history.item1",
        "nodeType": "INSTANCE",
        "component": "DSListItem",
        "figmaComponent": "List Item",
        "role": "history_entry",
        "variantProperties": {},
        "componentProperties": {
          "Overline": "April, 2030",
          "Headline": "12,380 reviews",
          "Metadata": "12K"
        },
        "accessibility": {}
      },
      {
        "id": "profile.history.divider1",
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
        "id": "profile.history.item2",
        "nodeType": "INSTANCE",
        "component": "DSListItem",
        "figmaComponent": "List Item",
        "role": "history_entry",
        "variantProperties": {},
        "componentProperties": {
          "Overline": "March, 2030",
          "Headline": "560 works done",
          "Metadata": "560"
        },
        "accessibility": {}
      }
    ]
  },
  "copy": [
    {
      "id": "profile.analytics.caption",
      "text": "268 works in progress",
      "style_token": "smallRegular",
      "color_token": "textNeutral0_5"
    }
  ],
  "assets": [],
  "accessibility": {
    "notes": [
      "The stats summary should read as grouped profile metrics before the follow action.",
      "Historical entries should remain distinguishable as separate rows."
    ]
  },
  "implementation_notes": [
    "Keep the profile header, analytics summary, and history list as three separate card-backed sections.",
    "Preserve the sharp shape treatment implied by the selected style."
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
