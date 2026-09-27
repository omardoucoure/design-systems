(function (root) {
  const stepOf = element => Number(element.dataset.step) || 0;
  const delayOf = element => Number(element.dataset.delay) || 0;
  const maxOf = meter => Number(meter.dataset.max) || 100;
  const baseOf = meter => Number(meter.dataset.base) || 0;

  function settersOf(meter) {
    return Array.from(meter.querySelectorAll('[data-anim="pg"]')).filter(setter => setter.closest(".pg-meter") === meter);
  }

  function latestSetter(meter, except, extra) {
    const shown = settersOf(meter)
      .filter(setter => setter !== except && (setter === extra || setter.classList.contains("is-shown")));
    return shown.sort((a, b) => stepOf(a) - stepOf(b) || delayOf(a) - delayOf(b)).pop();
  }

  function apply(meter, setter) {
    const value = setter ? Number(setter.dataset.value) : baseOf(meter);
    if (setter && setter.dataset.dur) meter.style.setProperty("--pg-dur", setter.dataset.dur + "ms");
    else meter.style.removeProperty("--pg-dur");
    if (setter && setter.dataset.ease) meter.style.setProperty("--pg-ease", setter.dataset.ease);
    else meter.style.removeProperty("--pg-ease");
    meter.style.setProperty("--pg-v", String(value / maxOf(meter)));
  }

  function init(meter) {
    meter.style.setProperty("--pg-max", String(maxOf(meter)));
    meter.style.transition = "none";
    apply(meter, null);
    requestAnimationFrame(() => requestAnimationFrame(() => meter.style.removeProperty("transition")));
  }

  const meterPlayer = {
    play: setter => {
      const meter = setter.closest(".pg-meter");
      if (meter) apply(meter, latestSetter(meter, null, setter));
    },
    reset: setter => {
      const meter = setter.closest(".pg-meter");
      if (meter) apply(meter, latestSetter(meter, setter));
    }
  };

  document.querySelectorAll(".pg-meter").forEach(init);
  root.DeckEffects.register("pg", meterPlayer);
})(window);
