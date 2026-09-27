(function (root) {
  const CUE = '[data-anim="pt-cue"]';
  const ARROW = "M0 0L0 17.5L4.6 13.4L7.6 20.2L10.6 18.9L7.7 12.3L13.8 12.3Z";
  const PEN = "M1 23L3 16L17 2Q19 0 21 2L22 3Q24 5 22 7L8 21ZM3 16L8 21M15 4L20 9";
  const timers = new WeakMap();
  const active = new WeakMap();
  const drawing = new WeakSet();
  const reduced = () => root.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const token = name => parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));
  const num = (value, fallback) => (value === undefined || value === "" ? fallback : Number(value));
  const orderOf = cue => num(cue.dataset.step, 0) * 100000 + num(cue.dataset.delay, 0);

  function stageOf(element) {
    return element.closest(".mo-stage") || element.closest(".scene");
  }

  function pointerOf(stage) {
    return stage && stage.querySelector(".pt-pointer");
  }

  function scaleOf(frame) {
    return frame.offsetWidth ? frame.getBoundingClientRect().width / frame.offsetWidth : 1;
  }

  function boxIn(element, frame) {
    const origin = frame.getBoundingClientRect();
    const rect = element.getBoundingClientRect();
    const k = scaleOf(frame);
    return { x: (rect.left - origin.left) / k, y: (rect.top - origin.top) / k, w: rect.width / k, h: rect.height / k };
  }

  function find(stage, selector) {
    return selector ? stage.querySelector(selector) : null;
  }

  function pointOn(path, stage, t) {
    const point = path.getPointAtLength(path.getTotalLength() * t);
    const box = boxIn(path.ownerSVGElement, stage);
    return { x: box.x + point.x, y: box.y + point.y };
  }

  function spotOf(cue, stage) {
    const path = find(stage, cue.dataset.draw);
    if (path) return pointOn(path, stage, 1);
    const target = find(stage, cue.dataset.target);
    if (!target) return null;
    const box = boxIn(target, stage);
    return { x: box.x + box.w * num(cue.dataset.x, 0.5), y: box.y + box.h * num(cue.dataset.y, 0.5) };
  }

  function place(pointer, spot, snap) {
    if (!spot) return;
    if (snap) pointer.classList.add("is-snap");
    pointer.style.translate = `${spot.x}px ${spot.y}px`;
    pointer.dataset.x = spot.x;
    pointer.dataset.y = spot.y;
    if (snap) {
      pointer.getBoundingClientRect();
      pointer.classList.remove("is-snap");
    }
  }

  function cancel(cue) {
    const stop = timers.get(cue);
    if (stop) stop();
    timers.delete(cue);
  }

  function later(cue, delay, action) {
    cancel(cue);
    if (!delay) {
      action();
      return;
    }
    const id = setTimeout(action, delay);
    timers.set(cue, () => clearTimeout(id));
  }

  function frameLoop(cue, frame) {
    const id = requestAnimationFrame(frame);
    timers.set(cue, () => cancelAnimationFrame(id));
  }

  function latestCue(stage, except, extra) {
    const shown = Array.from(stage.querySelectorAll(CUE))
      .filter(cue => cue !== except && (cue === extra || cue.classList.contains("is-shown")));
    return shown.sort((a, b) => orderOf(a) - orderOf(b)).pop();
  }

  function hover(stage, cue) {
    stage.querySelectorAll(".is-hover").forEach(element => element.classList.remove("is-hover"));
    const target = cue && cue.dataset.hover !== "off" && find(stage, cue.dataset.target);
    if (target) target.classList.add("is-hover");
  }

  function ring(pointer) {
    const halo = pointer.querySelector(".pt-pointer__ring");
    pointer.querySelector(".pt-pointer__glyph").animate(
      [{ scale: "1" }, { scale: String(token("--fx-pt-press")) }, { scale: "1" }],
      { duration: token("--motion-dur-base"), easing: "ease-in-out" }
    );
    halo.animate(
      [{ opacity: 0.8, scale: "0.3" }, { opacity: 0, scale: "1" }],
      { duration: token("--motion-dur-slow"), easing: "ease-out" }
    );
  }

  function click(cue, stage, animated) {
    if (!cue.hasAttribute("data-press")) return;
    const target = find(stage, cue.dataset.target);
    if (!target) return;
    if (!animated) {
      target.classList.add("is-clicked");
      return;
    }
    ring(pointerOf(stage));
    target.classList.add("is-pressed");
    later(cue, token("--motion-dur-fast"), () => {
      target.classList.remove("is-pressed");
      target.classList.add("is-clicked");
    });
  }

  function arrive(cue, stage, animated) {
    hover(stage, cue);
    click(cue, stage, animated);
  }

  function ink(path, t) {
    path.style.strokeDashoffset = String(1 - t);
  }

  function draw(cue, stage, pointer) {
    const path = find(stage, cue.dataset.draw);
    if (reduced()) {
      ink(path, 1);
      place(pointer, pointOn(path, stage, 1), true);
      arrive(cue, stage, false);
      return;
    }
    const duration = num(cue.dataset.dur, token("--fx-pt-draw"));
    const start = performance.now();
    drawing.add(pointer);
    pointer.classList.add("is-snap");
    const frame = now => {
      const t = Math.min((now - start) / duration, 1);
      ink(path, t);
      place(pointer, pointOn(path, stage, t), false);
      if (t < 1) {
        frameLoop(cue, frame);
        return;
      }
      drawing.delete(pointer);
      pointer.classList.remove("is-snap");
      arrive(cue, stage, true);
    };
    frameLoop(cue, frame);
  }

  function finish(cue, stage, pointer) {
    cancel(cue);
    drawing.delete(pointer);
    pointer.classList.remove("is-snap");
    const path = find(stage, cue.dataset.draw);
    if (path) ink(path, 1);
    const target = find(stage, cue.dataset.target);
    if (target) target.classList.remove("is-pressed");
    click(cue, stage, false);
    if (pointer.classList.contains("is-on")) place(pointer, spotOf(cue, stage), true);
  }

  function aim(cue, stage, pointer) {
    active.set(stage, cue);
    hover(stage, null);
    const spot = spotOf(cue, stage);
    if (!spot) {
      pointer.classList.remove("is-on");
      return;
    }
    const wasOn = pointer.classList.contains("is-on");
    pointer.classList.add("is-on");
    if (cue.dataset.draw) {
      place(pointer, pointOn(find(stage, cue.dataset.draw), stage, 0), !wasOn);
      draw(cue, stage, pointer);
      return;
    }
    const glide = wasOn && !reduced();
    place(pointer, spot, !glide);
    later(cue, glide ? token("--pt-glide") : 0, () => arrive(cue, stage, !reduced()));
  }

  function play(cue) {
    const stage = stageOf(cue);
    const pointer = pointerOf(stage);
    if (!pointer) return;
    const previous = active.get(stage);
    if (previous && previous !== cue) finish(previous, stage, pointer);
    if (latestCue(stage, null, cue) !== cue) {
      finish(cue, stage, pointer);
      return;
    }
    aim(cue, stage, pointer);
  }

  function undo(cue, stage) {
    const path = find(stage, cue.dataset.draw);
    if (path) path.style.removeProperty("stroke-dashoffset");
    const target = find(stage, cue.dataset.target);
    if (target && cue.hasAttribute("data-press")) target.classList.remove("is-pressed", "is-clicked");
  }

  function reset(cue) {
    const stage = stageOf(cue);
    const pointer = pointerOf(stage);
    cancel(cue);
    undo(cue, stage);
    if (!pointer || active.get(stage) !== cue) return;
    drawing.delete(pointer);
    pointer.classList.remove("is-snap");
    const back = latestCue(stage, cue);
    if (!back) {
      active.delete(stage);
      hover(stage, null);
      pointer.classList.remove("is-on");
      return;
    }
    active.set(stage, back);
    place(pointer, spotOf(back, stage), reduced());
    hover(stage, back);
  }

  function track() {
    document.querySelectorAll(".scene.is-active .pt-pointer.is-on").forEach(pointer => {
      const stage = stageOf(pointer);
      const cue = active.get(stage);
      if (!cue || drawing.has(pointer)) return;
      const spot = spotOf(cue, stage);
      if (!spot) return;
      if (Math.abs(spot.x - Number(pointer.dataset.x)) + Math.abs(spot.y - Number(pointer.dataset.y)) > 0.5) place(pointer, spot, false);
    });
    requestAnimationFrame(track);
  }

  function build(pointer) {
    const shape = pointer.classList.contains("pt-pointer--pen") ? PEN : ARROW;
    pointer.innerHTML = `<span class="pt-pointer__ring"></span><svg class="pt-pointer__glyph" viewBox="0 0 24 24"><path d="${shape}"/></svg>`;
  }

  document.querySelectorAll(".pt-pointer").forEach(build);
  document.querySelectorAll(".pt-ink").forEach(path => path.setAttribute("pathLength", "1"));
  root.DeckEffects.register("pt-cue", { play, reset });
  requestAnimationFrame(track);
})(window);
