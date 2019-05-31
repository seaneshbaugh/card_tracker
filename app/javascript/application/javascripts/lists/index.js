import Sortable from "sortablejs/Sortable";

const handleResponseError = (response) => {
  if (response.ok || response.status === 422) {
    return response;
  }

  throw Error(response.statusText);
};

const onSortHandler = (event) => {
  const cardLists = event.target.querySelectorAll(".card-list");
  const cardListsOrder = {};

  cardLists.forEach((cardList, index) => {
    cardListsOrder[cardList.dataset.cardListId] = index;
  });

  const params = {
    "card_lists_order": cardListsOrder
  };

  params[document.querySelector("meta[name='csrf-param']").content] = document.querySelector("meta[name='csrf-token']").content;

  window.fetch("lists/order", {
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
  });
};

const completed = () => {
  const cardLists = document.querySelector(".page-body .card-lists");

  if (cardLists) {
    const sortable = Sortable.create(cardLists, {
      draggable: ".card-list",
      onSort: onSortHandler
    });
  }
};

if (document.readyState === "complete") {
  setTimeout(completed);
} else {
  document.addEventListener("DOMContentLoaded", completed, false);
}
