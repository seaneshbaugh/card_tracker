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
        var original = $(this).css("color");

        $(this).mouseover(function() {
            return $(this).stop().animate({
                color: color
            }, duration);
        });

        return $(this).mouseout(function() {
            return $(this).stop().animate({
                color: original
            }, duration);
        });
    });
};

$(function() {
    $("body").on("click", ".card .increment", function(event) {
        event.preventDefault();

        var that = this;

        var cardID = $(this).parent().parent().data("card-id");

        var quantity = parseInt($(this).parent().parent().data("quantity")) + 1;

        $.post("/collection", "_method=put&card_id=" + cardID + "&quantity=" + quantity, function(data, status, jqXHR) {
            if (jqXHR.status === 200) {
                var results = $.parseJSON(jqXHR.responseText);

                $(that).parent().parent().data("quantity", results["new_quantity"]);

                $(that).parent().parent().find(".card-quantity").text(results["new_quantity"]);
            }
        }, "json");
    });

    $("body").on("click", ".card .decrement", function(event) {
        event.preventDefault();

        var that = this;

        var cardID = $(this).parent().parent().data("card-id");

        var quantity = parseInt($(this).parent().parent().data("quantity")) - 1;

        if (quantity < 0) {
            quantity = 0;
        }

        $.post("/collection", "_method=put&card_id=" + cardID + "&quantity=" + quantity, function(data, status, jqXHR) {
            if (jqXHR.status === 200) {
                var results = $.parseJSON(jqXHR.responseText);

                $(that).parent().parent().data("quantity", results["new_quantity"]);

                $(that).parent().parent().find(".card-quantity").text(results["new_quantity"]);
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
