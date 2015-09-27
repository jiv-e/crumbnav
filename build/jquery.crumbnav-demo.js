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
/***/ function(module, exports) {

	var $;

	$ = jQuery;

	$.fn.crumbnavDemo = function(options) {
	  var $nav, removeButtons, removeMoreMenu;
	  $nav = $(this);
	  document.nav = $nav;
	  $nav.crumbnav(options);
	  $nav.clickHandler = function(e) {
	    e.preventDefault();
	    $nav.find('*').unbind('click');
	    removeMoreMenu();
	    removeButtons();
	    $nav.find('> ul *').removeClass();
	    $(e.target).parent('li').addClass($nav.options.currentClass);
	    $nav.makeNav();
	    $('a').on('click', $nav.clickHandler);
	    return false;
	  };
	  $('a').on('click', $nav.clickHandler);
	  removeMoreMenu = function() {
	    var $moreMenu;
	    $moreMenu = $('.' + $nav.options.moreMenuClass);
	    if ($moreMenu.length) {
	      $('> ul > li', $moreMenu).each(function() {
	        return $(this).insertBefore($moreMenu);
	      });
	      return $moreMenu.detach();
	    }
	  };
	  removeButtons = function() {
	    return $('.' + $nav.options.buttonClass).remove();
	  };
	  return this;
	};


/***/ }
/******/ ]);