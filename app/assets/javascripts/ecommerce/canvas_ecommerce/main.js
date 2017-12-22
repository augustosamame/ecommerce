  // Topbar Hide
  $('#top-bar').on('click','#close-bar',function(){
    $(this).parents('#top-bar').slideUp(300);
    $('body').css('padding-top',0);
  })

  // Custom Carousel
  $('.owl-carousel').owlCarousel({
    items: 1,
    dotsContainer: '#item-color-dots',
      loop: true,
  });

  // Revolution Slider
  var tpj=jQuery;
  var revapi19;
  tpj(document).ready(function() {
    if(tpj("#rev_slider_19_1").revolution == undefined){
      revslider_showDoubleJqueryError("#rev_slider_19_1");
    }else{
      revapi19 = tpj("#rev_slider_19_1").show().revolution({
        sliderType:"carousel",
        //jsFileLocation: "include/rs-plugin/js/",
        jsFileLocation: "http://canvashtml-cdn.semicolonweb.com/include/rs-plugin/js/",
        sliderLayout:"fullwidth",
        dottedOverlay:"none",
        delay:5000,
        navigation: {
          keyboardNavigation:"on",
          keyboard_direction: "horizontal",
          mouseScrollNavigation:"off",
          mouseScrollReverse:"default",
          onHoverStop:"on",
          thumbnails: {
            style:"gyges",
            enable:true,
            width:50,
            height:50,
            min_width:50,
            wrapper_padding:5,
            wrapper_color:"transparent",
            tmp:'<span class="tp-thumb-img-wrap">  <span class="tp-thumb-image"></span></span>',
            visibleAmount:5,
            hide_onmobile:false,
            hide_over:1240,
            hide_onleave:false,
            direction:"horizontal",
            span:false,
            position:"inner",
            space:5,
            h_align:"center",
            v_align:"top",
            h_offset:0,
            v_offset:20
          }
          ,
          tabs: {
            style:"gyges",
            enable:true,
            width:220,
            height:80,
            min_width:220,
            wrapper_padding:0,
            wrapper_color:"rgba(0,0,0,0.3)",
            tmp:'<div class="tp-tab-content">  <span class="tp-tab-date">{{param1}}</span>  <span class="tp-tab-title">{{title}}</span></div><div class="tp-tab-image"></div>',
            visibleAmount: 7,
            hide_onmobile: true,
            hide_under:1240,
            hide_onleave:false,
            hide_delay:200,
            direction:"vertical",
            span:true,
            position:"inner",
            space:0,
            h_align:"right",
            v_align:"center",
            h_offset:0,
            v_offset:0
          }
        },
        carousel: {
          horizontal_align: "center",
          vertical_align: "center",
          fadeout: "off",
          maxVisibleItems: 5,
          infinity: "on",
          space: 0,
          stretch: "off",
           showLayersAllTime: "off",
           easing: "Power3.easeInOut",
           speed: "800"
        },
        responsiveLevels:[1240,1024,778,480],
        visibilityLevels:[1240,1024,778,480],
        gridwidth:[800,700,400,300],
        gridheight:[600,600,500,400],
        lazyType:"single",
        shadow:0,
        spinner:"off",
        stopLoop:"off",
        stopAfterLoops:-1,
        stopAtSlide:-1,
        shuffle:"off",
        autoHeight:"off",
        hideThumbsOnMobile:"off",
        hideSliderAtLimit:0,
        hideCaptionAtLimit:0,
        hideAllCaptionAtLilmit:0,
        debugMode:true,
        fallbacks: {
          simplifyAll:"off",
          nextSlideOnWindowFocus:"off",
          disableFocusListener:false,
        }
      });
    }
  });	/*ready*/
