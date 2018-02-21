$(document).ready(function() {
    $(".noo-search").on("click", function() {
        $(".search-header5").fadeIn(1).addClass("search-header-eff");
        $(".search-header5").find('input[type="search"]').val("").attr("placeholder", "").select();
        return false;
    });
    $(".remove-form").on("click", function() {
        $(".search-header5").fadeOut(1).removeClass("search-header-eff");
    });
    $(".button-menu-extend").on("click", function() {
        $(".noo-menu-extend-overlay").fadeIn(1, function() {
            $(".noo-menu-extend").addClass("show");
        }).addClass("show");
        return false;
    });
    $(".menu-closed, .noo-menu-extend-overlay").on("click", function() {
        $(".noo-menu-extend-overlay").removeClass("show").hide();
        $(".noo-menu-extend").removeClass("show");
    });
    if ($("body").hasClass("fixed_top")) {
        $(window).scroll(function() {
            var $resTopbar = 0;
            if ($(".noo-topbar").length > 0) {
                var $heightTopbar = $(".noo-topbar").height();
                $resTopbar = "-" + $heightTopbar + "px";
            }
            var $heightBar = $("header").height();
            if ($(".header-5").length > 0) {
                if ($(window).width() < 992) {
                    $resTopbar = "144px";
                } else {
                    $heightBar = 200;
                }
            }
            var $top = $(window).scrollTop();
            if ($top <= $heightBar) {
                if ($("header").hasClass("eff")) {
                    if ($(".header-6").length > 0) {
                        $("header").css("marginTop", "25px").removeClass("eff");
                    } else {
                        $("header").css("marginTop", 0).removeClass("eff");
                    }
                }
            } else {
                if (!$("header").hasClass("eff")) {
                    $("header").css("marginTop", "-150px").animate({
                        marginTop: $resTopbar
                    }, 700);
                    $("header").addClass("eff");
                }
            }
        });
    }
    resize_window();
    $(window).resize(function() {
        resize_window();
    });
    function resize_window() {
        if ($(".header-1").length > 0) {
            if ($(window).width() < 1500) {
                if ($("header").find(".noo-menu-option").find("li").length > 0) $("header").find(".noo-menu-option").addClass("collapse");
            } else {
                $("header").find(".noo-menu-option").removeClass("collapse");
            }
        }
        if ($(".header-3").length > 0) {
            if ($(window).width() < 1300) {
                if ($("header").find(".noo-menu-option").find("li").length > 0) $("header").find(".noo-menu-option").addClass("collapse");
            } else {
                $("header").find(".noo-menu-option").removeClass("collapse");
            }
        }
    }
    $("#off-canvas-nav li.menu-item-has-children").append('<i class="fa fa-angle-down"></i>');
    $("#off-canvas-nav li.menu-item-has-children i").on("click", function(e) {
        var link_i = $(this);
        link_i.prev().slideToggle(300);
        link_i.parent().toggleClass("active");
    });
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        $(".navbar-nav").find(".menu-item-has-children").find("a").on("touchstart", function(e) {
            "use strict";
            var link = $(this);
            if (link.hasClass("hover")) {
                return true;
            } else {
                link.addClass("hover");
                $(".navbar-nav").find(".menu-item-has-children").find("a").not(this).removeClass("hover");
                e.preventDefault();
                return false;
            }
        });
    }
	
	//Elastic Drags
	if($('#elasticstack').length > 0) {
		new ElastiStack( document.getElementById( 'elasticstack' ) );
	}
	
	//Countdown Timer
	if($('.defaultCountdown').length > 0) {
		var austDay = new Date(2016, 03 - 1,  31);
		$('.defaultCountdown').countdown({until: austDay});
		$('#year').text(austDay.getFullYear());
	}
	if($('.noo_custom_countdown').length > 0) {
		var austDay = new Date(2016, 03 - 1,  21);
		$('.noo_custom_countdown').countdown({until: austDay});
		$('#year').text(austDay.getFullYear());
	}
	
	//Owl Carousel
	$('.noo-product-sliders').owlCarousel({
		items : 4,
		itemsDesktop : [1199,4],
		itemsDesktopSmall : [991,2],
		itemsTablet: [768, 2],
		slideSpeed:500,
		paginationSpeed:800,
		rewindSpeed:1000,
		autoHeight: false,
		addClassActive: true,
		autoPlay: false,
		loop:true,
		pagination: true
	});
	
	//Owl Carousel
	$('.blog-slider').owlCarousel({
		items : 1,
		singleItem: true,
	});
	
	$('.noo-slider-image').owlCarousel({
		items : 3,
		itemsDesktop : [1199,3],
		itemsDesktopSmall : [991,2],
		itemsTablet: [768, 1],
		slideSpeed:500,
		paginationSpeed:800,
		rewindSpeed:1000,
		autoHeight: true,
		addClassActive: true,
		autoPlay: true,
		loop:true,
		pagination: false
	});
	
	$('.noo-simple-product-slider').owlCarousel({
		items : 5,
		itemsDesktop : [1199,5],
		itemsDesktopSmall : [979,3],
		itemsTablet: [768, 2],
		slideSpeed:500,
		paginationSpeed:800,
		rewindSpeed:1000,
		autoHeight: true,
		addClassActive: true,
		autoPlay: false,
		loop:true,
		pagination: false
	});
	
	//Testimonial Carousel
	var sync1 = $(".noo-testimonial-sync2");
	var sync2 = $(".noo-testimonial-sync1");

	sync1.owlCarousel({
		singleItem : true,
		slideSpeed : 1000,
		navigation: false,
		pagination:false,
		afterAction : syncPosition,
		responsiveRefreshRate : 200
	});

	function syncPosition(el){
		var current = this.currentItem;
		$(".noo-testimonial-sync1")
			.find(".owl-item")
			.removeClass("synced")
			.eq(current)
			.addClass("synced")
		if($(".noo-testimonial-sync1").data("owlCarousel") !== undefined){
			center(current)
		}
	}

	$(".noo-testimonial-sync1").on("click", ".owl-item", function(e){
		e.preventDefault();
		var number = $(this).data("owlItem");
		sync1.trigger("owl.goTo",number);
	});

	sync2.owlCarousel({
		items : 3,
		itemsDesktop      : [1199,3],
		itemsDesktopSmall     : [979,3],
		itemsTablet       : [768,3],
		itemsMobile       : [479,2],
		pagination:false,
		responsiveRefreshRate : 100,
		afterInit : function(el){
			el.find(".owl-item").eq(1).click();
		}
	});

	function center(number){
		var sync2visible = sync2.data("owlCarousel").owl.visibleItems;
		var num = number;
		var found = false;
		for(var i in sync2visible){
			if(num === sync2visible[i]){
				var found = true;
			}
		}

		if(found===false){
			if(num>sync2visible[sync2visible.length-1]){
				sync2.trigger("owl.goTo", num - sync2visible.length+2)
			}else{
				if(num - 1 === -1){
					num = 0;
				}
				sync2.trigger("owl.goTo", num);
			}
		} else if(num === sync2visible[sync2visible.length-1]){
			sync2.trigger("owl.goTo", sync2visible[1])
		} else if(num === sync2visible[0]){
			sync2.trigger("owl.goTo", num-1)
		}
	}
	
	$('.noo_testimonial').each(function(){
		$(this).owlCarousel({
			items : 1,
			itemsDesktop : [1199,1],
			itemsDesktopSmall : [979,1],
			itemsTablet: [768, 1],
			slideSpeed:500,
			paginationSpeed:800,
			rewindSpeed:1000,
			autoHeight: false,
			addClassActive: true,
			autoPlay: true,
			loop:true,
			pagination: true,
			afterInit : function(el){
				el.find(".owl-item").eq(1).addClass("synced");
			}
		});
	});
	
	//Ajax popup
	if($(".noo-qucik-view").length > 0) {
		$('.noo-qucik-view').magnificPopup({
			type: 'ajax'
		});
	}
	
	//Boxes hover
	$('.box-inner').each(function(){
		var first_color = $(this).find('.product-box-header li:first-child span').data('color');
		$(this).find('.product-box-header li:first-child span').css('background',first_color).addClass('acitve');
		$(this).find('.box-content h3').css('color',first_color);
		$(this).find('.box-description-tab').css('background-color',first_color);
	});

	$('.product-box-header li span').mousemove(function(){
		var $parent = $(this).closest('.box-inner');
		$parent.find('.product-box-header li span').removeAttr('style').removeClass('acitve');
		var color   = $(this).data('color');
		var id      = $(this).data('id');
		$(this).css('background',color).addClass('acitve');
		$parent.find('.box-content-tab').hide();
		$parent.find(id).show();
	});
	
	//Boxes Detail Slider
	$(".sync1").owlCarousel({
		singleItem : true,
		slideSpeed : 1000,
		navigation: false,
		pagination:false,
		autoHeight : true,
		responsiveRefreshRate : 200
	});

	$(".sync2").owlCarousel({
		items : 4,
		itemsDesktop      : [1199,4],
		itemsDesktopSmall : [979,4],
		itemsTablet       : [768,3],
		itemsMobile       : [479,2],
		pagination:false,
		responsiveRefreshRate : 100
	});

	$(".sync2").on("click", ".owl-item", function(e){
		e.preventDefault();
		var number = $(this).data("owlItem");
		$(".sync1").trigger("owl.goTo",number);
	});
	
	//Recent Post Background
	$('.widget_recent_entries .post_list_widget li').each(function(){
		var post_thumb = $(this).find(".post-thumb");
		post_thumb.css('background-image','url("' + post_thumb.attr("data-bg") + '")');
	});
	
	//Noo Simple Product Slider
	$('.noo-simple-product-slider li').each(function(){
		var slider_item = $(this).find(".noo-simple-slider-item");
		slider_item.css('background-image','url("' + slider_item.attr("data-bg") + '")');
	});
	
	//Jquery Flickr Feed
	if($('.flickr-badge-wrapper').length > 0) {
		$('.flickr-badge-wrapper').jflickrfeed({
			limit: 9,
			qstrings: {
				id: '71865026@N00'
			},
			itemTemplate: '<a class="flickr_badge_image" href="{{image_b}}"><img src="{{image_s}}" alt="{{title}}" /></a>'
		}, function(data) {
			$('.flickr_badge_image').magnificPopup({
			  type: 'image',
			  gallery:{
				enabled:true
			  }
			});
		});
	}
	
	//Init RevSlider
	if($('#rev_slider_1').length > 0) {
		revSlider_1();
	}
	if($('#rev_slider_2').length > 0) {
		revSlider_2();
	}
	if($('#rev_slider_3').length > 0) {
		revSlider_3();
	}
});

function revSlider_1(){
	$("#rev_slider_1").show().revolution({
	  sliderType:"standard",
	  sliderLayout:"fullscreen",
	  dottedOverlay:"none",
	  delay:9000,
	  navigation: {
		  keyboardNavigation:"off",
		  keyboard_direction: "horizontal",
		  mouseScrollNavigation:"off",
		  onHoverStop:"on",
		  touch:{
			  touchenabled:"on",
			  swipe_threshold: 75,
			  swipe_min_touches: 50,
			  swipe_direction: "horizontal",
			  drag_block_vertical: false
		  }
		  ,
		  bullets: {
			  enable:true,
			  hide_onmobile:true,
			  hide_under:600,
			  style:"ares",
			  hide_onleave:true,
			  hide_delay:200,
			  hide_delay_mobile:1200,
			  direction:"vertical",
			  h_align:"right",
			  v_align:"center",
			  h_offset:30,
			  v_offset:0,
			  space:5,
			  tmp:'<span class="tp-bullet-title">{{title}}</span>'
		  }
	  },
	  responsiveLevels:[1240,1024,778,480],
	  visibilityLevels:[1240,1024,778,480],
	  gridwidth:[1240,1024,778,480],
	  gridheight:[600,768,960,720],
	  lazyType:"none",
	  parallax: {
		  type:"mouse",
		  origo:"slidercenter",
		  speed:2000,
		  levels:[2,3,4,5,6,7,12,16,10,50,47,48,49,50,51,55],
		  type:"mouse",
	  },
	  shadow:0,
	  spinner:"off",
	  stopLoop:"on",
	  stopAfterLoops:2,
	  stopAtSlide:1,
	  shuffle:"off",
	  autoHeight:"off",
	  fullScreenAutoWidth:"off",
	  fullScreenAlignForce:"off",
	  fullScreenOffsetContainer: "",
	  fullScreenOffset: "",
	  hideThumbsOnMobile:"on",
	  hideSliderAtLimit:0,
	  hideCaptionAtLimit:0,
	  hideAllCaptionAtLilmit:0,
	  debugMode:false,
	  fallbacks: {
		  simplifyAll:"off",
		  nextSlideOnWindowFocus:"off",
		  disableFocusListener:false,
	  }
  });
}

function revSlider_2(){
	$("#rev_slider_2").show().revolution({
		sliderType:"standard",
		sliderLayout:"fullscreen",
		dottedOverlay:"none",
		delay:9000,
		navigation: {
			keyboardNavigation:"off",
			keyboard_direction: "horizontal",
			mouseScrollNavigation:"off",
			onHoverStop:"off",
			arrows: {
				style:"hades",
				enable:true,
				hide_onmobile:false,
				hide_onleave:false,
				tmp:'<div class="tp-arr-allwrapper"><div class="tp-arr-imgholder"></div></div>',
				left: {
					h_align:"left",
					v_align:"center",
					h_offset:20,
					v_offset:0
				},
				right: {
					h_align:"right",
					v_align:"center",
					h_offset:20,
					v_offset:0
				}
			}
		},
		visibilityLevels:[1240,1024,778,480],
		gridwidth:1240,
		gridheight:868,
		lazyType:"none",
		shadow:0,
		spinner:"spinner0",
		stopLoop:"on",
		stopAfterLoops:1,
		stopAtSlide:0,
		shuffle:"off",
		autoHeight:"off",
		fullScreenAutoWidth:"off",
		fullScreenAlignForce:"off",
		fullScreenOffsetContainer: "",
		fullScreenOffset: "",
		hideThumbsOnMobile:"off",
		hideSliderAtLimit:0,
		hideCaptionAtLimit:0,
		hideAllCaptionAtLilmit:0,
		debugMode:false,
		fallbacks: {
			simplifyAll:"off",
			nextSlideOnWindowFocus:"off",
			disableFocusListener:false,
		}
  });
}

function revSlider_3(){
	$("#rev_slider_3").show().revolution({
		sliderType:"standard",
		sliderLayout:"fullscreen",
		dottedOverlay:"none",
		delay:9000,
		navigation: {
			keyboardNavigation:"off",
			keyboard_direction: "horizontal",
			mouseScrollNavigation:"off",
			onHoverStop:"off",
			arrows: {
				style:"zeus",
				enable:true,
				hide_onmobile:false,
				hide_onleave:false,
				tmp:'<div class="tp-title-wrap">  	<div class="tp-arr-imgholder"></div> </div>',
				left: {
					h_align:"left",
					v_align:"center",
					h_offset:20,
					v_offset:0
				},
				right: {
					h_align:"right",
					v_align:"center",
					h_offset:20,
					v_offset:0
				}
			}
		},
		visibilityLevels:[1240,1024,778,480],
		gridwidth:1240,
		gridheight:868,
		lazyType:"none",
		shadow:0,
		spinner:"spinner0",
		stopLoop:"off",
		stopAfterLoops:-1,
		stopAtSlide:-1,
		shuffle:"off",
		autoHeight:"off",
		fullScreenAutoWidth:"off",
		fullScreenAlignForce:"off",
		fullScreenOffsetContainer: "",
		fullScreenOffset: "",
		disableProgressBar:"on",
		hideThumbsOnMobile:"off",
		hideSliderAtLimit:0,
		hideCaptionAtLimit:0,
		hideAllCaptionAtLilmit:0,
		debugMode:false,
		fallbacks: {
			simplifyAll:"off",
			nextSlideOnWindowFocus:"off",
			disableFocusListener:false,
		}
  });
}

$(window).load(function() {
    $(".noo-page-heading").addClass("eff");
    $(".page-title").addClass("eff");
    $(".noo-page-breadcrumb").addClass("eff");
    $(".noo-spinner").remove();
});