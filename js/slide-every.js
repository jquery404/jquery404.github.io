(function($){
    "use strict";

    // Sections backgrounds

    var slideSection = $(".homeslide-item");
    slideSection.each(function(indx){

        if ($(this).attr("data-background")){
            $(this).css("background-image", "url(" + $(this).data("background") + ")");
        }
    });

    $(document).ready(function(){
        js_height_full();
        homeSlidersFull();
        //HEADER SLIDE BACKGROUND
         $('#slides').superslides({
            hashchange: false,
            play: 4000,
            animation: 'fade',
            pagination: false,
            inherit_height_from: '.header-background'
        });
    });

    $(window).resize(function(){
    	js_height_full();
    });
    // $(window).on("debouncedresize", function() {
    //     js_height_full();
    // });

})(jQuery);
/* ---------------------------------------------
     Sliders
--------------------------------------------- */
function homeSlidersFull(){
    (function($){
        "use strict";

		if (typeof $.fn.owlCarousel == 'function') {
		
			// Fullwidth slider
			$(".fullwidth-slider").owlCarousel({
				slideSpeed: 350,
				singleItem: true,
				autoHeight: true,
                pagination:false,
				navigation: true,
                autoPlay: true,
				//navigationText: ["<i class='fa fa-angle-left'></i>", "<i class='fa fa-angle-right'></i>"]
			});

			// Fullwidth slider
			$(".fullscreen-slider").owlCarousel({
				transitionStyle: "fadeUp",
				slideSpeed: 350,
				singleItem: true,
				autoHeight: true,
                pagination:false,
				navigation: true,
                autoPlay: true,
				//navigationText: ["<i class='fa fa-angle-left'></i>", "<i class='fa fa-angle-right'></i>"]
			});


		}
	})(jQuery);
}

/* ---------------------------------------------
 Height Full
 --------------------------------------------- */
function js_height_full(){
    (function($){
        var heightoff = 0;
        if($('#wpadminbar').length){
            heightoff = $('#wpadminbar').outerHeight();
        }
        var heightSlide = $(window).outerHeight() - heightoff;
        $(".full-height").css("height",heightSlide);
        // $(".js-height-parent").each(function(){
        //     $(this).height($(this).parent().first().height());
        // });
    })(jQuery);
}