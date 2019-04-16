import "materialize-css/dist/js/materialize.js";
import "./flash_messages";

const completed = () => {
  M.AutoInit();

  const dropdowns = document.querySelectorAll(".dropdown-trigger");

  M.Dropdown.init(dropdowns, { alignment: "right", constrainWidth: false, coverTrigger: false });
};

if (document.readyState === "complete") {
  setTimeout(completed);
} else {
  document.addEventListener("DOMContentLoaded", completed, false);
}
