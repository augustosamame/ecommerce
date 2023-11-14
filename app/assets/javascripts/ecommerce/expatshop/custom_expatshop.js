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
 
  
});

$(document).ready(function () {
  var bx = $('.video-slider').bxSlider(
    {
      mode: 'horizontal',
      auto: true,
      //autoControls: true,
      //captions: true,
      //stopAutoOnClick: true,
      slideWidth: 1280,
      video: true,
      infiniteLoop: true,
      adaptiveheight: true,
      // pager: false,
      // startSlide: 0,
      // speed: 5000,
      // useCSS: false,
      // responsive: true,
      autoHover: true,
      autoDelay: 5000,
      controls: true,
      autostart: true,
      //onSliderLoad: function(currentIndex) {
      //  $("video").trigger("play");
      //},
      //onSlideBefore: function(slide) {
      //  bx.stopAuto;
      //  console.log('Stop Auto')
      //}
      onSlideAfter: function ($slideElement, oldIndex, newIndex) {
        if ($slideElement.hasClass('video-slide')) {
          var video = $slideElement.find('video').get(0);
          video.addEventListener('ended', function () {
            slider.goToNextSlide();
          });
        }
      }
    }
  );

});
