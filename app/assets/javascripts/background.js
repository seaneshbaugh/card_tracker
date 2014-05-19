function shiftChannel(ca, cb) {
    if (ca > cb) {
        return ca - 1;
    } else {
        if (ca < cb) {
            return ca + 1;
        }
    }

    return ca;
}

function shiftColor(ca, cb) {
    var red, green, blue, alpha;

    red = shiftChannel(ca[0], cb[0]);

    green = shiftChannel(ca[1], cb[1]);

    blue = shiftChannel(ca[2], cb[2]);

    alpha = shiftChannel(ca[3], cb[3]);

    return [red, green, blue, alpha];
}

function shiftColors(colors) {
    colors[0].value = shiftColor(colors[0].value, colors[colors[0].next].original);
    colors[1].value = shiftColor(colors[1].value, colors[colors[1].next].original);
    colors[2].value = shiftColor(colors[2].value, colors[colors[2].next].original);
    colors[3].value = shiftColor(colors[3].value, colors[colors[3].next].original);
    colors[4].value = shiftColor(colors[4].value, colors[colors[4].next].original);

    if (colors[0].value.join() === colors[colors[0].next].original.join() &&
        colors[1].value.join() === colors[colors[1].next].original.join() &&
        colors[2].value.join() === colors[colors[2].next].original.join() &&
        colors[3].value.join() === colors[colors[3].next].original.join() &&
        colors[4].value.join() === colors[colors[4].next].original.join()) {

        colors[0].next = (colors[0].next + 1) % colors.length;
        colors[1].next = (colors[1].next + 1) % colors.length;
        colors[2].next = (colors[2].next + 1) % colors.length;
        colors[3].next = (colors[3].next + 1) % colors.length;
        colors[4].next = (colors[4].next + 1) % colors.length;
    }
}

function updatePointPosition(center, radius, point) {
    var newTheta;

    newTheta = point.theta + ((Math.PI / 180.0) / 32.0);

    if (newTheta >= 2.0 * Math.PI) {
        newTheta = 0.0;
    }

    point.x = center.x + Math.round(Math.cos(newTheta) * radius);

    point.y = center.y + Math.round(Math.sin(newTheta) * radius);

    point.theta = newTheta;
}

function updatePoints(center, radius, points) {
    points.forEach(function(point) {
        updatePointPosition(center, radius, point);

        // Update color here.
    });
}

function drawPoints(context, windowWidth, windowHeight, points) {
    points.forEach(function(point) {
        var gradient;

        gradient = context.createRadialGradient(point.x, point.y, 30, point.x, point.y, 60);

        gradient.addColorStop(0, "rgba(" + point.color.value[0] + ", " + point.color.value[1] + ", " + point.color.value[2] + ", 1.0)");

        gradient.addColorStop(0.8, "rgba(255, 255, 255, 0.3)");

        gradient.addColorStop(1, "rgba(255, 255, 255, 0.1)");

        context.fillStyle = gradient;

        context.fillRect(0, 0, windowWidth, windowHeight);
    });
}

$(function() {
    var $window, windowWidth, windowHeight, center, radius, points, theta, white, blue, black, red, green, colors, canvas, context, intervalLength;

    $window = $(window);

    windowWidth = $window.width();

    windowHeight = $window.height();

    center = {x: windowWidth / 2, y: windowHeight / 2};

    if (windowWidth < windowHeight) {
        radius = windowWidth / 4;
    } else {
        radius = windowHeight / 4;
    }

    white = [255, 252, 210, 255];

    blue = [171, 223, 252, 255];

    black = [204, 194, 192, 255];

    red = [248, 172, 139, 255];

    green = [158, 211, 171, 255];

    colors = [
        {original: white, value: white, next: 1},
        {original: blue, value: blue, next: 2},
        {original: black, value: black, next: 3},
        {original: red, value: red, next: 4},
        {original: green, value: green, next: 0}];

    points = [];

    theta = 0.0 - (Math.PI / 2.0);

    points.push({x: center.x + Math.round(Math.cos(theta) * radius), y: center.y + Math.round(Math.sin(theta) * radius), theta: theta, color: colors[0]});

    theta = (2.0 * Math.PI) / 5.0 - (Math.PI / 2.0);

    points.push({x: center.x + Math.round(Math.cos(theta) * radius), y: center.y + Math.round(Math.sin(theta) * radius), theta: theta, color: colors[1]});

    theta = ((2.0 * Math.PI) / 5.0) * 2.0 - (Math.PI / 2.0);

    points.push({x: center.x + Math.round(Math.cos(theta) * radius), y: center.y + Math.round(Math.sin(theta) * radius), theta: theta, color: colors[2]});

    theta = ((2.0 * Math.PI) / 5.0) * 3.0 - (Math.PI / 2.0);

    points.push({x: center.x + Math.round(Math.cos(theta) * radius), y: center.y + Math.round(Math.sin(theta) * radius), theta: theta, color: colors[3]});

    theta = ((2.0 * Math.PI) / 5.0) * 4.0 - (Math.PI / 2.0);

    points.push({x: center.x + Math.round(Math.cos(theta) * radius), y: center.y + Math.round(Math.sin(theta) * radius), theta: theta, color: colors[4]});

    canvas = document.getElementById("background-canvas");

    canvas.width = windowWidth;

    canvas.height = windowHeight;

    context = canvas.getContext("2d");

    intervalLength = Math.round(1000.0 / 60.);

    drawPoints(context, windowWidth, windowHeight, points);

    window.setInterval(function() {
        updatePoints(center, radius, points);

        drawPoints(context, windowWidth, windowHeight, points);
    }, intervalLength);
});
