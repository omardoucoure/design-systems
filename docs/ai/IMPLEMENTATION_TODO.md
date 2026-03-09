# AI Page Generation Implementation TODO

This plan assumes the designer will not continue extending the system and that AI must become capable of composing new screens in Figma from the existing design language.

## Goal

Enable AI to generate new Figma pages that:

- stay inside the HaHo system
- use only approved tokens, components, and page patterns
- preserve accessibility and theme behavior
- can be implemented in SwiftUI without major redesign

## Phase 0: Normalize The Source Of Truth

- Decide which layer is canonical for tokens: Figma variables or `tokens/*.json`.
- Generate Swift token artifacts from the canonical token source instead of hand-maintaining mirrored values.
- Align Figma names with Swift names for components, variants, states, and properties.
- Add stable IDs for every public component and major page pattern.

Deliverables:

- generated token pipeline
- naming map between Figma and code
- source-of-truth policy

## Phase 1: Formalize The AI Contract

- Maintain [`design-system-contract.yaml`](design-system-contract.yaml) as the public AI registry.
- Add component metadata for all public DS components:
  - role
  - category
  - supported variants
  - states
  - slots
  - composition rules
  - accessibility rules
- Add page-pattern metadata for common layouts in auth, alerts, profile, onboarding, and dashboard screens.
- Mark forbidden implementation patterns such as raw custom buttons when `DSButton` already covers the need.

Deliverables:

- complete component registry
- page-pattern registry
- forbidden-pattern rules

## Phase 2: Make Components More AI-Safe

- Continue moving hardcoded metrics into component tokens.
- Add accessibility hooks to icon-only DS APIs so callers do not have to remember labels manually.
- Introduce component tokens for more controls:
  - cards
  - banners
  - app bars
  - charts
  - carousel
- Define which components are layout primitives versus content primitives.

Deliverables:

- broader component-token layer
- explicit accessibility API support
- tighter component semantics

## Phase 3: Create A Page Spec Format

- Define a page-level schema that AI can emit before creating Figma output.
- Suggested top-level fields:
  - `page_type`
  - `theme`
  - `sections`
  - `components`
  - `copy`
  - `images`
  - `accessibility`
  - `notes`
- Every section should point to an approved pattern or component.
- Add validation rules so bad specs fail early.

Deliverables:

- page schema JSON Schema or YAML schema
- validator script
- sample page specs for each major family

## Phase 4: Connect To Figma

- Choose the Figma output path:
  - Figma API plugin path
  - Dev Mode / MCP path
  - intermediate JSON that a Figma-side script consumes
- Create a deterministic mapping from page spec -> Figma nodes.
- Preserve variant mapping, spacing, radius, and semantic colors through the transformer.
- Make sure generated Figma pages keep component instance links where possible.

Deliverables:

- transformer from page spec to Figma payload
- Figma mapping table for components and properties
- generated example pages

## Phase 5: Add Evaluation And Feedback Loops

- Create a rubric for AI-generated pages:
  - token compliance
  - component compliance
  - accessibility compliance
  - theme compatibility
  - implementation feasibility
- Evaluate generated pages against existing showcase categories.
- Add “approved pattern” and “rejected pattern” examples to improve prompting.
- Track failure modes:
  - raw controls
  - inconsistent spacing
  - inaccessible icon-only actions
  - unregistered layouts

Deliverables:

- evaluation checklist
- regression examples
- prompt iteration log

## Phase 6: Turn It Into An AI Skill

- Package the contract and workflow into a reusable AI skill or internal tool.
- Input:
  - page brief
  - target category
  - target brand/style
  - optional reference screen
- Output:
  - validated page spec
  - Figma-ready structure
  - implementation notes
- Require the AI to cite which registered patterns and components it used.

Deliverables:

- skill prompt
- contract-loading instructions
- generation workflow
- fallback rules when the brief exceeds system capability

## Concrete Backlog

### P0

- Keep `design-system-contract.yaml` updated with every public component change.
- Add Figma component/variant/property names for each DS component.
- Create a page spec schema.
- Add validator tooling.

### P1

- Add page-pattern docs for auth, alerts, profile, walkthrough, and dashboards.
- Add accessibility labels to icon-only DS primitives.
- Add richer component docs for navigation, feedback, and data-viz primitives.

### P2

- Generate the AI contract from source where possible.
- Add automatic screenshots or previews for each component variant.
- Add automatic token and component regression checks.

## What Not To Do

- Do not ask the model to invent new visual grammar outside the registered system.
- Do not let the model infer component variants from screenshots alone.
- Do not let AI write raw SwiftUI or raw Figma node structures first and “clean it up later”.
- Do not treat accessibility as a separate pass.

## Success Criteria

You are done when the AI can:

- read one contract file and understand the system
- generate a valid page spec without browsing source code
- produce Figma-ready structure from approved components and patterns
- explain why each component and variant was chosen
- stay inside the system across all 16 theme combinations
