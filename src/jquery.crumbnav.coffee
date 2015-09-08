###
	crumbnav.js 0.1

  Created by Juho Viitasalo

	Based on flexnav by Jason Weaver http://jasonweaver.name
	Released under http://unlicense.org/

###

# TODO Hide contextual menu button (+) when there's only on child in the submenu

require('./sass/crumbnav.scss')


# Use local alias for $.noConflict() compatibility
$ = jQuery

$('html').removeClass('no-js').addClass('js')

$ ->
  #attachFastClick = Origami.fastclick;
  #attachFastClick(document.body);

$.fn.crumbnav = (options) ->
  settings = $.extend({
    'navClass': 'crumbnav',
    'navTitleClass': 'crumbnav__title',
    'parentClass': 'crumbnav__parent',
    'openClass': 'cn-open',
    'closedClass': 'cn-close',
    'rootsOpenClass': 'cn-open-roots',
    'rootsClosedClass': 'cn-close-roots',
    'rootClass': 'crumbnav__root',
    'currentClass': 'active',
    'breadcrumbClass': 'crumbnav-crumb',
    'buttonClass': 'crumbnav__button',
    'buttonMenuClass': 'crumbnav__button--menu',
    'buttonRootsMenuClass': 'crumbnav__button--root-menu',
    'multipleRootsClass': 'crumbnav--multiple-roots',
    'largeClass': 'crumbnav--large',
    'hoverIntent': false,
    'hoverIntentTimeout': 150,
    'calcItemWidths': false,
    'hover': false,
    #FlexMenu
    'threshold' : 2,
    'cutoff' : 2,
    'linkText' : 'More',
    'linkTitle' : 'View More',
    'linkTextAll' : 'Menu',
    'linkTitleAll' : 'Open/Close Menu',
    'showOnHover' : true,
    'undo' : false},
    options
  )

  @.options = settings
  $nav = $(@)
  # TODO Add support for multiple menus? At the moment breaks javascript execution!
  $navUl = if $nav.children('ul').length == 1 then $nav.children('ul') else alert("Unsupported number of ul's inside the navigation!");
  $current = $('li.'+settings.currentClass, $navUl)
  if $current.length > 1 then alert('Multiple active elements in the menu! There should be only one.')
  $root = $()
  $parents = $()
  $breadcrumb = $()
  $moreMenu = $()
  $morePopup = $()
  # TODO Should we use a button element?
  button = '<span class="'+settings.buttonClass+'"><i></i></span>'

  # Add title if not present
  if $nav.children('.'+settings.navTitleClass).length == 0
    $nav.prepend('<div class="'+settings.navTitleClass+'">Menu</div>')

  addBreadcrumbClasses = ->
    # Breadcrumb trail
    $currentParents = $current.parentsUntil($navUl, 'li')
    $breadcrumb = $currentParents.add($current)
    $breadcrumbCount = $breadcrumb.length
    $breadcrumb
      .addClass(settings.breadcrumbClass)
      .each (index) ->
        $(@).addClass(settings.breadcrumbClass+'-out-'+index+' '+settings.breadcrumbClass+'-in-'+($breadcrumbCount - index - 1))

    # Root class
    $current = $('li.'+settings.currentClass, $navUl)
    if $current.length == 0
    then $root = $nav.addClass(settings.rootClass)
    else $root = $navUl.children('.'+settings.parentClass+'.'+settings.breadcrumbClass).addClass(settings.rootClass)

  # Set parent classes in the markup
  addParentClasses = ->
    $navUl.find("li").each ->
      if $(@).has("ul").length
        $(@).addClass(settings.parentClass)
        $parents = $parents.add($(@))

  # Add in touch buttons
  addButtons = ->
    if $navUl.children('li').length > 1 && $current.length == 0
      $nav.addClass(settings.multipleRootsClass)
      #$navUl.before($(button).addClass(settings.buttonRootsMenuClass))
    $navUl.after($(button).addClass(settings.buttonMenuClass))
    $buttons = $parents.not($root).append(button)

  getOpenCloseElements = ->
    $nav.removeClass(settings.openClass).addClass(settings.closedClass)
    .children('.'+settings.buttonMenuClass).removeClass(settings.openClass).addClass(settings.closedClass)
    $breadcrumb.removeClass(settings.openClass).addClass(settings.closedClass)
    .children('.'+settings.buttonClass).removeClass(settings.openClass).addClass(settings.closedClass)

  closeMenu = ->
    getOpenCloseElements()
    $nav.removeClass(settings.openClass).addClass(settings.closedClass)
    .children('.'+settings.buttonMenuClass).removeClass(settings.openClass).addClass(settings.closedClass)
    $breadcrumb.removeClass(settings.openClass).addClass(settings.closedClass)
    .children('.'+settings.buttonClass).removeClass(settings.openClass).addClass(settings.closedClass)

  openMenu = ->
    $('.'+settings.closedClass).removeClass(settings.closedClass).addClass(settings.openClass)

  closeRootsMenu = ->
    $nav.removeClass(settings.rootsOpenClass).addClass(settings.rootsClosedClass)
    $nav.find('.'+settings.rootsOpenClass).removeClass(settings.rootsOpenClass).addClass(settings.rootsClosedClass)
  openRootsMenu = ->
    $nav.removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass)
    .children('ul').children('li').removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass)
    $nav.children('.'+settings.buttonRootsMenuClass).removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass)

  addListeners = ->
    # Toggle touch for nav menu
    $nav.children('.'+settings.buttonMenuClass).on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      if $nav.hasClass(settings.openClass) is true
        closeMenu()
      else
        closeRootsMenu()
        openMenu()
    )

    # Toggle touch for roots menu
    ###
    $nav.children('.'+settings.buttonRootsMenuClass).on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      if $nav.hasClass(settings.rootsOpenClass) is true
        closeRootsMenu()
      else
        closeMenu()
        openRootsMenu()
    )
    ###

    # Toggle for sub-menus
    $('.blaa'+settings.buttonClass).on('click', (e) ->
      $parentLi = $(@).parent('.'+settings.parentClass)
      # remove openClass from all elements that are not current
      if $navUl.hasClass(settings.largeClass) is true
        $(@).parent('.'+settings.parentClass).siblings().removeClass(settings.openClass)
      $parentLi.toggleClass(settings.openClass)
    )

    # Toggle for subMenus
    $parents.children('.'+settings.buttonClass).on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      # remove openClass from all elements that are not current
      $parent = $(@).parent('.'+settings.parentClass)
      if $navUl.hasClass(settings.largeClass) is true
        $parent.siblings().removeClass(settings.openClass)
      if $parent.hasClass(settings.openClass)
        $parent.removeClass(settings.openClass)
        $parent.find('.'+settings.openClass).removeClass(settings.openClass)
      else
        $parent.addClass(settings.openClass)
        $(@).addClass(settings.openClass)
        # If this contains the current element on the next level open that too
        $current.addClass(settings.openClass).children('.'+settings.buttonClass).addClass(settings.openClass)
    )

  # Sub ul's should have a class of 'open' if an element has focus
  $navUl.find('.blaa'+settings.parentClass + ' *').focus ->
    # remove class of open from all elements that are not focused
    $(@).parent('.'+settings.parentClass).parent().find(".open").not(@).removeClass("open").hide()
    # add class of open to focused ul
    $(@).parent('.'+settings.parentClass).find('>ul').addClass("open").show()

  removeBreadcrumbClasses = ->
    $current.removeClass(settings.currentClass)
    $root.removeClass(settings.rootClass)
    $nav.find('.'+settings.openClass).removeClass(settings.openClass)
    re = new RegExp(settings.breadcrumbClass+'[^ ]*','g')
    $navUl.find('.'+settings.breadcrumbClass).each ->
      $(@)[0].className = $(@)[0].className.replace(re, '')

  @.refreshNav = ($newActive) ->
    removeBreadcrumbClasses()
    $newActive.parent('li').addClass(settings.currentClass)
    $current = $('li.'+settings.currentClass, $navUl)
    addBreadcrumbClasses()
    #TODO Make DRY!
    if $navUl.children('li').length > 1 && $current.length == 1
      $nav.addClass(settings.multipleRootsClass)
      ###
      if $('.'+settings.buttonRootsMenuClass).length == 0
        $navUl.before($(button).addClass(settings.buttonRootsMenuClass))
      ###
    closeRootsMenu()
    closeMenu()
    removeMoreMenuPopup()
    addMoreMenuPopup()
    calcWidth()
    addListeners()

  refreshFlexMenu = ->
    removeFlexMenu()
    if $nav.hasClass(settings.largeClass)
      addFlexMenu()

  addFlexMenu = ->
    $moreMenu = $($breadcrumb[$breadcrumb.length - 2]).find('> ul')
    $horizontalMenuItems = $moreMenu.find('> li')
    $moreItems = $horizontalMenuItems.filter((index) ->
      # Check the element is floated to the left.
      return $horizontalMenuItems[index].offsetTop > 0
    )
    if $moreItems.length
      $moreMenu.append($('<li class="flexMenu-viewMore"><span class="more-menu-button"><i></i></span></li>'))
      $popup = $('<ul class="flexMenu-popup" style="display:none;"></ul>')

      $moreItems.prependTo($popup)

      $('.flexMenu-viewMore').append($popup)

      $('.more-menu-button').click((e) ->
        $('.flexMenu-popup').toggle()
        e.preventDefault()
      )

  addMoreMenuPopup = ->
    $moreMenu = $($breadcrumb[$breadcrumb.length - 2]).find('> ul')
    $morePopup = $('<li class="more" data-width="80"><span>More</span><ul></ul></li>')
    $moreMenu.append($morePopup)

  removeMoreMenuPopup = ->
    if $moreMenu.length
      $('> ul > li', $morePopup).each(->
        @.insertBefore($morePopup)
      )
      $morePopup.remove()

  calcWidth = ->
    navWidth = 0;
    popupWidth = $morePopup.outerWidth(true)
    $visibleMenuItems = $moreMenu.find(' > li:not(.more)')
    $visibleMenuItems.each(->
      navWidth += $(@).outerWidth( true )
    )
    availableSpace = $moreMenu.outerWidth(true) - $('>li',$moreMenu)[0].offsetLeft - popupWidth - 40;

    if (navWidth > availableSpace)
      lastItem = $visibleMenuItems.last()
      lastItem.attr('data-width', lastItem.outerWidth(true))
      lastItem.prependTo($('> ul', $morePopup))
      calcWidth()
    else
      firstMoreElement = $('ul > li', $morePopup).first();
      if navWidth + firstMoreElement.data('width') < availableSpace
        firstMoreElement.insertBefore($morePopup)

    if $('> ul >li', $morePopup).length
      $morePopup.css('display','inline-block')
    else
      $morePopup.css('display','none')

  # Get the breakpoint set with data-breakpoint
  if $nav.data('breakpoint') then breakpoint = $nav.data('breakpoint')

  resizer = ->
    if $(window).width() <= breakpoint
      $nav.removeClass(settings.largeClass)
    else if $(window).width() > breakpoint
      $nav.addClass(settings.largeClass)
    if $morePopup.length
      calcWidth()

  # Call on browser resize
  $(window).on('resize', resizer)
  # Call once to set
  resizer()
  addParentClasses()
  addButtons()
  @.refreshNav($('>a', $current))
  @
