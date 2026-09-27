(function (root) {
  function sourceOf(element) {
    const scope = element.closest(".mo-stage") || document;
    return scope.querySelector(element.dataset.flyFrom);
  }

  function clear(element) {
    element.style.removeProperty("--rw-dx");
    element.style.removeProperty("--rw-dy");
  }

  function aim(element) {
    clear(element);
    const source = sourceOf(element);
    if (!source) return;
    const from = source.getBoundingClientRect();
    const to = element.getBoundingClientRect();
    const scale = element.offsetWidth ? to.width / element.offsetWidth : 1;
    element.style.setProperty("--rw-dx", (from.left - to.left) / scale + "px");
    element.style.setProperty("--rw-dy", (from.top - to.top) / scale + "px");
  }

  root.DeckEffects.register("rw-fly", { play: aim, reset: clear });
})(window);
