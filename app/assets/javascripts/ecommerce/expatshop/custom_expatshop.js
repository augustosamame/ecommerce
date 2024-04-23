function fly_to_cart() {
  //console.log ("function fly_to_cart fired!");
  $('#cart-line').shake({
    interval: 100,
    distance: 20,
    times: 5
  });
};

function show_stock_alert(lang) {
  if (lang == 'es-PE') {
    Swal({
      type: 'info',
      title: 'Le avisaremos cuando el producto esté nuevamente en Stock',
      text: ""
    });
  } else {
    Swal({
      type: 'info',
      title: 'We will alert you when product is back in stock',
      text: ""
    });
  }
};

function show_stock_alert_signed_out(lang) {
  if (lang == 'es-PE') {
    Swal({
      type: 'error',
      title: 'Debe iniciar sesión o registrarse para crear alertas de stock.',
      text: ""
    });
  } else {
    Swal({
      type: 'error',
      title: 'You must sign in or register to generate a stock alert.',
      text: ""
    });
  }
};

function add_to_cart_no_stock() {
  //console.log ("function fly_to_cart fired!");
  //$('#shopping-cart').shake({
  //    interval: 100,
  //    distance: 20,
  //    times: 5
  //});
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
var _ddlLangLoaded = false;
$("#langMobile").ddslick({
  width: "100%",
  imagePosition: "left",
  // defaultSelectedIndex: 2,
  onSelected: function (data) {
    // console.log(data.selectedData.value);
    var url = window.location.pathname + window.location.search
    if (_ddlLangLoaded === false) {
      _ddlLangLoaded = true;
    }
    else {
      if (data.selectedData.value == 0) {
        if (url.indexOf('?') == -1) {
          window.location.href = url + "?lang=en-PE"
        } else {
          window.location.href = url + "&lang=en-PE"
        }
      } else {
        if (url.indexOf('?') == -1) {
          window.location.href = url + "?lang=es-PE"
        } else {
          window.location.href = url + "&lang=es-PE"
        }
      }
    }
  }
});

var _ddlCurrencyLoaded = false;
$("#currencyMobile").ddslick({
  width: "100%",
  // defaultSelectedIndex: 'pen',
  onSelected: function (data) {
    // console.log(data.selectedData.value);
    var url = window.location.pathname + window.location.search
    if (_ddlCurrencyLoaded === false) {
      _ddlCurrencyLoaded = true;
    }
    else {
      if (data.selectedData.value == 'usd') {
        if (url.indexOf('?') == -1) {
          window.location.href = url + "?currency=usd"
        } else {
          window.location.href = url + "&currency=usd"
        }
      } else {
        if (url.indexOf('?') == -1) {
          window.location.href = url + "?currency=pen"
        } else {
          window.location.href = url + "&currency=pen"
        }
      }
    }  
  }
});

// brand slider
$(function () {
  $(".brand-slider").slick({
    dots: false,
    infinite: true,
    arrows: true,
    speed: 300,
    slidesToShow: 5,
    slidesToScroll: 5,
    prevArrow: "<img class='a-left control-c prev slick-prev' src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-left.png'>",
    nextArrow: "<img class='a-right control-c next slick-next' src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-right.png'>",
    responsive: [
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 3,
          infinite: true,
          dots: false,
          arrows: true,
        },
      },
    ],
  });
});

// featured products slider
$(function () {
  $(".featured-product-slider").slick({
    dots: false,
    infinite: true,
    speed: 300,
    slidesToShow: 4,
    slidesToScroll: 4,
    prevArrow: "<img class='a-left control-c prev slick-prev' src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-left.png'>",
    nextArrow: "<img class='a-right control-c next slick-next' src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-right.png'>",
    customPaging: function (slider, i) {
      var thumb = $(slider.$slides[i]).data('thumb');
      // console.log('thumb', thumb)
      return "<button><img src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-right.png'></button>";
    },
    responsive: [
      {
        breakpoint: 1024,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
        },
      },
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
        },
      },
    ],
  });
});

// testimonial slider
$(function () {
  $(".testimonial-slider").slick({
    dots: false,
    infinite: true,
    speed: 300,
    slidesToShow: 4,
    slidesToScroll: 4,
    prevArrow: "<img class='a-left control-c prev slick-prev' src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-left.png'>",
    nextArrow: "<img class='a-right control-c next slick-next' src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-right.png'>",
    responsive: [
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 4,
          infinite: true,
          dots: false,
          pager: false,
        },
      },
    ],
  });
 
  
});

$(document).ready(function () {

  $('#country-mosaic').Mosaic({
    maxRowHeight: 333,
    maxRowHeightPolicy: 'tail',
    defaultAspectRatio: 1.5,
    innerGap: 15,
  });

  //$('#country-mosaic').justifiedGallery({
  //  rowHeight: 333,
  //  lastRow: 'justify',
  //  margins: 15,
  //  captions: false,
  //  randomize: false,
  // });

  $(".noo-search").on("click", function () {
    $(".search-header5").fadeIn(1).addClass("search-header-eff");
    $(".search-header5").find('input[type="search"]').val("").attr("placeholder", "").select();
    return false;
  });
  $(".remove-form").on("click", function () {
    $(".search-header5").fadeOut(1).removeClass("search-header-eff");
  });


  $('#currency').on('change', function () {
    var url = window.location.pathname + window.location.search
    var selectedValue = $(this).val();
    // console.log('Selected value:', selectedValue);
    if (selectedValue == 'usd') {
      if (url.indexOf('?') == -1) {
        window.location.href = url + "?currency=usd"
      } else {
        window.location.href = url + "&currency=usd"
      }
    } else {
      if (url.indexOf('?') == -1) {
        window.location.href = url + "?currency=pen"
      } else {
        window.location.href = url + "&currency=pen"
      }
    }
  });

  $('#lang').on('change', function () {
    var url = window.location.pathname + window.location.search
    var selectedValue = $(this).val();
    // console.log('Selected value:', selectedValue);
    if (selectedValue == 'english') {
      if (url.indexOf('?') == -1) {
        window.location.href = url + "?lang=en-PE"
      } else {
        window.location.href = url + "&lang=en-PE"
      }
    } else {
      if (url.indexOf('?') == -1) {
        window.location.href = url + "?lang=es-PE"
      } else {
        window.location.href = url + "&lang=es-PE"
      }
    }
  });

  // related products slider
  $(function () {
    $(".related-product-slider").slick({
      dots: false,
      infinite: true,
      speed: 300,
      slidesToShow: 3,
      slidesToScroll: 3,
      prevArrow: "<img class='a-left control-c prev slick-prev' src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-left.png'>",
      nextArrow: "<img class='a-right control-c next slick-next' src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-right.png'>",
      responsive: [
        {
          breakpoint: 1200,
          settings: {
            slidesToShow: 2,
            slidesToScroll: 2,
          },
        },
        {
          breakpoint: 768,
          settings: {
            slidesToShow: 1,
            slidesToScroll: 1,
          },
        },
      ],
    });
  });


});
