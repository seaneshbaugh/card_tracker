//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require vendor_assets
//= require shared
//= require_self

$(function() {
    $("[rel*=tooltip]").tooltip({placement: "top"});
    $("[rel*=popover]").popover({trigger: "hover"});
});
