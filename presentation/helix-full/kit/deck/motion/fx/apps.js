(function (root) {
  const stepOf = element => Number(element.dataset.step) || 0;

  function latest(items, except, extra) {
    const shown = items.filter(item => item !== except && (item === extra || item.classList.contains("is-shown")));
    return shown.sort((a, b) => stepOf(a) - stepOf(b)).pop();
  }

  function groupOf(element) {
    const scope = element.closest(".scene") || document;
    const name = element.dataset.group || "";
    return Array.from(scope.querySelectorAll('[data-anim="ap-select"]')).filter(item => (item.dataset.group || "") === name);
  }

  function select(element, except, extra) {
    const items = groupOf(element);
    const current = latest(items, except, extra);
    items.forEach(item => item.classList.toggle("is-current", item === current));
  }

  function offsetWithin(element, ancestor) {
    let y = 0;
    let node = element;
    while (node && node !== ancestor) {
      y += node.offsetTop;
      node = node.offsetParent;
    }
    return y;
  }

  function scrollTarget(mark, content, viewport) {
    const limit = Math.max(0, content.scrollHeight - viewport.clientHeight);
    if (mark.dataset.to === "end") return limit;
    const target = content.querySelector(mark.dataset.to);
    if (!target) return 0;
    const y = offsetWithin(target, content) - (Number(mark.dataset.offset) || 0);
    return Math.min(limit, Math.max(0, y));
  }

  function scroll(mark, except, extra) {
    const viewport = mark.closest(".ap-viewport");
    const content = viewport && viewport.querySelector(".ap-viewport__content");
    if (!content) return;
    const marks = Array.from(viewport.querySelectorAll('[data-anim="ap-scroll"]'));
    const current = latest(marks, except, extra);
    const y = current ? scrollTarget(current, content, viewport) : 0;
    content.style.setProperty("--ap-scroll-y", y + "px");
  }

  function boxIn(element, frame) {
    const origin = frame.getBoundingClientRect();
    const rect = element.getBoundingClientRect();
    const k = frame.offsetWidth ? origin.width / frame.offsetWidth : 1;
    return { x: (rect.left - origin.left) / k, y: (rect.top - origin.top) / k, w: rect.width / k, h: rect.height / k };
  }

  function punch(element, except, extra) {
    const cam = element.closest(".mo-cam");
    if (!cam) return;
    const target = latest(Array.from(cam.querySelectorAll('[data-anim="ap-punch"]')), except, extra);
    if (!target) {
      ["--cam-x", "--cam-y", "--cam-s"].forEach(name => cam.style.removeProperty(name));
      return;
    }
    const box = boxIn(target, cam);
    const width = cam.offsetWidth;
    const height = cam.offsetHeight;
    const zoom = Number(target.dataset.zoom) || 1.5;
    const scale = Math.min(zoom, width / box.w, height / box.h);
    cam.style.setProperty("--cam-s", String(scale));
    cam.style.setProperty("--cam-x", width / 2 - (box.x + box.w / 2) * scale + "px");
    cam.style.setProperty("--cam-y", height / 2 - (box.y + box.h / 2) * scale + "px");
  }

  root.DeckEffects.register("ap-punch", {
    play: element => punch(element, null, element),
    reset: element => punch(element, element, null)
  });
  root.DeckEffects.register("ap-select", {
    play: element => select(element, null, element),
    reset: element => select(element, element, null)
  });
  root.DeckEffects.register("ap-scroll", {
    play: mark => scroll(mark, null, mark),
    reset: mark => scroll(mark, mark, null)
  });
})(window);
