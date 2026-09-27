(function (root) {
  const cancels = new WeakMap();
  const reduced = () => root.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const token = name => parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));

  function track(element, cancel) {
    cancels.set(element, cancel);
  }

  function stop(element) {
    const cancel = cancels.get(element);
    if (cancel) cancel();
    cancels.delete(element);
  }

  function after(element, duration, action) {
    if (reduced()) {
      action();
      return;
    }
    const id = setTimeout(action, duration);
    track(element, () => clearTimeout(id));
  }

  function count(element) {
    const from = Number(element.dataset.countFrom || 0);
    const to = Number(element.dataset.countTo);
    if (reduced()) {
      element.textContent = String(to);
      return;
    }
    const duration = token("--motion-dur-count");
    const start = performance.now();
    let id = 0;
    const frame = now => {
      const progress = Math.min((now - start) / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      element.textContent = String(Math.round(from + (to - from) * eased));
      if (progress < 1) id = requestAnimationFrame(frame);
    };
    element.textContent = String(from);
    id = requestAnimationFrame(frame);
    track(element, () => cancelAnimationFrame(id));
  }

  function type(element) {
    const text = element.dataset.text;
    if (reduced()) {
      element.textContent = text;
      return;
    }
    let index = 0;
    element.textContent = "";
    const id = setInterval(() => {
      index += 1;
      element.textContent = text.slice(0, index);
      if (index >= text.length) clearInterval(id);
    }, token("--motion-type-char"));
    track(element, () => clearInterval(id));
  }

  function bubble(element) {
    after(element, token("--motion-dur-typing"), () => element.classList.add("is-typed"));
  }

  function check(element) {
    const input = element.querySelector("input[type=checkbox]");
    if (!input || !element.hasAttribute("data-done")) return;
    after(element, token("--motion-dur-slow"), () => {
      input.checked = true;
    });
  }

  const players = { count, type, bubble, check };
  const resetters = {};

  function register(name, player) {
    players[name] = player.play;
    resetters[name] = player.reset;
  }

  function play(element) {
    stop(element);
    const player = players[element.dataset.anim];
    if (player) player(element);
  }

  function reset(element) {
    stop(element);
    const anim = element.dataset.anim;
    if (resetters[anim]) resetters[anim](element);
    if (anim === "count") element.textContent = String(element.dataset.countFrom || 0);
    if (anim === "type") element.textContent = element.dataset.text;
    if (anim === "bubble") element.classList.remove("is-typed");
    if (anim === "check" && element.hasAttribute("data-done")) {
      const input = element.querySelector("input[type=checkbox]");
      if (input) input.checked = false;
    }
  }

  function prepare(element) {
    const anim = element.dataset.anim;
    if (anim === "draw" && typeof element.getTotalLength === "function") {
      element.style.setProperty("--len", element.getTotalLength() + "px");
      if (element.dataset.drawTo) element.style.setProperty("--draw-to", element.dataset.drawTo);
    }
    if (anim === "type") element.dataset.text = element.textContent;
    if (anim === "count") element.textContent = String(element.dataset.countFrom || 0);
    if (element.hasAttribute("data-stagger")) {
      Array.from(element.children).forEach((child, index) => child.style.setProperty("--i", String(index)));
    }
  }

  root.DeckEffects = { play, reset, prepare, register };
})(window);
