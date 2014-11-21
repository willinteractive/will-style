jQuery(document).ready(function($) {
	var headerHeight = $('.cd-header').height();

	var closePrimaryNav = function() {
		$('.cd-menu-icon').removeClass('is-clicked');
		$('.cd-header').removeClass('menu-is-open');

		$('.cd-primary-nav').removeClass('is-visible').one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend');
	};

	var openPrimaryNav = function() {
		$('.cd-menu-icon').addClass('is-clicked');
		$('.cd-header').addClass('menu-is-open');

		$('.cd-primary-nav').addClass('is-visible').one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend');	
	};

	var togglePrimaryNav = function() {
		$('.cd-menu-icon').toggleClass('is-clicked');
		$('.cd-header').toggleClass('menu-is-open');
		
		if( $('.cd-primary-nav').hasClass('is-visible') ) {
			$('.cd-primary-nav').removeClass('is-visible').one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend');
		} else {
			$('.cd-primary-nav').addClass('is-visible').one('webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend');	
		}
	};

	$(window).on('scroll', { previousTop: 0 }, function() {
		var currentTop = $(window).scrollTop();
		//check if user is scrolling up
		if (currentTop < this.previousTop ) {
			//if scrolling up...
			if (currentTop > 0 && $('.cd-header').hasClass('is-fixed')) {
				$('.cd-header').addClass('is-visible');
			} else {
				$('.cd-header').removeClass('is-visible is-fixed');
			}
		} else {
			//if scrolling down...
			$('.cd-header').removeClass('is-visible');
			if( currentTop > headerHeight && !$('.cd-header').hasClass('is-fixed')) $('.cd-header').addClass('is-fixed');
		}
		this.previousTop = currentTop;
	});

	$(window).resize(closePrimaryNav);
	
	//open/close primary navigation
	$('.cd-primary-nav-trigger').on('click', togglePrimaryNav);
});