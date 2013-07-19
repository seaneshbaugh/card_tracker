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
