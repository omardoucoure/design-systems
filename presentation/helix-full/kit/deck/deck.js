(function () {
  const root = document.documentElement;
  const scenes = Array.from(document.querySelectorAll(".scene"));
  const progress = document.querySelector(".deck__progress-bar");
  const ANIMATED = "[data-anim], [data-step], [data-until], [data-stagger]";
  const NEXT_KEYS = ["ArrowRight", "ArrowDown", " ", "PageDown"];
  const PREV_KEYS = ["ArrowLeft", "ArrowUp", "PageUp"];

  document.querySelectorAll(ANIMATED).forEach(DeckEffects.prepare);

  const pending = new WeakMap();
  const exits = new Map();
  const stepOf = element => Number(element.dataset.step) || 0;
  const untilOf = element => (element.dataset.until ? Number(element.dataset.until) : Infinity);
  const delayOf = element => Number(element.dataset.delay) || 0;
  const lastStepOf = element => Math.max(stepOf(element), Number(element.dataset.until) || 0);
  const animatedIn = scene => Array.from(scene.querySelectorAll(ANIMATED));
  const counts = scenes.map(scene => Math.max(0, ...animatedIn(scene).map(lastStepOf)));
  let position = DeckState.parseHash(counts, location.hash);

  function renderScene(scene, index) {
    const active = index === position.scene;
    const leaving = !active && scene.classList.contains("is-active");
    scene.classList.toggle("is-active", active);
    scene.classList.toggle("is-past", index < position.scene);
    if (active) clearTimeout(exits.get(scene));
    if (leaving) {
      const duration = parseFloat(getComputedStyle(root).getPropertyValue("--motion-dur-scene")) || 0;
      exits.set(scene, setTimeout(() => renderElements(scene, false), duration));
      return;
    }
    if (!active && exits.has(scene)) return;
    renderElements(scene, active);
  }

  function renderElements(scene, active) {
    exits.delete(scene);
    animatedIn(scene).forEach(element => {
      const shown = active && stepOf(element) <= position.step && position.step < untilOf(element);
      const wasShown = element.classList.contains("is-shown");
      if (!shown) cancelPending(element);
      if (shown && !wasShown && !pending.has(element)) show(element, stepOf(element) === position.step ? delayOf(element) : 0);
      if (!shown && wasShown) {
        DeckEffects.reset(element);
        element.classList.remove("is-shown");
      }
    });
  }

  function reveal(element) {
    pending.delete(element);
    DeckEffects.play(element);
    element.classList.add("is-shown");
  }

  function show(element, delay) {
    if (!delay || matchMedia("(prefers-reduced-motion: reduce)").matches) {
      reveal(element);
      return;
    }
    pending.set(element, setTimeout(() => reveal(element), delay));
  }

  function cancelPending(element) {
    clearTimeout(pending.get(element));
    pending.delete(element);
  }

  function render() {
    scenes.forEach(renderScene);
    if (progress) progress.style.setProperty("--deck-progress", String((position.scene + 1) / scenes.length));
    history.replaceState(null, "", DeckState.formatHash(position));
  }

  function go(target) {
    position = target;
    render();
  }

  const next = () => go(DeckState.next(counts, position));
  const prev = () => go(DeckState.prev(counts, position));

  function onHashChange() {
    go(DeckState.parseHash(counts, location.hash));
  }

  function toggleFullscreen() {
    if (document.fullscreenElement) document.exitFullscreen().catch(() => {});
    else root.requestFullscreen().catch(() => {});
  }

  function onKey(event) {
    if (event.metaKey || event.ctrlKey || event.altKey) return;
    if (NEXT_KEYS.includes(event.key)) {
      event.preventDefault();
      next();
    } else if (PREV_KEYS.includes(event.key)) {
      event.preventDefault();
      prev();
    } else if (event.key && event.key.toLowerCase() === "f") {
      toggleFullscreen();
    }
  }

  function fit() {
    const style = getComputedStyle(root);
    const width = parseFloat(style.getPropertyValue("--deck-width"));
    const height = parseFloat(style.getPropertyValue("--deck-height"));
    root.style.setProperty("--deck-scale", String(Math.min(innerWidth / width, innerHeight / height)));
  }

  document.querySelectorAll("[data-next]").forEach(button => {
    button.addEventListener("click", event => {
      event.currentTarget.blur();
      next();
    });
  });
  addEventListener("keydown", onKey);
  addEventListener("resize", fit);
  addEventListener("hashchange", onHashChange);
  fit();
  render();
})();
