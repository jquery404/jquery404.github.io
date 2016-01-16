
$(function() {
    $('body').on('click', '.page-scroll a', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
    });
	
	
	$(document).delegate('*[data-toggle="lightbox"]:not([data-gallery="navigateTo"])', 'click', function(event) {
		event.preventDefault();
		return $(this).ekkoLightbox({
			onShown: function() {
				if (window.console) {
					return console.log('Checking our the events huh?');
				}
			},
			onNavigate: function(direction, itemIndex) {
				if (window.console) {
					return console.log('Navigating '+direction+'. Current item: '+itemIndex);
				}
			}
		});
	});
	
	var myNavBar = {

		flagAdd: true,

		elements: [],

		init: function (elements) {
			this.elements = elements;
		},

		add : function() {
			if(this.flagAdd) {
				for(var i=0; i < this.elements.length; i++) {
					document.getElementById(this.elements[i]).className += " fixed-theme";
					document.getElementById(this.elements[i]).className =
						document.getElementById(this.elements[i]).className.replace( /(?:^|\s)black-theme(?!\S)/g , '' );
				}
				this.flagAdd = false;
			}
		},

		remove: function() {
			for(var i=0; i < this.elements.length; i++) {
				document.getElementById(this.elements[i]).className =
						document.getElementById(this.elements[i]).className.replace( /(?:^|\s)fixed-theme(?!\S)/g , '' );
				if($('#' + this.elements[i]).hasClass('black'))
					document.getElementById(this.elements[i]).className += " black-theme";
			}
			this.flagAdd = true;
		}

	};

	/**
	 * Init the object. Pass the object the array of elements
	 * that we want to change when the scroll goes down
	 */
	myNavBar.init(  [
		"header",
		"header-container",
		"brand"
	]);

	/**
	 * Function that manage the direction
	 * of the scroll
	 */
	function offSetManager(){

		var yOffset = 0;
		var currYOffSet = window.pageYOffset;

		if(yOffset < currYOffSet) {
			myNavBar.add();
		}
		else if(currYOffSet == yOffset){
			myNavBar.remove();
		}
		
		
	}

	/**
	 * bind to the document scroll detection
	 */
	window.onscroll = function(e) {
		offSetManager();
	}

	/**
	 * We have to do a first detectation of offset because the page
	 * could be load with scroll down set.
	 */
	offSetManager();
	
});
