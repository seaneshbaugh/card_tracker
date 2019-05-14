const handleResponseError = (response) => {
  if (response.ok || response.status === 422) {
    return response;
  }

  throw Error(response.statusText);
};

const incrementQuantity = (currentQuantity) => {
  return currentQuantity + 1;
};

const decrementQuantity = (currentQuantity) => {
  if (currentQuantity <= 0) {
    return 0;
  }

  return currentQuantity - 1;
};

const changeQuantity = (event, getNewQuantity, successCallback, errorCallback) => {
  event.preventDefault();

  const card = event.target.closest(".card");

  const currentQuantity = parseInt(card.dataset.quantity);

  if (isNaN(currentQuantity)) {
    console.error("Quantity is non-numeric.");

    return;
  }

  const newQuantity = getNewQuantity(currentQuantity);

  const params = {
    "card_list_id": card.dataset.cardListId,
    "card_id": card.dataset.cardId,
    "quantity": newQuantity
  };

  params[document.querySelector("meta[name='csrf-param']").content] = document.querySelector("meta[name='csrf-token']").content;

  window.fetch("/collection/quantity", {
    "method": "PUT",
    "headers": {
      "Accept": "application/json",
      "Content-Type": "application/json"
    },
    "body": JSON.stringify(params)
  }).then(handleResponseError).then((response) => {
    return response.json();
  }).then((json) => {
    if (json["errors"]) {
      json["errors"].forEach((error) => {
        console.error(error);
      });

      return;
    }

    card.dataset.quantity = json["new_quantity"];
    card.querySelector(".card-quantity").innerText = json["new_quantity"];

    if (successCallback) {
      successCallback(event);
    }
  }).catch((error) => {
    console.error(error);

    if (errorCallback) {
      errorCallback(event);
    }
  });
};

const insertQuantityInput = (event) => {
  event.preventDefault();

  if (event.target.querySelector("input[type='number']")) {
    return;
  }

  if (window.getSelection) {
    window.getSelection().removeAllRanges();
  } else {
    if (document.selection && document.selection.empty) {
      document.selection.empty();
    }
  }

  const card = event.target.closest(".card");

  const currentQuantity = parseInt(card.dataset.quantity);

  if (isNaN(currentQuantity)) {
    console.error("Quantity is non-numeric.");

    return;
  }

  const buttons = card.querySelectorAll("button.increment, button.decrement");

  buttons.forEach((button) => {
    button.disabled = true;
  });

  const input = document.createElement("input");

  input.type = "number";
  input.min = 0;
  input.step = 1;
  input.value = currentQuantity;

  input.addEventListener("keyup", (keyupEvent) => {
    switch (keyupEvent.keyCode) {
    case 13:
      input.blur();

      break;
    case 27:
      input.value = currentQuantity;

      input.blur();

      break;
    }
  });

  event.target.innerHTML = "";
  event.target.append(input);

  input.focus();

  input.addEventListener("blur", (blurEvent) => {
    input.disabled = true;

    const newQuantity = parseInt(input.value);

    if (isNaN(newQuantity)) {
      input.disabled = false;

      console.error("Quantity is non-numeric.");

      return;
    }

    const reset = () => {
      buttons.forEach((button) => {
        button.disabled = false;
      });

      event.target.innerText = newQuantity;
    };

    if (newQuantity === currentQuantity) {
      reset();

      return;
    }

    changeQuantity(blurEvent, () => input.value, reset, reset);
  });
};

const completed = () => {
  const incrementButtons = document.querySelectorAll("button.increment");

  incrementButtons.forEach((incrementButton) => {
    incrementButton.addEventListener("click", (event) => {
      changeQuantity(event, incrementQuantity);
    }, false);
  });

  const decrementButtons = document.querySelectorAll("button.decrement");

  decrementButtons.forEach((decrementButton) => {
    decrementButton.addEventListener("click", (event) => {
      changeQuantity(event, decrementQuantity);
    }, false);
  });

  const quantityContainers = document.querySelectorAll(".card-quantity");

  quantityContainers.forEach((quantityContainer) => {
    quantityContainer.addEventListener("dblclick", (event) => {
      insertQuantityInput(event);
    }, false);
  });
};

if (document.readyState === "complete") {
  setTimeout(completed);
} else {
  document.addEventListener("DOMContentLoaded", completed, false);
}
