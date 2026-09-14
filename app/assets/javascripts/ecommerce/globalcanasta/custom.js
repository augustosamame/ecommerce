// Legacy helpers still called from server-rendered JS responses
// (cart_items/show.js.erb, product/stock_alert*.js.erb) and the header.
// Sliders, ddslick, Mosaic and the search overlay were retired with the
// GlobalCanasta redesign (see gc.js for the replacements).

function fly_to_cart() {
  $('#cart-line').shake({
    interval: 100,
    distance: 20,
    times: 5
  });
};

// Titles arrive already translated from product/stock_alert*.js.erb
// (I18n.locale), so the copy follows the store language, not the session.
function show_stock_alert(title) {
  Swal({ type: 'info', title: title, text: "" });
};

function show_stock_alert_signed_out(title) {
  Swal({ type: 'error', title: title, text: "" });
};

function add_to_cart_no_stock() {
  alert("Product is Out of Stock");
};

$.fn.shake = function (settings) {
  if (typeof settings.interval == 'undefined') {
    settings.interval = 100;
  }

  if (typeof settings.distance == 'undefined') {
    settings.distance = 10;
  }

  if (typeof settings.times == 'undefined') {
    settings.times = 4;
  }

  if (typeof settings.complete == 'undefined') {
    settings.complete = function () { };
  }

  $(this).css('position', 'relative');

  for (var iter = 0; iter < (settings.times + 1); iter++) {
    $(this).animate({ left: ((iter % 2 == 0 ? settings.distance : settings.distance * -1)) }, settings.interval);
  }

  $(this).animate({ left: 0 }, settings.interval, settings.complete);
};

$.fn.bounce = function (settings) {
  if (typeof settings.interval == 'undefined') {
    settings.interval = 100;
  }

  if (typeof settings.distance == 'undefined') {
    settings.distance = 10;
  }

  if (typeof settings.times == 'undefined') {
    settings.times = 4;
  }

  if (typeof settings.complete == 'undefined') {
    settings.complete = function () { };
  }

  $(this).css('position', 'relative');

  for (var iter = 0; iter < (settings.times + 1); iter++) {
    $(this).animate({ top: ((iter % 2 == 0 ? settings.distance : settings.distance * -1)) }, settings.interval);
  }

  $(this).animate({ top: 0 }, settings.interval, settings.complete);
};

// Currency / locale switchers (desktop header selects). The mobile drawer
// uses #usd-currency / #pen-currency / #en-lang / #es-lang, handled in the
// base layout.
function gcAppendParam(param, value) {
  var url = window.location.pathname + window.location.search;
  var sep = url.indexOf('?') == -1 ? '?' : '&';
  window.location.href = url + sep + param + '=' + value;
}

$(document).ready(function () {
  $('#currency').on('change', function () {
    gcAppendParam('currency', $(this).val() == 'usd' ? 'usd' : 'pen');
  });

  $('#lang').on('change', function () {
    gcAppendParam('lang', $(this).val() == 'english' ? 'en-PE' : 'es-PE');
  });
});
