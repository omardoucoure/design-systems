# Figma Plugin Workflow

This workflow is the first operational path from AI page specs to Figma.

## Files

- [`page-spec.schema.json`](page-spec.schema.json)
- [`design-system-contract.yaml`](design-system-contract.yaml)
- [`figma-mapping.yaml`](figma-mapping.yaml)
- [`../../scripts/validate_page_spec.py`](../../scripts/validate_page_spec.py)
- [`../../scripts/transform_page_spec_to_figma.py`](../../scripts/transform_page_spec_to_figma.py)
- [`../../scripts/build_figma_plugin_bundle.py`](../../scripts/build_figma_plugin_bundle.py)
- [`../../figma-plugin`](../../figma-plugin)

## Flow

1. Generate a page spec YAML or JSON.
2. Validate the page spec.
3. Transform the page spec into Figma-oriented JSON.
4. Build a plugin bundle from that JSON.
5. Paste the plugin bundle into the Figma plugin UI.
6. Let the plugin create frames and instances in the active file.

## Commands

```bash
python3 scripts/validate_page_spec.py docs/ai/examples/auth-login.yaml

python3 scripts/transform_page_spec_to_figma.py \
  docs/ai/examples/auth-login.yaml \
  docs/ai/output/auth-login.json

python3 scripts/build_figma_plugin_bundle.py \
  docs/ai/output/auth-login.json \
  docs/ai/output/auth-login.bundle.json
```

## Current Plugin Behavior

- Creates a new Figma page and a screen frame
- Creates section frames vertically
- Resolves components by Figma component name
- Chooses component variants heuristically from component-set child names
- Applies component properties where property names match
- Stores accessibility metadata in plugin data
- Falls back to visible placeholder frames when a component cannot be found

## Constraints

- The plugin expects component names in the active Figma file or available local libraries.
- Variant resolution is heuristic until exact component/property IDs are known.
- Property application depends on name matching against live Figma component property definitions.
- Accessibility metadata is stored in plugin data, not yet mapped to official Figma annotations.

## Recommended Next Improvements

- Replace name-based component lookup with explicit component node IDs.
- Replace heuristic variant selection with exact variant property resolution.
- Add layout metadata to the page spec so frames can use more accurate width and spacing rules.
- Add support for nested instances and slot content.
- Add a publish step for Code Connect mappings so Figma MCP can return exact code snippets for each instance.
