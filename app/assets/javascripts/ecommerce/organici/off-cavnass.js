!function($){$(document).ready(function(){var $btn=$('.btn-navbar'),$nav=null,$fixeditems=null;if(!$btn.length){return;}
$(document.documentElement).addClass('off-canvas-ready');$nav=$('<div class="noo-main-canvas" />').appendTo($('<div id="off-canvas-nav"></div>').appendTo(document.body));$($btn.data('target')).clone().appendTo($nav);$btn.click(function(e){if($(this).data('off-canvas')=='show'){hideNav();}else{showNav();$('body').append('<a class="exit-cavas" href="#">&nbsp;</a>');}
return false;});var posNav=function(){var t=$(window).scrollTop();if(t<$nav.position().top)$nav.css('top',t);},bdHideNav=function(e){e.preventDefault();hideNav();return false;},showNav=function(){$('.btn-navbar').addClass('eff');$('html').addClass('off-canvas');$nav.css('top',$(window).scrollTop());setTimeout(function(){$btn.data('off-canvas','show');$('html').addClass('off-canvas-enabled');$(window).bind('scroll touchmove',posNav);$('#off-canvas-nav').bind('click',function(e){if (e.target.id === "sign_out_link") {$.post("/users/sign_out", { _method: 'delete' });location.reload();}else{e.stopPropagation();}});$('html').bind('click',bdHideNav);},50);setTimeout(function(){},1000);},hideNav=function(){$('.btn-navbar').removeClass('eff');$(window).unbind('scroll touchmove',posNav);$('#off-canvas-nav').unbind('click');$('#off-canvas-nav a').unbind('click',hideNav);$('html').unbind('click',bdHideNav);$('html').removeClass('off-canvas-enabled');$btn.data('off-canvas','hide');setTimeout(function(){$('html').removeClass('off-canvas');},600);$('.exit-cavas').remove();},wpfix=function(step){if($fixeditems==-1){return;}
if(!$fixeditems){$fixeditems=$('body').children().filter(function(){return $(this).css('position')==='fixed'});if(!$fixeditems.length){$fixeditems=-1;return;}}
if(step==1){$fixeditems.css({'position':'absolute','top':$(window).scrollTop()+'px'});}else{$fixeditems.css({'position':'','top':''});}};})}(jQuery);
