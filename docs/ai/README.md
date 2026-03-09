# AI Design Contract

This directory is the AI-facing layer of the design system.

Its purpose is to make the system understandable to an LLM without requiring the model to infer behavior directly from Swift source every time.

## What lives here

- [`design-system-contract.yaml`](design-system-contract.yaml): machine-readable component, token, and page-pattern registry
- [`page-spec.schema.json`](page-spec.schema.json): strict page-spec schema for AI-generated screens
- [`figma-mapping.yaml`](figma-mapping.yaml): DS component to Figma component/property mapping
- [`IMPLEMENTATION_TODO.md`](IMPLEMENTATION_TODO.md): phased roadmap to make AI-driven page generation reliable
- [`examples`](examples): example page specs for major page families

## Why this exists

The current repo is strong as an implementation system, but weaker as an AI contract:

- tokens exist, but component semantics are still mostly implicit in code
- examples exist, but reusable page patterns are not formalized
- AI can guess from code, but it cannot yet compose from a first-class registry

This folder closes that gap.

## How an AI should use this

1. Read the token and theme model first.
2. Select page pattern blocks before choosing raw components.
3. Compose screens only from registered DS primitives and registered page patterns.
4. Treat raw SwiftUI controls as disallowed unless the contract explicitly permits them.
5. Use accessibility requirements as part of the output contract, not as optional post-processing.

## Validation

Validate generated specs before trying to create Figma output:

```bash
python3 scripts/validate_page_spec.py docs/ai/examples/auth-login.yaml
```

The validator checks two layers:

- structural validity against `page-spec.schema.json`
- semantic validity against `design-system-contract.yaml`

Transform a valid page spec into Figma-ready JSON:

```bash
python3 scripts/transform_page_spec_to_figma.py \
  docs/ai/examples/auth-login.yaml \
  docs/ai/output/auth-login.json
```

The transformer currently produces a deterministic Figma-oriented instance tree:

- page metadata
- screen frame metadata
- section frames
- component instances
- variant properties
- component properties

It is designed as the bridge between AI page generation and a future Figma API or plugin writer.

## External Principles Used

This AI layer is shaped by a few external principles:

- Carbon for AI: AI should be identifiable, explainable, and not purely decorative.
- W3C Design Tokens draft: tokens should have a consistent, portable format.
- Figma component properties and variables: component decisions should be representable in design tooling, not only in code.
- Structured-output practice: the system should be serializable enough that an AI can emit predictable, validated page specs.

## Next Step

The next evolution after this registry is a generator/validator flow:

- prompt -> page spec JSON/YAML
- validate against component registry
- transform into Figma nodes or a Figma-ready intermediate format
- compare output against pattern rules and accessibility rules
