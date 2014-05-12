//= require jquery
//= require jquery.ui.all
//= require jquery_ujs
//= require twitter/bootstrap
//= require vendor_assets
//= require shared
//= require_self

$(function() {
    var ErrorMessages;

    ErrorMessages = {
        title: "An error has occurred.",
        invalidServerResponse: "The server returned an invalid response, but your request may have been successful. Please reload the page and try again if necessary (clearing your browser's cache might help). If you continue to see this error message please contact help@cavesofkoilos.com with your username, what you were trying to do, and when.",
        nonNumericCardQuantity: "Somehow this card's quantity was recorded as a non-numeric value. Please reload the page and try again (clearing your browser's cache might help). If you continue to see this error message please contact help@cavesofkoilos.com with your username and the set and card that is producing the error."
    };

    $.fn.error = function(title, message) {
        return this.each(function() {
            $(this).popover({
                placement: "top",
                trigger: "hover",
                title: title,
                content: message
            }).popover("show");
        });
    };

    $("[rel*=tooltip]").tooltip({placement: "top"});

    $("body").on("click", ".card .increment", function(event) {
        var increment, card, quantity;

        event.preventDefault();

        increment = $(this);

        card = increment.closest(".card");

        quantity = parseInt(card.data("quantity")) + 1;

        if (isNaN(quantity)) {
            increment.error(ErrorMessages.title, ErrorMessages.nonNumericCardQuantity);
        } else {
            $.post("/collection/quantity", "_method=put&card_list_id=" + card.data("card-list-id") + "&card_id=" + card.data("card-id") + "&quantity=" + quantity, function(data, status, jqXHR) {
                var results;

                try {
                    results = $.parseJSON(jqXHR.responseText);

                    if (jqXHR.status === 200) {
                        card.data("quantity", results["new_quantity"]);

                        card.find(".card-quantity").text(results["new_quantity"]);
                    } else {
                        increment.error(results["status_message"], results["errors"]);
                    }
                } catch(exception) {
                    increment.error(ErrorMessages.title, ErrorMessages.invalidServerResponse);
                }
            }, "json");
        }
    });

    $("body").on("click", ".card .decrement", function(event) {
        var decrement, card, quantity;

        event.preventDefault();

        decrement = $(this);

        card = decrement.closest(".card");

        quantity = parseInt(card.data("quantity")) - 1;

        if (isNaN(quantity)) {
            decrement.error(ErrorMessages.title, ErrorMessages.nonNumericCardQuantity);
        } else {
            if (quantity < 0) {
                quantity = 0;
            }

            $.post("/collection/quantity", "_method=put&card_list_id=" + card.data("card-list-id") + "&card_id=" + card.data("card-id") + "&quantity=" + quantity, function(data, status, jqXHR) {
                var results;

                try {
                    results = $.parseJSON(jqXHR.responseText);

                    if (jqXHR.status === 200) {
                        card.data("quantity", results["new_quantity"]);

                        card.find(".card-quantity").text(results["new_quantity"]);
                    } else {
                        decrement.error(results["status_message"], results["errors"]);
                    }
                } catch(exception) {
                    decrement.error(ErrorMessages.title, ErrorMessages.invalidServerResponse);
                }
            }, "json");
        }
    });

    $("body").on("dblclick", ".card .card-quantity", function(event) {
        var quantityContainer, card, input, initialQuantity;

        event.preventDefault();

        quantityContainer = $(this);

        if (quantityContainer.find("input[type='number']").length === 0) {
            if (window.getSelection) {
                window.getSelection().removeAllRanges();
            } else {
                if (document.selection && document.selection.empty) {
                    document.selection.empty();
                }
            }

            card = quantityContainer.parent();

            card.find(".increment, .decrement").attr("disabled", true);

            input = $(document.createElement("input"));

            input.attr("type", "number");

            input.attr("min", 0);

            input.attr("step", 1);

            initialQuantity = card.data("quantity");

            input.data("initial-quantity", initialQuantity);

            input.val(initialQuantity);

            input.addClass("form-control");

            quantityContainer.empty();

            quantityContainer.append(input);

            input.numeric("positiveInteger");

            input.focus();

            input.select();
        }
    });

    $("body").on("keyup", ".card .card-quantity input[type='number']", function(event) {
        var input;

        input = $(this);

        switch (event.keyCode) {
            case 13:
                input.blur();

                break;
            case 27:
                input.val(input.data("initial-quantity"));

                input.blur();

                break;
        }
    });

    $("body").on("blur", ".card .card-quantity input[type='number']", function(event) {
        var input, quantityContainer, card, initialQuantity, quantity;

        input = $(this);

        quantityContainer = input.parent();

        card = quantityContainer.closest(".card");

        initialQuantity = parseInt(input.data("initial-quantity"));

        if (isNaN(initialQuantity) || initialQuantity < 0) {
            initialQuantity = 0;
        }

        quantity = parseInt(input.val());

        if (!isNaN(quantity)) {
            if (initialQuantity !== quantity) {
                input.attr("disabled", true);

                if (quantity < 0) {
                    quantity = 0;
                }

                $.post("/collection/quantity", "_method=put&card_list_id=" + card.data("card-list-id") + "&card_id=" + card.data("card-id") + "&quantity=" + quantity, function(data, status, jqXHR) {
                    var results;

                    try {
                        results = $.parseJSON(jqXHR.responseText);

                        if (jqXHR.status === 200) {
                            card.data("quantity", results["new_quantity"]);

                            quantityContainer.empty();

                            quantityContainer.text(results["new_quantity"]);

                            card.find(".increment, .decrement").removeAttr("disabled");
                        } else {
                            input.removeAttr("disabled");

                            input.error(results["status_message"], results["errors"]);
                        }
                    } catch(exception) {
                        input.removeAttr("disabled");

                        input.error(ErrorMessages.title, ErrorMessages.invalidServerResponse);
                    }
                }, "json");
            } else {
                quantityContainer.empty();

                quantityContainer.text(initialQuantity);

                card.find(".increment, .decrement").removeAttr("disabled");
            }
        }
    });

    $("body").on("keyup", "#confirm_delete_account #enter_username, #confirm_delete_account #enter_username_confirmation", function() {
        var username, enterUsername, enterUsernameConfirmation;

        username = $("#confirm_delete_account #username").val();

        enterUsername = $("#confirm_delete_account #enter_username").val();

        enterUsernameConfirmation = $("#confirm_delete_account #enter_username_confirmation").val();

        if (enterUsername === username && enterUsernameConfirmation === username) {
            $("#confirm_delete_account input[type='submit']").attr("disabled", false);
        } else {
            $("#confirm_delete_account input[type='submit']").attr("disabled", true);
        }
    });

    $("body").on("submit", "#confirm_delete_account", function(event) {
        var username, enterUsername, enterUsernameConfirmation;

        username = $("#confirm_delete_account #username").val();

        enterUsername = $("#confirm_delete_account #enter_username").val();

        enterUsernameConfirmation = $("#confirm_delete_account #enter_username_confirmation").val();

        if (enterUsername !== username && enterUsernameConfirmation !== username) {
            event.preventDefault();
        }
    });

    $("body").on("click", ".toggle-move-collection-modal", function (event) {
        var modalToggle, card;

        modalToggle = $(this);

        card = modalToggle.closest(".card");

        if (parseInt(card.data("quantity"))  > 0) {
            $("#move-collection-quantity").val(card.data("quantity"));

            $("#move-collection-quantity").attr("max", card.data("quantity"));

            $("#move-collection-quantity").numeric({
                allowPlus    : false,
                allowMinus   : false,
                allowThouSep : false,
                allowDecSep  : false,
                min          : 0,
                max          : card.data("quantity")
            });

            $("#move-collection-modal-maximum-quantity").text(card.data("quantity"));

            $("#move-collection-card-id").val(card.data("card-id"));
        } else {
            event.preventDefault();
        }
    });

    $("body").on("submit", "#move-collection-form", function(event) {
        var card;

        event.preventDefault();

        card = $("#card-" + $("#move-collection-card-id").val());

        $.post("/collection/card_list", $(this).serialize(), function(data, status, jqXHR) {
            var results;

            try {
                results = $.parseJSON(jqXHR.responseText);

                if (jqXHR.status === 200) {
                    card.data("quantity", results["new_quantity"]);

                    card.find(".card-quantity").text(results["new_quantity"]);
                } else {
                    card.error(results["status_message"], results["errors"]);
                }
            } catch(exception) {
                card.error(ErrorMessages.title, ErrorMessages.invalidServerResponse);
            }

            $("#move-collection-modal").modal("hide");
        }, "json");
    });

    $("body").on("click", ".remove-all-from-list", function(event) {
        var options, card, quantity;

        event.preventDefault();

        options = $(this).closest(".options");

        card = $(this).closest(".card");

        quantity = parseInt(card.data("quantity"));

        if (quantity !== 0) {
            $.post("/collection/quantity", "_method=put&card_list_id=" + card.data("card-list-id") + "&card_id=" + card.data("card-id") + "&quantity=0", function(data, status, jqXHR) {
                var results;

                try {
                    results = $.parseJSON(jqXHR.responseText);

                    if (jqXHR.status === 200) {
                        card.data("quantity", results["new_quantity"]);

                        card.find(".card-quantity").text(results["new_quantity"]);
                    } else {
                        options.error(results["status_message"], results["errors"]);
                    }
                } catch(exception) {
                    options.error(ErrorMessages.title, ErrorMessages.invalidServerResponse);
                }
            }, "json");
        }
    });

    $("#card-lists").sortable({
        //handle: ".card-list-name",
        update: function() {
            var cardListOrder = {};

            $(".card-list", $(this)).each(function(index, element) {
                cardListOrder[$(element).data("card-list-id")] = index;
            });

            $.post("/lists/order", "_method=put&card_list_order=" + JSON.stringify(cardListOrder), function(data, status, jqXHR) {
                var results;

                try {
                    results = $.parseJSON(jqXHR.responseText);

                    if (jqXHR.status !== 200) {
                        $("#card-lists").error(results["status_message"], results["errors"]);
                    }
                } catch(exception) {
                    $("#card-lists").error(ErrorMessages.title, ErrorMessages.invalidServerResponse);
                }
            }, "json");
        }
    });
});
