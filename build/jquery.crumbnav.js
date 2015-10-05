/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	
	/*
		crumbnav.js 0.1

	  Created by Juho Viitasalo

		Based on flexnav by Jason Weaver http://jasonweaver.name
		Released under http://unlicense.org/
	 */
	var $;

	__webpack_require__(1);

	$ = jQuery;

	$('html').removeClass('no-js').addClass('js');

	$(function() {});

	$.fn.crumbnav = function(options) {
	  var $breadcrumb, $button, $current, $currentChildMenu, $moreMenu, $nav, $navUl, $parentButtons, $parents, $root, $topParentButtons, $topParents, addBreadcrumbClasses, addButtons, addListeners, addMoreMenu, addParentClasses, breakpoint, calcWidth, close, closeMenu, closeRootsMenu, getCloseElements, getOpenElements, open, openMenu, openRootsMenu, removeMoreMenu, resizer, settings;
	  settings = $.extend({
	    'navClass': 'crumbnav',
	    'navTitleClass': 'crumbnav__title',
	    'topParentClass': 'crumbnav__top-parent',
	    'parentClass': 'crumbnav__parent',
	    'openClass': 'cn-open',
	    'closedClass': 'cn-close',
	    'rootsOpenClass': 'cn-open-roots',
	    'rootsClosedClass': 'cn-close-roots',
	    'firstLevelClass': 'crumbnav--first-level',
	    'rootClass': 'crumbnav__root',
	    'currentClass': 'active',
	    'moreMenuClass': 'crumbnav__more-menu',
	    'breadcrumbClass': 'crumbnav-crumb',
	    'buttonClass': 'crumbnav__button',
	    'buttonTopParentClass': 'crumbnav__button--top-parent',
	    'buttonParentClass': 'crumbnav__button--parent',
	    'buttonMenuClass': 'crumbnav__button--menu',
	    'buttonMoreMenuClass': 'crumbnav__button--more-menu',
	    'buttonRootsMenuClass': 'crumbnav__button--root-menu',
	    'multipleRootsClass': 'crumbnav--multiple-roots',
	    'largeClass': 'crumbnav--large',
	    'hoverIntent': false,
	    'hoverIntentTimeout': 150,
	    'calcItemWidths': false,
	    'hover': false,
	    'menuText': 'Menu'
	  }, options);
	  this.options = settings;
	  $nav = $(this);
	  $navUl = $nav.children('ul').length === 1 ? $nav.children('ul') : alert("Unsupported number of ul's inside the navigation!");
	  $current = $('li.' + settings.currentClass, $navUl);
	  if ($current.length > 1) {
	    alert('Multiple active elements in the menu! There should be only one.');
	  }
	  $root = $();
	  $current = $();
	  $topParents = $();
	  $parents = $();
	  $breadcrumb = $();
	  $currentChildMenu = $();
	  $topParentButtons = $();
	  $parentButtons = $();
	  $moreMenu = $();
	  $button = $('<span class="' + settings.buttonClass + '"><i></i></span>');
	  $moreMenu = $('<li class="' + settings.moreMenuClass + '"><ul class="' + settings.moreMenuClass + '__popup"></ul></li>').append($button.clone().addClass(settings.buttonMoreMenuClass));
	  if ($nav.children('.' + settings.navTitleClass).length === 0) {
	    $nav.prepend('<div class="' + settings.navTitleClass + '">' + settings.menuText + '</div>');
	  }
	  addBreadcrumbClasses = function() {
	    var $breadcrumbLength, $currentParents;
	    $currentParents = $current.parentsUntil($navUl, 'li');
	    $breadcrumb = $currentParents.add($current);
	    $breadcrumbLength = $breadcrumb.length;
	    $breadcrumb.addClass(settings.breadcrumbClass).each(function(index) {
	      return $(this).addClass(settings.breadcrumbClass + '-out-' + index + ' ' + settings.breadcrumbClass + '-in-' + ($breadcrumbLength - index - 1));
	    });
	    $nav.addClass(settings.navClass + '-length-' + $breadcrumbLength);
	    if ($current.length && $breadcrumbLength > 1) {
	      return $root = $navUl.children('.' + settings.breadcrumbClass).addClass(settings.rootClass);
	    } else {
	      return $root = $nav.addClass(settings.firstLevelClass);
	    }
	  };
	  addParentClasses = function() {
	    $navUl.find(">li").each(function() {
	      if ($(this).has("ul").length) {
	        $(this).addClass(settings.topParentClass);
	        return $topParents = $topParents.add($(this));
	      }
	    });
	    return $navUl.find("ul li").each(function() {
	      if ($(this).has("ul").length) {
	        $(this).addClass(settings.parentClass);
	        return $parents = $parents.add($(this));
	      }
	    });
	  };
	  addButtons = function() {
	    if ($navUl.children('li').length > 1) {
	      $nav.addClass(settings.multipleRootsClass);
	    }
	    $navUl.before($button.clone().addClass(settings.buttonRootsMenuClass));
	    $navUl.after($button.clone().addClass(settings.buttonMenuClass));
	    $topParentButtons = $button.clone().addClass(settings.buttonTopParentClass).appendTo($topParents);
	    return $parentButtons = $button.clone().addClass(settings.buttonParentClass).appendTo($parents);
	  };
	  getCloseElements = function() {
	    return $nav.add($parents).add($topParents);
	  };
	  getOpenElements = function() {
	    return $nav.add($breadcrumb);
	  };
	  closeMenu = function() {
	    close(getCloseElements());
	    if ($nav.hasClass(settings.largeClass)) {
	      addMoreMenu();
	      return calcWidth();
	    }
	  };
	  openMenu = function() {
	    open(getOpenElements());
	    return removeMoreMenu();
	  };
	  open = function(elements) {
	    return elements.removeClass(settings.closedClass).addClass(settings.openClass);
	  };
	  close = function(elements) {
	    return elements.removeClass(settings.openClass).addClass(settings.closedClass);
	  };
	  closeRootsMenu = function() {
	    $nav.removeClass(settings.rootsOpenClass).addClass(settings.rootsClosedClass);
	    return $nav.find('.' + settings.rootsOpenClass).removeClass(settings.rootsOpenClass).addClass(settings.rootsClosedClass);
	  };
	  openRootsMenu = function() {
	    $nav.removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass).children('ul').children('li').removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass);
	    return $nav.children('.' + settings.buttonRootsMenuClass).removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass);
	  };
	  addListeners = function() {
	    $('> .' + settings.buttonMenuClass, $nav).on('click', function(e) {
	      e.stopPropagation();
	      e.preventDefault();
	      if ($nav.hasClass(settings.openClass)) {
	        return closeMenu();
	      } else {
	        closeRootsMenu();
	        return openMenu();
	      }
	    });
	    $topParentButtons.on('click', function(e) {
	      var $parent;
	      e.stopPropagation();
	      e.preventDefault();
	      $parent = $(this).parent('li');
	      if ($parent.hasClass(settings.openClass)) {
	        return close($parent);
	      } else {
	        close($parent.siblings());
	        return open($parent);
	      }
	    });
	    $parentButtons.on('click', function(e) {
	      var $parent;
	      e.stopPropagation();
	      e.preventDefault();
	      $parent = $(this).parent('li');
	      if ($parent.hasClass(settings.openClass)) {
	        return close($parent);
	      } else {
	        return open($parent);
	      }
	    });
	    $('.' + settings.buttonMoreMenuClass, $moreMenu).click(function(e) {
	      e.stopPropagation();
	      e.preventDefault();
	      if ($moreMenu.hasClass(settings.openClass)) {
	        return close($moreMenu);
	      } else {
	        return open($moreMenu);
	      }
	    });
	    return $nav.children('.' + settings.buttonRootsMenuClass).on('click', function(e) {
	      e.stopPropagation();
	      e.preventDefault();
	      if ($nav.hasClass(settings.rootsOpenClass) === true) {
	        return closeRootsMenu();
	      } else {
	        closeMenu();
	        return openRootsMenu();
	      }
	    });
	  };
	  addMoreMenu = function() {
	    $currentChildMenu = $($breadcrumb[$breadcrumb.length - 2]).find('> ul');
	    if ($currentChildMenu.length) {
	      return $currentChildMenu.append($moreMenu);
	    }
	  };
	  removeMoreMenu = function() {
	    if ($.contains(document.documentElement, $moreMenu[0])) {
	      $('> ul > li', $moreMenu).each(function() {
	        return $(this).insertBefore($moreMenu);
	      });
	      return $moreMenu.detach();
	    }
	  };
	  calcWidth = function() {
	    var $visibleMenuItems, availableSpace, firstMoreElement, lastItem, moreMenuWidth, navWidth;
	    if ($currentChildMenu.length) {
	      navWidth = 0;
	      moreMenuWidth = $moreMenu.outerWidth(true);
	      $visibleMenuItems = $currentChildMenu.children('li').not($moreMenu);
	      $visibleMenuItems.each(function() {
	        return navWidth += $(this).outerWidth(true);
	      });
	      availableSpace = $currentChildMenu.outerWidth(true) - $('>li', $currentChildMenu)[0].offsetLeft - moreMenuWidth - 50;
	      if (navWidth > availableSpace) {
	        lastItem = $visibleMenuItems.last();
	        lastItem.attr('data-width', lastItem.outerWidth(true));
	        lastItem.prependTo($('> ul', $moreMenu));
	        calcWidth();
	      } else {
	        firstMoreElement = $('> ul > li', $moreMenu).first();
	        if (navWidth + firstMoreElement.data('width') < availableSpace) {
	          firstMoreElement.insertBefore($moreMenu);
	        }
	      }
	      if ($('> ul >li', $moreMenu).length) {
	        return $moreMenu.css('display', 'block');
	      } else {
	        return $moreMenu.css('display', 'none');
	      }
	    }
	  };
	  if ($nav.data('breakpoint')) {
	    breakpoint = $nav.data('breakpoint');
	  }
	  resizer = function() {
	    if ($(window).width() <= breakpoint) {
	      $nav.removeClass(settings.largeClass);
	      closeMenu();
	      if ($.contains(document.documentElement, $moreMenu[0])) {
	        return removeMoreMenu();
	      }
	    } else {
	      $nav.addClass(settings.largeClass);
	      closeMenu();
	      if (!$.contains(document.documentElement, $moreMenu[0])) {
	        addMoreMenu();
	      }
	      return calcWidth();
	    }
	  };
	  this.makeNav = function() {
	    $current = $('li.' + settings.currentClass, $navUl);
	    addParentClasses();
	    addBreadcrumbClasses();
	    addButtons();
	    closeMenu();
	    closeRootsMenu();
	    resizer();
	    return addListeners();
	  };
	  this.makeNav();
	  $(window).on('resize', resizer);
	  return this;
	};


/***/ },
/* 1 */
/***/ function(module, exports) {

	// removed by extract-text-webpack-plugin

/***/ }
/******/ ]);