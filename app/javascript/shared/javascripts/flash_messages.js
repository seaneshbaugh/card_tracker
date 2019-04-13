const completed = () => {
  Array.from(document.querySelectorAll(".flash-message")).forEach((flashMessage, index) => {
    flashMessage.addEventListener("click", (event) => {
      flashMessage.classList.add("animated", "fadeOut");
    });

    flashMessage.addEventListener("animationend", (event) => {
      flashMessage.remove();
    });
  });
};

if (document.readyState === "complete") {
  setTimeout(completed);
} else {
  document.addEventListener("DOMContentLoaded", completed, false);
}
