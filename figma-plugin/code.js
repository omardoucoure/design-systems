figma.showUI(__html__, { width: 480, height: 520 });

const SPACING = 24;
const SECTION_SPACING = 16;
const INSTANCE_SPACING = 12;

figma.ui.onmessage = async (msg) => {
  if (msg.type !== "create-page") {
    return;
  }

  try {
    const bundle = JSON.parse(msg.bundleText);
    await ensureFont();
    const page = figma.createPage();
    page.name = bundle.page.name;
    figma.currentPage = page;

    const screen = figma.createFrame();
    screen.name = bundle.screenFrame.name;
    screen.layoutMode = bundle.screenFrame.layoutMode || "VERTICAL";
    screen.primaryAxisSizingMode = bundle.screenFrame.primaryAxisSizingMode || "AUTO";
    screen.counterAxisSizingMode = bundle.screenFrame.counterAxisSizingMode || "AUTO";
    screen.paddingLeft = SPACING;
    screen.paddingRight = SPACING;
    screen.paddingTop = SPACING;
    screen.paddingBottom = SPACING;
    screen.itemSpacing = SECTION_SPACING;
    screen.resize(390, 844);
    page.appendChild(screen);

    for (const section of bundle.sections) {
      const sectionFrame = figma.createFrame();
      sectionFrame.name = section.title || section.id;
      sectionFrame.layoutMode = "VERTICAL";
      sectionFrame.primaryAxisSizingMode = "AUTO";
      sectionFrame.counterAxisSizingMode = "AUTO";
      sectionFrame.itemSpacing = INSTANCE_SPACING;
      sectionFrame.fills = [];
      screen.appendChild(sectionFrame);

      for (const node of section.nodes) {
        const created = await createNodeFromBundle(node);
        sectionFrame.appendChild(created);
      }
    }

    figma.viewport.scrollAndZoomIntoView([screen]);
    figma.ui.postMessage({ type: "status", text: "Page created." });
  } catch (error) {
    figma.ui.postMessage({
      type: "status",
      text: `Failed to create page: ${error && error.message ? error.message : String(error)}`
    });
  }
};

async function ensureFont() {
  await figma.loadFontAsync({ family: "Inter", style: "Regular" });
  await figma.loadFontAsync({ family: "Inter", style: "Medium" });
}

async function createNodeFromBundle(node) {
  const component = findBestComponent(node.lookup.figmaComponent, node.variantProperties || {});
  if (!component) {
    return createFallback(node, `Missing component: ${node.lookup.figmaComponent}`);
  }

  const instance = component.createInstance();
  instance.name = node.id;
  applyComponentProperties(instance, node.componentProperties || {});
  applyAccessibility(instance, node.accessibility || {});
  return instance;
}

function findBestComponent(name, variantProperties) {
  const components = figma.root.findAll((node) => {
    return (node.type === "COMPONENT" || node.type === "COMPONENT_SET") && node.name === name;
  });

  if (components.length === 0) {
    const looseMatches = figma.root.findAll((node) => {
      return (node.type === "COMPONENT" || node.type === "COMPONENT_SET") && node.name.toLowerCase().includes(name.toLowerCase());
    });
    return chooseVariant(looseMatches, variantProperties);
  }

  return chooseVariant(components, variantProperties);
}

function chooseVariant(nodes, variantProperties) {
  for (const node of nodes) {
    if (node.type === "COMPONENT") {
      return node;
    }
    if (node.type === "COMPONENT_SET") {
      const exact = node.children.find((child) => matchesVariantName(child.name, variantProperties));
      if (exact) {
        return exact;
      }
      if (node.children.length > 0) {
        return node.children[0];
      }
    }
  }
  return null;
}

function matchesVariantName(name, variantProperties) {
  const parts = name.split(",").map((part) => part.trim());
  const lookup = {};
  for (const part of parts) {
    const index = part.indexOf("=");
    if (index === -1) {
      continue;
    }
    lookup[part.slice(0, index)] = part.slice(index + 1);
  }

  for (const [key, value] of Object.entries(variantProperties)) {
    if (String(lookup[key] || "").toLowerCase() !== String(value).toLowerCase()) {
      return false;
    }
  }
  return true;
}

function applyComponentProperties(instance, properties) {
  if (!instance.componentProperties) {
    return;
  }

  const updates = {};
  for (const [wantedName, wantedValue] of Object.entries(properties)) {
    const definitionKey = findPropertyDefinitionKey(instance.componentProperties, wantedName);
    if (!definitionKey) {
      continue;
    }
    updates[definitionKey] = normalizePropertyValue(wantedValue);
  }

  if (Object.keys(updates).length > 0) {
    instance.setProperties(updates);
  }
}

function findPropertyDefinitionKey(definitions, wantedName) {
  const normalizedWanted = normalizeName(wantedName);
  return Object.keys(definitions).find((key) => normalizeName(key.split("#")[0]) === normalizedWanted);
}

function normalizeName(value) {
  return String(value).toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();
}

function normalizePropertyValue(value) {
  if (typeof value === "boolean") {
    return value;
  }
  if (typeof value === "number") {
    return String(value);
  }
  return String(value);
}

function applyAccessibility(node, accessibility) {
  if (accessibility.label) {
    node.setPluginData("accessibilityLabel", accessibility.label);
  }
  if (accessibility.hint) {
    node.setPluginData("accessibilityHint", accessibility.hint);
  }
}

function createFallback(node, message) {
  const frame = figma.createFrame();
  frame.name = `${node.id}-fallback`;
  frame.layoutMode = "VERTICAL";
  frame.primaryAxisSizingMode = "AUTO";
  frame.counterAxisSizingMode = "AUTO";
  frame.itemSpacing = 8;
  frame.paddingLeft = 12;
  frame.paddingRight = 12;
  frame.paddingTop = 12;
  frame.paddingBottom = 12;
  frame.fills = [{ type: "SOLID", color: { r: 0.98, g: 0.95, b: 0.95 } }];
  frame.cornerRadius = 12;
  frame.strokes = [{ type: "SOLID", color: { r: 0.85, g: 0.5, b: 0.5 } }];

  const title = figma.createText();
  title.fontName = { family: "Inter", style: "Medium" };
  title.characters = node.lookup.figmaComponent;
  frame.appendChild(title);

  const body = figma.createText();
  body.fontName = { family: "Inter", style: "Regular" };
  body.characters = message;
  body.fontSize = 11;
  frame.appendChild(body);

  return frame;
}
