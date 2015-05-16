###
	crumbnav.js 0.1

  Created by Juho Viitasalo

	Based on flexnav by Jason Weaver http://jasonweaver.name
	Released under http://unlicense.org/

###

# TODO Hide contextual menu button (+) when there's only on child in the submenu

# Use local alias for $.noConflict() compatibility
$ = jQuery

$ ->
  #attachFastClick = Origami.fastclick;
  #attachFastClick(document.body);

$.fn.crumbnav = (options) ->
  settings = $.extend
    'navClass': 'crumbnav',
    'navTitleClass': 'crumbnav__title',
    'parentClass': 'crumbnav__parent',
    'openClass': 'sn-open',
    'rootsOpenClass': 'sn-open-roots',
    'rootClass': 'crumbnav__root',
    'currentClass': 'active',
    'breadcrumbClass': 'crumbnav-crumb',
    'buttonClass': 'crumbnav__button',
    'buttonMenuClass': 'crumbnav__button--menu',
    'buttonRootsMenuClass': 'crumbnav__button--root-menu',
    'multipleRootsClass': 'crumbnav--multiple-roots',
    'largeClass': 'lg-screen',
    'smallClass': 'sm-screen',
    'hoverIntent': false,
    'hoverIntentTimeout': 150,
    'calcItemWidths': false,
    'hover': true
    options

  $nav = $(@)
  # TODO Add support for multiple menus? At the moment breaks javascript execution!
  $navUl = if $nav.children('ul').length == 1 then $nav.children('ul') else alert("Unsupported number of ul's inside the navigation!");
  $current = $('li.'+settings.currentClass, $navUl)
  if $current.length > 1 then alert('Multiple active elements in the menu! There should be only one.')
  $root = $()
  $parents = $()
  $breadcrumb = $()
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

  addBreadcrumbClasses()

  # Set parent classes in the markup
  addParentClasses = ->
    $navUl.find("li").each ->
      if $(@).has("ul").length
        $(@).addClass(settings.parentClass)
        $parents = $parents.add($(@))

  addParentClasses()

  # Set some classes in the markup
  addBasicClasses = ->
    $nav.addClass('with-js')
    $current = $('li.'+settings.currentClass, $navUl)
    if $current.length == 0
    then $root = $nav.addClass(settings.rootClass)
    else $root = $navUl.children('.'+settings.parentClass+'.'+settings.breadcrumbClass).addClass(settings.rootClass)

  addBasicClasses()


  # Add in touch buttons
  addButtons = ->
    if $navUl.children('li').length > 1 && $current.length == 0
      $nav.addClass(settings.multipleRootsClass)
      $navUl.before($(button).addClass(settings.buttonRootsMenuClass))
    $navUl.after($(button).addClass(settings.buttonMenuClass))
    $buttons = $parents.not($root).append(button)

  addButtons()

  # Find the number of top level nav items and set widths
  if settings.calcItemWidths is true
    $top_nav_items = $navUl.find('>li')
    count = $top_nav_items.length
    nav_width = 100 / count
    nav_percent = nav_width+"%"

  # Get the breakpoint set with data-breakpoint
  if $navUl.data('breakpoint') then breakpoint = $navUl.data('breakpoint')

  # Functions for hover support
  showMenu = ->
    if $navUl.hasClass(settings.largeClass) is true and settings.hover is true
      $(@).find('>ul')
       .addClass(settings.openClass)
  resetMenu = ->
    if $navUl.hasClass(settings.largeClass) is true and $(@).find('>ul').hasClass(settings.openClass) is true and settings.hover is true
      $(@).find('>ul')
        .removeClass(settings.openClass)

  # Changing classes depending on viewport width and adding in hover support
  resizer = ->
    if $(window).width() <= breakpoint
      $navUl.removeClass(settings.largeClass).addClass(settings.smallClass)
      if settings.calcItemWidths is true
        $top_nav_items.css('width','100%')
      $($navUl, $buttons).removeClass(settings.openClass)
      # Toggle nav menu closed for one pager after anchor clicked
      $('.one-page li a').on( 'click', ->
        $navUl.removeClass(settings.openClass)
      )
    else if $(window).width() > breakpoint
      $navUl.removeClass(settings.smallClass).addClass(settings.largeClass)
      if settings.calcItemWidths is true
        $top_nav_items.css('width',nav_percent)
      # Make sure navigation is closed when going back to large screens
      $navUl.removeClass(settings.openClass).find('.'+settings.parentClass).on()
      $('.'+settings.parentClass).find('ul').removeClass(settings.openClass)
      resetMenu()
      if settings.hoverIntent is true
        # Requires hoverIntent jquery plugin http://cherne.net/brian/resources/jquery.hoverIntent.html
        $('.'+settings.parentClass).hoverIntent(
          over: showMenu,
          out: resetMenu,
          timeout: settings.hoverIntentTimeout
        )
      else if settings.hoverIntent is false
        $('.'+settings.parentClass).on('mouseenter', showMenu).on('mouseleave', resetMenu)

  # Set navigation element for this instantiation
  #$('.'+settings.navClass).data('navEl', $nav)

  closeMenu = ->
    $nav.removeClass(settings.openClass)
    $nav.find('.'+settings.openClass).removeClass(settings.openClass)

  openMenu = ->
    $nav.addClass(settings.openClass)
    .children('.'+settings.buttonMenuClass).addClass(settings.openClass)
    $breadcrumb.addClass(settings.openClass)
    .children('.'+settings.buttonClass).addClass(settings.openClass)

  closeRootsMenu = ->
    $nav.removeClass(settings.rootsOpenClass)
    $nav.find('.'+settings.rootsOpenClass).removeClass(settings.rootsOpenClass)
  openRootsMenu = ->
    $nav.addClass(settings.rootsOpenClass)
    .children('ul').children('li').addClass(settings.rootsOpenClass)
    $nav.children('.'+settings.buttonRootsMenuClass).addClass(settings.rootsOpenClass)

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
    $nav.children('.'+settings.buttonRootsMenuClass).on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      if $nav.hasClass(settings.rootsOpenClass) is true
        closeRootsMenu()
      else
        closeMenu()
        openRootsMenu()
    )

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

  addListeners()

  # Sub ul's should have a class of 'open' if an element has focus
  $navUl.find('.blaa'+settings.parentClass + ' *').focus ->
    # remove class of open from all elements that are not focused
    $(@).parent('.'+settings.parentClass).parent().find(".open").not(@).removeClass("open").hide()
    # add class of open to focused ul
    $(@).parent('.'+settings.parentClass).find('>ul').addClass("open").show()

  # Call once to set
  resizer()

  # Call on browser resize
  $(window).on('resize', resizer)

  removeBreadcrumbClasses = ->
    $current.removeClass(settings.currentClass)
    $root.removeClass(settings.rootClass)
    $nav.find('.'+settings.openClass).removeClass(settings.openClass)
    re = new RegExp(settings.breadcrumbClass+'[^ ]*','g')
    $navUl.find('.'+settings.breadcrumbClass).each ->
      $(@)[0].className = $(@)[0].className.replace(re, '')

  @.refreshNav = ($newActive) ->
    removeBreadcrumbClasses()
    $nav.removeClass(settings.openClass)
    $newActive.parent('li').addClass(settings.currentClass)
    $current = $('li.'+settings.currentClass, $navUl)
    addBreadcrumbClasses()
    addBasicClasses()
    #TODO Make DRY!
    if $navUl.children('li').length > 1 && $current.length == 1
      $nav.addClass(settings.multipleRootsClass)
      if $('.'+settings.buttonRootsMenuClass).length == 0
        $navUl.before($(button).addClass(settings.buttonRootsMenuClass))
    addListeners()
