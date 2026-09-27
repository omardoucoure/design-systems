(function () {
  function wrapWords(element) {
    const words = element.textContent.match(/\S+\s*/g) || [];
    element.textContent = "";
    words.forEach((word, index) => {
      const span = document.createElement("span");
      span.className = "tx-word";
      span.style.setProperty("--i", String(index));
      span.textContent = word;
      element.appendChild(span);
    });
  }

  document.querySelectorAll(".tx-select--words").forEach(wrapWords);
})();
