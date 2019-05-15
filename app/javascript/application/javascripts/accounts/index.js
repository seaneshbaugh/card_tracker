const completed = () => {
  const enterUsernameInput = document.querySelector(".enter-username");
  const enterUsernameConfirmationInput = document.querySelector(".enter-username-confirmation");
  const usernameInput = document.querySelector(".username");
  const submitButton = document.querySelector(".requires-enter-username input[type=submit]");

  if (!enterUsernameInput || !enterUsernameConfirmationInput || !usernameInput || !submitButton) {
    return;
  }

  const username = usernameInput.value;

  [enterUsernameInput, enterUsernameConfirmationInput].forEach((input) => {
    input.addEventListener("keyup", (_event) => {
      const enterUsername = enterUsernameInput.value;
      const enterUsernameConfirmation = enterUsernameConfirmationInput.value;

      submitButton.disabled = enterUsername !== username || enterUsernameConfirmation !== username;
    }, false);
  });

  submitButton.addEventListener("submit", (event) => {
    const enterUsername = enterUsernameInput.value;
    const enterUsernameConfirmation = enterUsernameConfirmationInput.value;

    if (enterUsername !== username || enterUsernameConfirmation !== username) {
      event.preventDefault();
    }
  }, false);
};

if (document.readyState === "complete") {
  setTimeout(completed);
} else {
  document.addEventListener("DOMContentLoaded", completed, false);
}
