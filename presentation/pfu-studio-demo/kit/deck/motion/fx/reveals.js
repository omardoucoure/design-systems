(function () {
  const numberOf = (element, name, fallback) => Number(element.dataset[name]) || fallback;

  function seeded(seed) {
    let state = seed % 2147483647 || 1;
    return () => {
      state = (state * 16807) % 2147483647;
      return (state - 1) / 2147483646;
    };
  }

  function fill(grid, count) {
    const template = grid.firstElementChild;
    if (!template) return;
    while (grid.children.length < count) grid.appendChild(template.cloneNode(true));
  }

  function ripple(grid) {
    const cols = numberOf(grid, "cols", 16);
    fill(grid, numberOf(grid, "count", 0));
    grid.style.setProperty("--rv-cols", String(cols));
    const tiles = Array.from(grid.children);
    const rows = Math.ceil(tiles.length / cols);
    const random = seeded(tiles.length * 31 + cols);
    tiles.forEach((tile, index) => {
      const dx = (index % cols) - (cols - 1) / 2;
      const dy = Math.floor(index / cols) - (rows - 1) / 2;
      tile.style.setProperty("--rv-ring", Math.hypot(dx, dy).toFixed(2));
      tile.style.setProperty("--rv-seed", random().toFixed(3));
    });
  }

  function particles(field) {
    const count = numberOf(field, "count", 12);
    const cols = numberOf(field, "cols", 16);
    const rows = numberOf(field, "rows", 8);
    const random = seeded(count * 131 + rows);
    for (let index = 0; index < count; index += 1) {
      const dot = document.createElement("i");
      dot.style.setProperty("--rv-x", (((Math.floor(random() * cols) + 0.5) / cols) * 100).toFixed(2));
      dot.style.setProperty("--rv-y", (((Math.floor(random() * rows) + 0.5) / rows) * 100).toFixed(2));
      dot.style.setProperty("--rv-seed", random().toFixed(3));
      field.appendChild(dot);
    }
  }

  document.querySelectorAll(".rv-ripple").forEach(ripple);
  document.querySelectorAll(".rv-particles").forEach(particles);
})();
