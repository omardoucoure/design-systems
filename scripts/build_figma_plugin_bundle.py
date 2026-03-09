#!/usr/bin/env python3

from __future__ import annotations

import json
import sys
from pathlib import Path

from validate_page_spec import load_data  # type: ignore


ROOT = Path(__file__).resolve().parent.parent
AI_DIR = ROOT / "docs" / "ai"


def build_bundle(figma_json: dict) -> dict:
    sections = []
    for section in figma_json["figma"]["sections"]:
        nodes = []
        for node in section["children"]:
            nodes.append({
                "id": node["id"],
                "kind": "component-instance",
                "role": node["role"],
                "lookup": {
                    "component": node["component"],
                    "figmaComponent": node["figmaComponent"]
                },
                "variantProperties": node.get("variantProperties", {}),
                "componentProperties": node.get("componentProperties", {}),
                "accessibility": node.get("accessibility", {})
            })
        sections.append({
            "id": section["id"],
            "patternId": section["patternId"],
            "title": section.get("title"),
            "nodes": nodes
        })

    return {
        "meta": {
            **figma_json.get("meta", {}),
            "bundleType": "figma-plugin-bundle"
        },
        "page": figma_json["page"],
        "screenFrame": figma_json["figma"]["screenFrame"],
        "sections": sections,
        "copy": figma_json.get("copy", []),
        "assets": figma_json.get("assets", []),
        "accessibility": figma_json.get("accessibility", {}),
        "implementation_notes": figma_json.get("implementation_notes", [])
    }


def main() -> int:
    if len(sys.argv) != 3:
        print("usage: build_figma_plugin_bundle.py <figma-json> <output-bundle>", file=sys.stderr)
        return 2

    figma_json = load_data(Path(sys.argv[1]).resolve())
    output_path = Path(sys.argv[2]).resolve()
    bundle = build_bundle(figma_json)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(bundle, indent=2))
    print(f"wrote {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
