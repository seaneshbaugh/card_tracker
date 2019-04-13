const completed = () => {
  const acceptTermsOfServiceCheckBox = document.querySelector(".accept-terms-of-service");

  if (acceptTermsOfServiceCheckBox) {
    const submitButton = document.querySelector(".requires-terms-of-service-acceptance input[type=submit]");

    if (submitButton) {
      acceptTermsOfServiceCheckBox.addEventListener("change", (event) => {
        submitButton.disabled = !acceptTermsOfServiceCheckBox.checked;
      }, false);
    }
  }
};

if (document.readyState === "complete") {
  setTimeout(completed);
} else {
  document.addEventListener("DOMContentLoaded", completed, false);
}
