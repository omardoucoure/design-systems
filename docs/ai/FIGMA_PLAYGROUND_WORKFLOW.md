# Figma Playground Workflow

This is the primary workflow when the final renderer is another AI operating inside Figma Playground rather than a direct Figma writer.

## Files

- [`design-system-contract.yaml`](design-system-contract.yaml)
- [`figma-playground-rules.yaml`](figma-playground-rules.yaml)
- [`playground-handoff-template.md`](playground-handoff-template.md)
- [`page-spec.schema.json`](page-spec.schema.json)
- [`examples`](examples)
- [`../../scripts/validate_page_spec.py`](../../scripts/validate_page_spec.py)
- [`../../scripts/build_figma_playground_handoff.py`](../../scripts/build_figma_playground_handoff.py)

## Flow

1. Generate a page spec from the design-system contract.
2. Validate the page spec locally.
3. Build a Playground handoff markdown file from the validated spec.
4. Paste the handoff into Figma Playground.
5. Let the Playground AI create the screen from the DS contract, rules, and component list.

## Commands

```bash
python3 scripts/validate_page_spec.py docs/ai/examples/auth-login.yaml

python3 scripts/build_figma_playground_handoff.py \
  docs/ai/examples/auth-login.yaml \
  docs/ai/output/auth-login.playground.md
```

## What The Handoff Contains

- a short system prompt for the Playground AI
- explicit theme and page goal
- ordered section blueprint
- component-level rendering instructions
- Figma-facing mapping hints
- accessibility notes
- implementation notes
- machine-readable payloads for the original spec and transformed Figma JSON

## Why This Path Is Better For Playground

- It reduces reliance on the Playground model inferring architecture from raw code.
- It keeps the source of truth in validated YAML and JSON artifacts.
- It preserves both human-readable intent and machine-readable structure in one packet.

## Constraints

- Playground may not resolve every live library component exactly by name.
- Playground may reinterpret layout unless the handoff is explicit.
- Component slot behavior still depends on how the real Figma library is published.

## Recommended Next Improvements

- Add more example handoffs for dashboard, onboarding, and profile families.
- Add exact Figma library component names and property names once the design library is stable.
- Add a compact “allowed patterns only” mode for highly constrained generation.
