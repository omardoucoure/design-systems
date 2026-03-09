#!/usr/bin/env python3

from __future__ import annotations

import json
import sys
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parent.parent
AI_DIR = ROOT / "docs" / "ai"
SCHEMA_PATH = AI_DIR / "page-spec.schema.json"
CONTRACT_PATH = AI_DIR / "design-system-contract.yaml"
MAPPING_PATH = AI_DIR / "figma-mapping.yaml"
RULES_PATH = AI_DIR / "figma-playground-rules.yaml"
TEMPLATE_PATH = AI_DIR / "playground-handoff-template.md"

sys.path.insert(0, str((ROOT / "scripts").resolve()))
from validate_page_spec import load_data, validate_against_contract, validate_against_schema  # type: ignore  # noqa: E402
from transform_page_spec_to_figma import transform  # type: ignore  # noqa: E402


def build_section_lines(spec: dict, figma_json: dict) -> str:
    component_lookup = {item["id"]: item for item in spec["components"]}
    lines: list[str] = []
    for section in spec["sections"]:
        lines.append(
            f"- `{section['id']}` uses pattern `{section['pattern_id']}` and renders as a vertical section frame."
        )
        if section.get("title"):
            lines.append(f"  Title: {section['title']}")
        refs = ", ".join(f"`{ref}`" for ref in section["component_refs"])
        lines.append(f"  Component order: {refs}")
        for ref in section["component_refs"]:
            component = component_lookup[ref]
            props = component.get("props", {})
            variant_bits = []
            for key in ("variant", "size", "state"):
                if key in component:
                    variant_bits.append(f"{key}={component[key]}")
            variant_text = ", ".join(variant_bits) if variant_bits else "default"
            lines.append(
                f"  - `{ref}` => `{component['component']}` role `{component['role']}` ({variant_text}) with props {json.dumps(props, ensure_ascii=True, sort_keys=True)}"
            )
    return "\n".join(lines)


def build_component_summary(spec: dict, mapping: dict) -> str:
    lines: list[str] = []
    for component in spec["components"]:
        mapping_entry = mapping["components"].get(component["component"], {})
        figma_component = mapping_entry.get("figma_component", component["component"])
        lines.append(
            f"- `{component['id']}` maps `{component['component']}` to Figma component `{figma_component}`."
        )
    return "\n".join(lines)


def build_handoff(spec: dict, contract: dict, mapping: dict, rules: dict, transformed: dict, template_text: str) -> str:
    theme = spec["theme"]
    accessibility_notes = spec.get("accessibility", {}).get("notes", [])
    implementation_notes = spec.get("implementation_notes", [])

    parts = [
        template_text.strip(),
        "",
        "## Theme Summary",
        f"- Brand: `{theme['brand']}`",
        f"- Style: `{theme['style']}`",
        f"- Page type: `{spec['page_type']}`",
        f"- Page name: `{spec['page_name']}`",
    ]

    if spec.get("description"):
        parts.append(f"- Description: {spec['description']}")

    parts.extend(
        [
            "",
            "## Section Blueprint",
            build_section_lines(spec, transformed),
            "",
            "## Component Mapping Summary",
            build_component_summary(spec, mapping),
            "",
            "## Playground-Specific Rules",
        ]
    )
    parts.extend(f"- {rule}" for rule in rules["hard_rules"])

    parts.extend(
        [
            "",
            "## Accessibility Notes",
        ]
    )
    if accessibility_notes:
        parts.extend(f"- {note}" for note in accessibility_notes)
    else:
        parts.append("- No extra accessibility notes were supplied in the spec.")

    parts.extend(
        [
            "",
            "## Implementation Notes",
        ]
    )
    if implementation_notes:
        parts.extend(f"- {note}" for note in implementation_notes)
    else:
        parts.append("- No additional implementation notes were supplied in the spec.")

    parts.extend(
        [
            "",
            "## Machine-Readable Page Spec",
            "```yaml",
            yaml.safe_dump(spec, sort_keys=False).rstrip(),
            "```",
            "",
            "## Machine-Readable Figma Payload",
            "```json",
            json.dumps(transformed, indent=2),
            "```",
            "",
            "## Playground Rules Payload",
            "```yaml",
            yaml.safe_dump(rules, sort_keys=False).rstrip(),
            "```",
            "",
            "## Final Instruction To Playground",
            "Create this screen as a clean iPhone portrait layout using registered design-system components and auto-layout frames. Do not invent new primitives unless the exact component is unavailable.",
        ]
    )

    return "\n".join(parts) + "\n"


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: build_figma_playground_handoff.py <spec-file> <output-markdown>", file=sys.stderr)
        return 2

    spec_path = Path(sys.argv[1]).resolve()
    output_path = Path(sys.argv[2]).resolve()

    schema = load_data(SCHEMA_PATH)
    contract = load_data(CONTRACT_PATH)
    mapping = load_data(MAPPING_PATH)
    rules = load_data(RULES_PATH)
    spec = load_data(spec_path)

    errors = []
    errors.extend(validate_against_schema(spec, schema))
    errors.extend(validate_against_contract(spec, contract))
    if errors:
        print(f"{spec_path}: invalid", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    transformed = transform(spec, contract, mapping)
    template_text = TEMPLATE_PATH.read_text()
    handoff = build_handoff(spec, contract, mapping, rules, transformed, template_text)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(handoff)
    print(f"wrote {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
