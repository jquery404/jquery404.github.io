
$(function() {
    $('body').on('click', '.page-scroll a', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: $($anchor.attr('href')).offset().top
        }, 1500, 'easeInOutExpo');
        event.preventDefault();
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
				}
				this.flagAdd = false;
			}
		},

		remove: function() {
			for(var i=0; i < this.elements.length; i++) {
				document.getElementById(this.elements[i]).className =
						document.getElementById(this.elements[i]).className.replace( /(?:^|\s)fixed-theme(?!\S)/g , '' );
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
	
	$("#elastic_grid_demo").elastic_grid({
		'showAllText' : 'All',
		'filterEffect': 'popup', // moveup, scaleup, fallperspective, fly, flip, helix , popup
		'hoverDirection': true,
		'hoverDelay': 0,
		'hoverInverse': false,
		'expandingSpeed': 500,
		'expandingHeight': 500,
		'items' :
		[
			{
				'title'         : 'Azuki bean',
				'description'   : 'Swiss chard pumpkin bunya nuts maize plantain aubergine napa cabbage soko coriander sweet pepper water spinach winter purslane shallot tigernut lentil beetroot.Swiss chard pumpkin bunya nuts maize plantain aubergine napa cabbage.',
				'thumbnail'     : ['images/small/1.jpg', 'images/small/2.jpg', 'images/small/3.jpg', 'images/small/10.jpg', 'images/small/11.jpg'],
				'large'         : ['images/large/1.jpg', 'images/large/2.jpg', 'images/large/3.jpg', 'images/large/10.jpg', 'images/large/11.jpg'],
				'button_list'   :
				[
					{ 'title':'Demo', 'url' : 'http://porfolio.bonchen.net/', 'new_window' : true },
					{ 'title':'Download', 'url':'http://porfolio.bonchen.net/', 'new_window' : false}
				],
				'tags'          : ['Self Portrait']
			},
			{
				'title'         : 'Swiss chard pumpkin',
				'description'   : 'Swiss chard pumpkin bunya nuts maize plantain aubergine napa cabbage soko coriander sweet pepper water spinach winter purslane shallot tigernut lentil beetroot.Swiss chard pumpkin bunya nuts maize plantain aubergine napa cabbage.',
				'thumbnail'     : ['images/small/4.jpg', 'images/small/5.jpg', 'images/small/6.jpg', 'images/small/7.jpg'],
				'large'         : ['images/large/4.jpg', 'images/large/5.jpg', 'images/large/6.jpg', 'images/large/7.jpg'],
				'button_list'   :
				[
					{ 'title':'Demo', 'url' : 'http://porfolio.bonchen.net/', 'new_window' : true },
					{ 'title':'Download', 'url':'http://porfolio.bonchen.net/', 'new_window' : true}
				],
				'tags'          : ['Landscape']
			},
			{
				'title'         : 'Spinach winter purslane',
				'description'   : 'Swiss chard pumpkin bunya nuts maize plantain aubergine napa cabbage soko coriander sweet pepper water spinach winter purslane shallot tigernut lentil beetroot.Swiss chard pumpkin bunya nuts maize plantain aubergine napa cabbage.',
				'thumbnail'     : ['images/small/15.jpg','images/small/8.jpg', 'images/small/9.jpg', 'images/small/10.jpg'],
				'large'         : ['images/large/15.jpg','images/large/8.jpg', 'images/large/9.jpg', 'images/large/10.jpg'],
				'button_list'   :
				[
					{ 'title':'Demo', 'url' : 'http://porfolio.bonchen.net/', 'new_window' : true },
					{ 'title':'Download', 'url':'http://porfolio.bonchen.net/', 'new_window' : true}
				],
				'tags'          : ['Self Portrait', 'Landscape']
			}

		]
	});

});
