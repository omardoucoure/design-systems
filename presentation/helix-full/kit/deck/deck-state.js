(function (root) {
  function next(counts, pos) {
    if (pos.step < counts[pos.scene]) return { scene: pos.scene, step: pos.step + 1 };
    if (pos.scene < counts.length - 1) return { scene: pos.scene + 1, step: 0 };
    return pos;
  }

  function prev(counts, pos) {
    if (pos.step > 0) return { scene: pos.scene, step: pos.step - 1 };
    if (pos.scene > 0) return { scene: pos.scene - 1, step: counts[pos.scene - 1] };
    return pos;
  }

  function parseHash(counts, hash) {
    const match = /^#?(\d+)(?:\.(\d+))?$/.exec(hash || "");
    if (!match) return { scene: 0, step: 0 };
    const scene = Number(match[1]) - 1;
    if (scene < 0 || scene >= counts.length) return { scene: 0, step: 0 };
    return { scene, step: Math.min(Number(match[2] || 0), counts[scene]) };
  }

  function formatHash(pos) {
    return "#" + (pos.scene + 1) + "." + pos.step;
  }

  const api = { next, prev, parseHash, formatHash };
  if (typeof module !== "undefined" && module.exports) module.exports = api;
  else root.DeckState = api;
})(this);
