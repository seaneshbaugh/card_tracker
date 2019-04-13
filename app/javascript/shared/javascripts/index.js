import "materialize-css/dist/js/materialize.js";
import "./flash_messages";

const completed = () => (M.AutoInit());

if (document.readyState === "complete") {
  setTimeout(completed);
} else {
  document.addEventListener("DOMContentLoaded", completed, false);
}
