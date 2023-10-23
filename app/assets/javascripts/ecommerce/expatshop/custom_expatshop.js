// brand slider
$(function () {
  $(".brand-slider").slick({
    dots: false,
    infinite: true,
    speed: 300,
    slidesToShow: 5,
    slidesToScroll: 2,
    responsive: [
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 3,
          slidesToScroll: 3,
          infinite: true,
          dots: false,
        },
      },
    ],
  });
});
// featured products slider
$(function () {
  $(".featured-product-slider").slick({
    dots: true,
    infinite: true,
    speed: 300,
    slidesToShow: 4,
    slidesToScroll: 4,
    responsive: [
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 4,
          infinite: true,
          dots: true,
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
  $("#lang").ddslick({
    width: "100%",
    imagePosition: "left",
  });
  $("#langMobile").ddslick({
    width: "100%",
    imagePosition: "left",
  });

  $("#currency").ddslick({
    width: "100%",
  });
});
