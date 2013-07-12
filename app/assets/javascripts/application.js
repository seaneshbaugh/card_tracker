//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require twitter/bootstrap
//= require vendor_assets
//= require shared
//= require_self

$.fn.fadingLinks = function(color, duration) {
    if (duration == null) {
        duration = 500;
    }

    return this.each(function() {
        var link, originalColor;

        link = $(this);

        originalColor = link.css("color");

        link.mouseover(function() {
            return link.stop().animate({
                color: color
            }, duration);
        });

        return link.mouseout(function() {
            return link.stop().animate({
                color: originalColor
            }, duration);
        });
    });
};

$(function() {
    $("#account_password").val("");

    $("#account_password_confirmation").val("");

    $("body").on("click", ".card .increment", function(event) {
        var increment, cardId, quantity;

        event.preventDefault();

        increment = $(this);

        cardId = increment.parent().parent().data("card-id");

        quantity = parseInt(increment.parent().parent().data("quantity")) + 1;

        $.post("/collection", "_method=put&card_id=" + cardId + "&quantity=" + quantity, function(data, status, jqXHR) {
            var results;

            if (jqXHR.status === 200) {
                results = $.parseJSON(jqXHR.responseText);

                increment.parent().parent().data("quantity", results["new_quantity"]);

                increment.parent().parent().find(".card-quantity").text(results["new_quantity"]);
            }
        }, "json");
    });

    $("body").on("click", ".card .decrement", function(event) {
        var decrement, cardId, quantity;

        event.preventDefault();

        decrement = $(this);

        cardId = decrement.parent().parent().data("card-id");

        quantity = parseInt(decrement.parent().parent().data("quantity")) - 1;

        if (quantity < 0) {
            quantity = 0;
        }

        $.post("/collection", "_method=put&card_id=" + cardId + "&quantity=" + quantity, function(data, status, jqXHR) {
            var results;

            if (jqXHR.status === 200) {
                results = $.parseJSON(jqXHR.responseText);

                decrement.parent().parent().data("quantity", results["new_quantity"]);

                decrement.parent().parent().find(".card-quantity").text(results["new_quantity"]);
            }
        }, "json");
    });

    $("#confirm_delete_account #enter_username, #confirm_delete_account #enter_username_confirmation").on("keyup", function() {
        if ($("#confirm_delete_account #enter_username").val() === $("#confirm_delete_account #username").val() && $("#confirm_delete_account #enter_username_confirmation").val() === $("#confirm_delete_account #username").val()) {
            $("#confirm_delete_account input[type='submit']").attr("disabled", false);
        } else {
            $("#confirm_delete_account input[type='submit']").attr("disabled", true);
        }
    });

    $("body").on("submit", "#confirm_delete_account", function(event) {
        if ($("#confirm_delete_account #enter_username").val() !== $("#confirm_delete_account #username").val() && $("#confirm_delete_account #enter_username_confirmation").val() !== $("#confirm_delete_account #username").val()) {
            event.preventDefault();
        }
    });
});
