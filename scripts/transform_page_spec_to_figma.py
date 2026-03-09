#!/usr/bin/env python3

from __future__ import annotations

import json
import sys
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parent.parent
AI_DIR = ROOT / "docs" / "ai"
CONTRACT_PATH = AI_DIR / "design-system-contract.yaml"
MAPPING_PATH = AI_DIR / "figma-mapping.yaml"

sys.path.insert(0, str((ROOT / "scripts").resolve()))
from validate_page_spec import load_data, validate_against_contract, validate_against_schema  # type: ignore  # noqa: E402


SCHEMA_PATH = AI_DIR / "page-spec.schema.json"


def build_variant_properties(component_spec: dict) -> dict:
    variant = {}
    if "variant" in component_spec:
        variant["variant"] = component_spec["variant"]
    if "size" in component_spec:
        variant["size"] = component_spec["size"]
    if "state" in component_spec:
        variant["state"] = component_spec["state"]
    return variant


def to_figma_instance(component: dict, mapping: dict) -> dict:
    component_name = component["component"]
    mapping_entry = mapping["components"].get(component_name, {})
    property_keys = mapping_entry.get("property_keys", {})
    variant_keys = mapping_entry.get("variant_keys", {})

    props = component.get("props", {})
    figma_properties = {}
    for key, value in props.items():
        figma_key = property_keys.get(key, key)
        figma_properties[figma_key] = value

    variant_properties = {}
    if "variant" in component:
        variant_properties[variant_keys.get("variant", "Variant")] = component["variant"]
    if "size" in component:
        variant_properties[variant_keys.get("size", "Size")] = component["size"]
    if "state" in component:
        variant_properties[variant_keys.get("state", "State")] = component["state"]
    if component_name == "DSButton":
        content_mode = "text"
        if "assetIcon" in props and "label" not in props:
            content_mode = "icon-only"
        elif "assetIcon" in props and "label" in props:
            content_mode = "text+icon"
        elif "icon" in props and "label" not in props:
            content_mode = "icon-only"
        elif ("iconLeft" in props or "iconRight" in props or "systemIcon" in props) and "label" in props:
            content_mode = "text+icon"
        variant_properties[variant_keys.get("content_mode", "Content")] = content_mode

    return {
        "id": component["id"],
        "nodeType": "INSTANCE",
        "component": component_name,
        "figmaComponent": mapping_entry.get("figma_component", component_name),
        "role": component["role"],
        "variantProperties": variant_properties,
        "componentProperties": figma_properties,
        "accessibility": component.get("accessibility", {})
    }


def transform(spec: dict, contract: dict, mapping: dict) -> dict:
    component_map = {item["id"]: item for item in spec["components"]}
    section_nodes = []
    flat_instances = []

    for section in spec["sections"]:
        instances = [to_figma_instance(component_map[ref], mapping) for ref in section["component_refs"]]
        flat_instances.extend(instances)
        section_nodes.append({
            "id": section["id"],
            "patternId": section["pattern_id"],
            "title": section.get("title"),
            "nodeType": "FRAME",
            "layoutMode": "VERTICAL",
            "children": instances
        })

    return {
        "meta": {
            "generator": "HaHo AI page-spec transformer",
            "contractVersion": contract["version"],
            "mappingVersion": mapping["version"]
        },
        "page": {
            "id": spec["page_id"],
            "name": spec["page_name"],
            "type": spec["page_type"],
            "description": spec.get("description", ""),
            "theme": spec["theme"]
        },
        "figma": {
            "rootPageNodeType": mapping["figma"]["root"]["page_node_type"],
            "screenNodeType": mapping["figma"]["root"]["screen_node_type"],
            "screenFrame": {
                "name": spec["page_name"],
                "layoutMode": mapping["figma"]["root"]["default_layout_mode"],
                "primaryAxisSizingMode": mapping["figma"]["root"]["default_primary_axis_sizing_mode"],
                "counterAxisSizingMode": mapping["figma"]["root"]["default_counter_axis_sizing_mode"]
            },
            "sections": section_nodes,
            "instances": flat_instances
        },
        "copy": spec.get("copy", []),
        "assets": spec.get("assets", []),
        "accessibility": spec["accessibility"],
        "implementation_notes": spec.get("implementation_notes", [])
    }


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: transform_page_spec_to_figma.py <spec-file> <output-json>", file=sys.stderr)
        return 2

    spec_path = Path(sys.argv[1]).resolve()
    output_path = Path(sys.argv[2]).resolve()

    schema = load_data(SCHEMA_PATH)
    contract = load_data(CONTRACT_PATH)
    mapping = load_data(MAPPING_PATH)
    spec = load_data(spec_path)

    errors = []
    errors.extend(validate_against_schema(spec, schema))
    errors.extend(validate_against_contract(spec, contract))
    if errors:
        print(f"{spec_path}: invalid", file=sys.stderr)
        for error in errors:
            print(f"  - {error}", file=sys.stderr)
        return 1

    output = transform(spec, contract, mapping)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(output, indent=2))
    print(f"wrote {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
