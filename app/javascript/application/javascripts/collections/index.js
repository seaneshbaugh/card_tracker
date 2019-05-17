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

const setupIncrementButtons = () => {
  const incrementButtons = document.querySelectorAll("button.increment");

  incrementButtons.forEach((incrementButton) => {
    incrementButton.addEventListener("click", (event) => {
      changeQuantity(event, incrementQuantity);
    }, false);
  });
};

const setupDecrementButtons = () => {
  const decrementButtons = document.querySelectorAll("button.decrement");

  decrementButtons.forEach((decrementButton) => {
    decrementButton.addEventListener("click", (event) => {
      changeQuantity(event, decrementQuantity);
    }, false);
  });
};

const setupQuantityInputs = () => {
  const quantityContainers = document.querySelectorAll(".card-quantity");

  quantityContainers.forEach((quantityContainer) => {
    quantityContainer.addEventListener("dblclick", (event) => {
      insertQuantityInput(event);
    }, false);
  });
};

const setupMoveCollectionModal = () => {
  const moveCollectionModal = document.querySelector(".move-collection-modal");

  if (!moveCollectionModal) {
    return;
  }

  const moveCollectionModalTriggers = document.querySelectorAll(".move-collection-modal-trigger");

  moveCollectionModalTriggers.forEach((moveCollectionModalTrigger) => {
    moveCollectionModalTrigger.addEventListener("click", (event) => {
      event.preventDefault();

      const modal = M.Modal.init(moveCollectionModal);

      const card = event.target.closest(".card");

      const currentQuantity = parseInt(card.dataset.quantity);

      if (isNaN(currentQuantity)) {
        console.error("Quantity is non-numeric.");

        return;
      }

      let form = moveCollectionModal.querySelector("form");

      form.outerHTML = form.outerHTML;

      form = moveCollectionModal.querySelector("form");

      const quantityInput = form.querySelector("input[type='number'][name='quantity']");

      quantityInput.max = currentQuantity;

      form.querySelector("input[type='submit']").disabled = false;

      form.addEventListener("submit", (submitEvent) => {
        submitEvent.preventDefault();

        const quantityToMove = parseInt(quantityInput.value);

        if (isNaN(quantityToMove)) {
          console.error("Quantity to move is non-numeric.");

          return;
        }

        if (quantityToMove <= 0 || quantityToMove > currentQuantity) {
          form.querySelector("input[type='submit']").disabled = false;

          return;
        }

        const newCardListInput = form.querySelector("input[type='radio'][name='new_card_list_id']:checked");

        if (!newCardListInput) {
          return;
        }

        const params = {
          "card_list_id": card.dataset.cardListId,
          "new_card_list_id": newCardListInput.value,
          "card_id": card.dataset.cardId,
          "quantity": quantityInput.value
        };

        params[document.querySelector("meta[name='csrf-param']").content] = document.querySelector("meta[name='csrf-token']").content;

        window.fetch(form.action, {
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

          modal.close();
        }).catch((error) => {
          console.error(error);
        });
      });

      modal.open();
    });
  });
};

const completed = () => {
  setupIncrementButtons();
  setupDecrementButtons();
  setupQuantityInputs();
  setupMoveCollectionModal();
};

if (document.readyState === "complete") {
  setTimeout(completed);
} else {
  document.addEventListener("DOMContentLoaded", completed, false);
}
