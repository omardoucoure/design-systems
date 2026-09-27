(function (root) {
  const timers = new WeakMap();
  const reduced = () => root.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const token = name => parseFloat(getComputedStyle(document.documentElement).getPropertyValue(name));
  const stepOf = element => Number(element.dataset.step) || 0;

  function inputOf(row) {
    const win = row.closest(".cc-window");
    return win && win.querySelector(".cc-input__text");
  }

  function stop(row) {
    clearInterval(timers.get(row));
    clearTimeout(timers.get(row));
    timers.delete(row);
  }

  function isOvertaken(row) {
    const win = row.closest(".cc-window");
    return Array.from(win.querySelectorAll("[data-step].is-shown")).some(element => stepOf(element) > stepOf(row));
  }

  function send(row, input) {
    input.textContent = "";
    row.classList.add("is-sent");
  }

  function typeInto(row, input) {
    const text = row.textContent.trim();
    let index = 0;
    const id = setInterval(() => {
      index += 1;
      input.textContent = text.slice(0, index);
      if (index < text.length) return;
      clearInterval(id);
      timers.set(row, setTimeout(() => send(row, input), token("--cc-send-pause")));
    }, token("--cc-type-char"));
    timers.set(row, id);
  }

  const prompt = {
    play: row => {
      const input = inputOf(row);
      if (!input) return;
      stop(row);
      requestAnimationFrame(() => {
        if (!row.classList.contains("is-shown")) return;
        if (reduced() || isOvertaken(row)) send(row, input);
        else typeInto(row, input);
      });
    },
    reset: row => {
      stop(row);
      row.classList.remove("is-sent");
      const input = inputOf(row);
      if (input) input.textContent = "";
    }
  };

  root.DeckEffects.register("cc-prompt", prompt);
})(window);
