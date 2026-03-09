#!/usr/bin/env python3

from __future__ import annotations

import json
import sys
from pathlib import Path

import jsonschema
import yaml


ROOT = Path(__file__).resolve().parent.parent
AI_DIR = ROOT / "docs" / "ai"
SCHEMA_PATH = AI_DIR / "page-spec.schema.json"
CONTRACT_PATH = AI_DIR / "design-system-contract.yaml"


def load_data(path: Path):
    text = path.read_text()
    if path.suffix.lower() == ".json":
        return json.loads(text)
    return yaml.safe_load(text)


def validate_against_schema(spec: dict, schema: dict) -> list[str]:
    validator = jsonschema.Draft202012Validator(schema)
    errors = sorted(validator.iter_errors(spec), key=lambda err: list(err.absolute_path))
    return [
        f"schema: {'/'.join(map(str, err.absolute_path)) or '<root>'}: {err.message}"
        for err in errors
    ]


def validate_against_contract(spec: dict, contract: dict) -> list[str]:
    errors: list[str] = []

    brands = set(contract["system"]["theme_axes"]["brand"]["values"])
    styles = set(contract["system"]["theme_axes"]["style"]["values"])
    pattern_ids = {item["id"] for item in contract["page_patterns"]}
    component_names = {item["name"] for item in contract["components"]}

    theme = spec["theme"]
    if theme["brand"] not in brands:
        errors.append(f"contract: unknown brand '{theme['brand']}'")
    if theme["style"] not in styles:
        errors.append(f"contract: unknown style '{theme['style']}'")

    components = spec["components"]
    component_ids = {item["id"] for item in components}
    component_name_by_id = {item["id"]: item["component"] for item in components}

    for component in components:
        if component["component"] not in component_names:
            errors.append(
                f"contract: component '{component['component']}' is not registered"
            )

        props = component.get("props", {})
        accessibility = component.get("accessibility", {})
        icon_only = (
            "assetIcon" in props or "icon" in props or "systemIcon" in props
        ) and "label" not in props
        if component["component"] == "DSButton" and icon_only and "label" not in accessibility:
            errors.append(
                f"contract: icon-only DSButton '{component['id']}' requires accessibility.label"
            )

    for section in spec["sections"]:
        if section["pattern_id"] not in pattern_ids:
            errors.append(
                f"contract: section '{section['id']}' references unknown pattern '{section['pattern_id']}'"
            )
        for ref in section["component_refs"]:
            if ref not in component_ids:
                errors.append(
                    f"contract: section '{section['id']}' references unknown component id '{ref}'"
                )

    used_component_names = {
        component_name_by_id[ref]
        for section in spec["sections"]
        for ref in section["component_refs"]
        if ref in component_name_by_id
    }
    if spec["page_type"] in {"auth", "profile"} and "DSCard" not in used_component_names:
        errors.append(
            "contract: auth and profile pages should use DSCard-backed surfaces for registered patterns"
        )
    if spec["page_type"] == "alerts" and not (
        {"DSCard", "DSBanner", "DSAlertDialog"} & used_component_names
    ):
        errors.append(
            "contract: alerts pages should use DSCard, DSBanner, or DSAlertDialog as a primary feedback surface"
        )

    return errors


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: validate_page_spec.py <spec-file> [<spec-file> ...]", file=sys.stderr)
        return 2

    schema = load_data(SCHEMA_PATH)
    contract = load_data(CONTRACT_PATH)

    exit_code = 0
    for arg in sys.argv[1:]:
        path = Path(arg).resolve()
        spec = load_data(path)
        errors = []
        errors.extend(validate_against_schema(spec, schema))
        errors.extend(validate_against_contract(spec, contract))

        if errors:
            exit_code = 1
            print(f"{path}: invalid")
            for error in errors:
                print(f"  - {error}")
        else:
            print(f"{path}: valid")

    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
