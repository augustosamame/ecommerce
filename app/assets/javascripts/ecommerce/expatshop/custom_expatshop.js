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
      console.log('thumb', thumb)
      return "<button><img src='https://devtechperu-expatshop-dev.s3.amazonaws.com/static/images/chevron-right.png'></button>";
    },
    responsive: [
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
          infinite: true,
          dots: false,
          pager: false,
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


  $('#currency').on('change', function () {
    var url = window.location.pathname + window.location.search
    var selectedValue = $(this).val();
    console.log('Selected value:', selectedValue);
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
    console.log('Selected value:', selectedValue);
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
          breakpoint: 768,
          settings: {
            slidesToShow: 2,
            slidesToScroll: 4,
            infinite: true,
            dots: false,
          },
        },
      ],
    });
  });


});
