(function (root) {
  const timers = new WeakMap();
  const frames = new WeakMap();
  const hits = new WeakMap();
  const SLACK = 4;
  const reduced = () => root.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const round = value => Math.round(value * 10) / 10;
  const stepOf = element => Number(element.dataset.step) || 0;

  function boxIn(element, stage) {
    const origin = stage.getBoundingClientRect();
    const rect = element.getBoundingClientRect();
    const k = stage.offsetWidth ? origin.width / stage.offsetWidth : 1;
    return { x: (rect.left - origin.left) / k, y: (rect.top - origin.top) / k, w: rect.width / k, h: rect.height / k };
  }

  function ring(box) {
    const r = round(box.w / 2);
    const cx = round(box.x + box.w / 2);
    const top = round(box.y + box.h / 2 - box.w / 2);
    const bottom = round(top + 2 * r);
    return `M${cx} ${top} A${r} ${r} 0 0 1 ${cx} ${bottom} A${r} ${r} 0 0 1 ${cx} ${top}`;
  }

  function arc(a, b, lift) {
    const ax = round(a.x + a.w / 2);
    const ay = round(a.y + a.h / 2);
    const bx = round(b.x + b.w / 2);
    const by = round(b.y + b.h / 2);
    return `M${ax} ${ay} C${ax} ${round(ay - lift)} ${bx} ${round(by - lift)} ${bx} ${by}`;
  }

  function span(box) {
    const y = round(box.y + box.h / 2);
    return `M${round(box.x)} ${y} L${round(box.x + box.w)} ${y}`;
  }

  function buildPath(path, stage) {
    const of = stage.querySelector(path.dataset.wrOf);
    if (!of) return null;
    const kind = path.dataset.wrPath;
    if (kind === "ring") return ring(boxIn(of, stage));
    if (kind === "span") return span(boxIn(of, stage));
    const to = stage.querySelector(path.dataset.wrTo);
    if (kind === "arc" && to) return arc(boxIn(of, stage), boxIn(to, stage), Number(path.dataset.wrLift) || 80);
    return null;
  }

  function updatePath(path, stage) {
    const d = buildPath(path, stage);
    if (!d || path.getAttribute("d") === d) return;
    path.setAttribute("d", d);
    path.style.setProperty("--len", path.getTotalLength() + "px");
  }

  function centerOf(element, stage) {
    const box = boxIn(element, stage);
    return { x: box.x + box.w / 2, y: box.y + box.h / 2 };
  }

  function inside(point, box) {
    return point.x >= box.x - SLACK && point.x <= box.x + box.w + SLACK && point.y >= box.y - SLACK && point.y <= box.y + box.h + SLACK;
  }

  function visible(element) {
    return Number(getComputedStyle(element).opacity) > 0.3;
  }

  function atStart(element) {
    return parseFloat(getComputedStyle(element).offsetDistance) < 0.5;
  }

  function lightFrom(rider, stage, lit) {
    const point = centerOf(rider, stage);
    const seen = visible(rider);
    if (rider.dataset.wrFlash && seen) {
      stage.querySelectorAll(rider.dataset.wrFlash).forEach(element => {
        if (inside(point, boxIn(element, stage))) lit.add(element);
      });
    }
    if (rider.dataset.wrHit) {
      const active = reduced() ? !atStart(rider) : seen;
      const kept = atStart(rider) ? new Set() : hits.get(rider) || new Set();
      if (active) {
        stage.querySelectorAll(rider.dataset.wrHit).forEach(element => {
          if (inside(point, boxIn(element, stage))) kept.add(element);
        });
      }
      hits.set(rider, kept);
      kept.forEach(element => lit.add(element));
    }
    if (rider.dataset.wrFill) {
      stage.querySelectorAll(rider.dataset.wrFill).forEach(element => {
        if (point.x >= centerOf(element, stage).x) lit.add(element);
      });
    }
  }

  function updateLights(stage) {
    const riders = stage.querySelectorAll("[data-wr-flash], [data-wr-hit], [data-wr-fill]");
    if (!riders.length) return;
    const lit = new Set();
    riders.forEach(rider => lightFrom(rider, stage, lit));
    const targets = new Set();
    riders.forEach(rider => {
      [rider.dataset.wrFlash, rider.dataset.wrHit, rider.dataset.wrFill].filter(Boolean).forEach(selector => {
        stage.querySelectorAll(selector).forEach(element => targets.add(element));
      });
    });
    targets.forEach(element => element.classList.toggle("is-lit", lit.has(element)));
  }

  function updateStage(stage) {
    stage.querySelectorAll("path[data-wr-path]").forEach(path => updatePath(path, stage));
    updateLights(stage);
  }

  function updateAll() {
    document.querySelectorAll(".mo-stage").forEach(stage => {
      stage.querySelectorAll("path[data-wr-path]").forEach(path => updatePath(path, stage));
    });
  }

  function tick() {
    document.querySelectorAll(".scene.is-active .mo-stage").forEach(updateStage);
    requestAnimationFrame(tick);
  }

  function later(element, delay, action) {
    clearTimeout(timers.get(element));
    if (reduced() || delay <= 0) {
      action();
      return;
    }
    timers.set(element, setTimeout(action, delay));
  }

  function cancel(element) {
    clearTimeout(timers.get(element));
    cancelAnimationFrame(frames.get(element));
    timers.delete(element);
    frames.delete(element);
  }

  function latestBeat(stage, selector, except, extra) {
    const shown = Array.from(stage.querySelectorAll(selector))
      .filter(element => element !== except && (element === extra || element.classList.contains("is-shown")));
    return shown.sort((a, b) => stepOf(a) - stepOf(b)).pop();
  }

  function layoutBox(element, stage) {
    let x = 0;
    let y = 0;
    let node = element;
    while (node && node !== stage) {
      x += node.offsetLeft;
      y += node.offsetTop;
      node = node.offsetParent;
    }
    return { x, y, w: element.offsetWidth, h: element.offsetHeight };
  }

  function applyMove(target, beat, stage) {
    if (!target) return;
    const dest = beat && stage.querySelector(beat.dataset.wrTo);
    if (!dest) {
      target.style.removeProperty("--wr-dx");
      target.style.removeProperty("--wr-dy");
      return;
    }
    const own = layoutBox(target, stage);
    const goal = boxIn(dest, stage);
    const dx = round(goal.x + goal.w / 2 - (own.x + own.w / 2));
    const dy = round(goal.y + goal.h / 2 - (own.y + own.h / 2));
    target.style.setProperty("--wr-dx", dx + "px");
    target.style.setProperty("--wr-dy", dy + "px");
  }

  function moveFor(element, extra, except) {
    const stage = element.closest(".mo-stage");
    const selector = `[data-anim="wr-move"][data-wr-move="${element.dataset.wrMove}"]`;
    applyMove(stage.querySelector(element.dataset.wrMove), latestBeat(stage, selector, except, extra), stage);
  }

  const move = {
    play: element => moveFor(element, element, null),
    reset: element => moveFor(element, null, element)
  };

  function atFor(element, extra, except) {
    const stage = element.closest(".mo-stage");
    const target = element.dataset.wrOf ? stage.querySelector(element.dataset.wrOf) : stage;
    const selector = element.dataset.wrOf ? `[data-anim="wr-at"][data-wr-of="${element.dataset.wrOf}"]` : `[data-anim="wr-at"]:not([data-wr-of])`;
    const beat = latestBeat(stage, selector, except, extra);
    if (beat) target.style.setProperty("--wr-at", beat.dataset.wrAt + "%");
    else target.style.removeProperty("--wr-at");
  }

  const at = {
    play: element => atFor(element, element, null),
    reset: element => atFor(element, null, element)
  };

  function loopOf(rider) {
    return rider && rider.getAnimations().find(animation => animation.animationName);
  }

  function waitFor(rider, fraction) {
    const animation = loopOf(rider);
    if (!animation) return 0;
    const duration = animation.effect.getComputedTiming().duration;
    const now = (animation.currentTime || 0) % duration;
    return (fraction * duration - now + duration) % duration;
  }

  const sync = {
    play: element => {
      const stage = element.closest(".mo-stage");
      const rider = stage.querySelector(element.dataset.wrRider);
      const go = () => element.classList.add("is-go");
      if (reduced()) {
        go();
        return;
      }
      frames.set(element, requestAnimationFrame(() => later(element, waitFor(rider, Number(element.dataset.wrAt) || 0), go)));
    },
    reset: element => {
      cancel(element);
      element.classList.remove("is-go");
    }
  };

  function showTrip(element, trip, done) {
    const stage = element.closest(".mo-stage");
    const counter = stage.querySelector(element.dataset.wrCounter);
    if (counter) counter.textContent = String(trip);
    stage.querySelectorAll(element.dataset.wrSegs).forEach((segment, index) => segment.classList.toggle("is-on", index < done));
  }

  const repeat = {
    play: element => {
      const stage = element.closest(".mo-stage");
      const rider = stage.querySelector(element.dataset.wrRider);
      const count = Number(element.dataset.wrCount) || 1;
      stage.style.setProperty("--wr-trips", String(count));
      if (reduced() || !rider) {
        showTrip(element, count, count);
        return;
      }
      const arrive = Number(element.dataset.wrArrive) || 0.88;
      const frame = () => {
        const animation = loopOf(rider);
        if (!animation) {
          frames.set(element, requestAnimationFrame(frame));
          return;
        }
        const duration = animation.effect.getComputedTiming().duration;
        const time = animation.currentTime || 0;
        const trip = Math.min(count, Math.floor(time / duration) + 1);
        const done = Math.min(count, Math.floor(time / duration + 1 - arrive));
        showTrip(element, trip, done);
        if (done < count) frames.set(element, requestAnimationFrame(frame));
      };
      frames.set(element, requestAnimationFrame(frame));
    },
    reset: element => {
      cancel(element);
      showTrip(element, 1, 0);
    }
  };

  root.DeckEffects.register("wr-move", move);
  root.DeckEffects.register("wr-at", at);
  root.DeckEffects.register("wr-sync", sync);
  root.DeckEffects.register("wr-repeat", repeat);
  updateAll();
  if (document.fonts) document.fonts.ready.then(updateAll);
  root.addEventListener("resize", updateAll);
  requestAnimationFrame(tick);
})(window);
