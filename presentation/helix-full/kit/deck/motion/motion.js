(function (root) {
  const timers = new WeakMap();
  const ARROW = 8;
  const reduced = () => root.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const token = name => parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));
  const stepOf = element => Number(element.dataset.step) || 0;
  const round = value => Math.round(value * 10) / 10;

  function scaleOf(frame) {
    return frame.offsetWidth ? frame.getBoundingClientRect().width / frame.offsetWidth : 1;
  }

  function boxIn(element, frame) {
    const origin = frame.getBoundingClientRect();
    const rect = element.getBoundingClientRect();
    const k = scaleOf(frame);
    return {
      x: (rect.left - origin.left) / k,
      y: (rect.top - origin.top) / k,
      w: rect.width / k,
      h: rect.height / k
    };
  }

  function horizontal(a, b, gap, arrow) {
    const dir = b.x + b.w / 2 >= a.x + a.w / 2 ? 1 : -1;
    const sx = dir > 0 ? a.x + a.w + gap : a.x - gap;
    const ex = dir > 0 ? b.x - gap : b.x + b.w + gap;
    const sy = a.y + a.h / 2;
    const ey = b.y + b.h / 2;
    const mid = (ex - sx) / 2;
    const line = `M${round(sx)} ${round(sy)} C${round(sx + mid)} ${round(sy)} ${round(ex - mid)} ${round(ey)} ${round(ex)} ${round(ey)}`;
    if (!arrow) return line;
    return `${line} M${round(ex - ARROW * dir)} ${round(ey - ARROW * 0.75)} L${round(ex)} ${round(ey)} L${round(ex - ARROW * dir)} ${round(ey + ARROW * 0.75)}`;
  }

  function vertical(a, b, gap, arrow) {
    const dir = b.y + b.h / 2 >= a.y + a.h / 2 ? 1 : -1;
    const sy = dir > 0 ? a.y + a.h + gap : a.y - gap;
    const ey = dir > 0 ? b.y - gap : b.y + b.h + gap;
    const sx = a.x + a.w / 2;
    const ex = b.x + b.w / 2;
    const mid = (ey - sy) / 2;
    const line = `M${round(sx)} ${round(sy)} C${round(sx)} ${round(sy + mid)} ${round(ex)} ${round(ey - mid)} ${round(ex)} ${round(ey)}`;
    if (!arrow) return line;
    return `${line} M${round(ex - ARROW * 0.75)} ${round(ey - ARROW * dir)} L${round(ex)} ${round(ey)} L${round(ex + ARROW * 0.75)} ${round(ey - ARROW * dir)}`;
  }

  function updateLink(path, stage) {
    const from = stage.querySelector(path.dataset.from);
    const to = stage.querySelector(path.dataset.to);
    if (!from || !to) return;
    const a = boxIn(from, stage);
    const b = boxIn(to, stage);
    const gap = Number(path.dataset.gap) || 0;
    const build = path.dataset.side === "v" ? vertical : horizontal;
    const d = build(a, b, gap, path.hasAttribute("data-arrow"));
    if (path.getAttribute("d") === d) return;
    path.setAttribute("d", d);
    path.style.setProperty("--len", path.getTotalLength() + "px");
  }

  function updatePulse(pulse, stage) {
    const path = stage.querySelector(pulse.dataset.on);
    const d = path && path.getAttribute("d");
    if (d) pulse.style.offsetPath = `path("${d}")`;
  }

  function updateOrigin(element, stage) {
    const source = stage.querySelector(element.dataset.fromBox);
    if (!source) return;
    const box = boxIn(source, stage);
    element.style.setProperty("--from-x", box.x + "px");
    element.style.setProperty("--from-y", box.y + "px");
    element.style.setProperty("--from-w", box.w + "px");
    element.style.setProperty("--from-h", box.h + "px");
  }

  function updateStage(stage) {
    stage.querySelectorAll("path[data-from]").forEach(path => updateLink(path, stage));
    stage.querySelectorAll("[data-on]").forEach(pulse => updatePulse(pulse, stage));
    stage.querySelectorAll("[data-from-box]").forEach(element => updateOrigin(element, stage));
  }

  function updateAll() {
    document.querySelectorAll(".mo-stage").forEach(updateStage);
  }

  function tick() {
    document.querySelectorAll(".scene.is-active .mo-stage").forEach(updateStage);
    requestAnimationFrame(tick);
  }

  function later(element, delay, action) {
    clearTimeout(timers.get(element));
    if (reduced()) {
      action();
      return;
    }
    timers.set(element, setTimeout(action, delay));
  }

  function cancel(element) {
    clearTimeout(timers.get(element));
    timers.delete(element);
  }

  function latestShown(container, selector, except, extra) {
    const shown = Array.from(container.querySelectorAll(selector))
      .filter(element => element !== except && (element === extra || element.classList.contains("is-shown")));
    return shown.sort((a, b) => stepOf(a) - stepOf(b)).pop();
  }

  function aim(cam, target) {
    cam.querySelectorAll(".is-focus").forEach(element => element.classList.remove("is-focus"));
    if (!target) {
      ["--cam-x", "--cam-y", "--cam-s"].forEach(name => cam.style.removeProperty(name));
      return;
    }
    const box = boxIn(target, cam);
    const width = cam.offsetWidth;
    const height = cam.offsetHeight;
    const zoom = Number(target.dataset.zoom) || token("--mo-cam-zoom");
    const scale = Math.min(zoom, (width * 0.9) / box.w, (height * 0.9) / box.h);
    cam.style.setProperty("--cam-s", String(scale));
    cam.style.setProperty("--cam-x", width / 2 - (box.x + box.w / 2) * scale + "px");
    cam.style.setProperty("--cam-y", height / 2 - (box.y + box.h / 2) * scale + "px");
    target.classList.add("is-focus");
  }

  const focus = {
    play: element => {
      const cam = element.closest(".mo-cam");
      aim(cam, latestShown(cam, '[data-anim="focus"]', null, element));
    },
    reset: element => {
      const cam = element.closest(".mo-cam");
      aim(cam, latestShown(cam, '[data-anim="focus"]', element));
    }
  };

  function moveTouch(stage, target) {
    const touch = stage.querySelector(".mo-touch");
    if (!touch) return;
    if (!target) {
      touch.classList.remove("is-on");
      return;
    }
    const spot = target.querySelector(".checkbox__box") || target;
    const box = boxIn(spot, stage);
    touch.style.left = box.x + box.w / 2 + "px";
    touch.style.top = box.y + box.h / 2 + "px";
    touch.classList.add("is-on");
  }

  function press(stage) {
    const touch = stage.querySelector(".mo-touch");
    if (!touch || reduced()) return;
    touch.animate(
      [{ scale: "1" }, { scale: "0.7" }, { scale: "1" }],
      { duration: token("--motion-dur-base"), easing: "ease-in-out" }
    );
  }

  function setTapped(element, on) {
    const input = element.querySelector("input[type=checkbox]");
    if (input) input.checked = on;
    element.classList.toggle("is-tapped", on);
  }

  const tap = {
    play: element => {
      const stage = element.closest(".mo-stage");
      moveTouch(stage, latestShown(stage, '[data-anim="tap"]', null, element));
      later(element, token("--motion-dur-slow"), () => {
        press(stage);
        setTapped(element, true);
      });
    },
    reset: element => {
      const stage = element.closest(".mo-stage");
      cancel(element);
      setTapped(element, false);
      moveTouch(stage, latestShown(stage, '[data-anim="tap"]', element));
    }
  };

  root.DeckEffects.register("focus", focus);
  root.DeckEffects.register("tap", tap);
  updateAll();
  if (document.fonts) document.fonts.ready.then(updateAll);
  root.addEventListener("resize", updateAll);
  requestAnimationFrame(tick);
})(window);
