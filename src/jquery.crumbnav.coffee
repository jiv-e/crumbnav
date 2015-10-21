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
      'navClass': 'c-nav',
      'titleClass': 'title',
      'topModifier': '-top',
      'itemClass': 'c-item',
      'openClass': 'cn-open',
      'closedClass': 'cn-close',
      'rootsOpenClass': 'cn-open-roots',
      'rootsClosedClass': 'cn-close-roots',
      'firstLevelClass': 'crumbnav--first-level',
      'rootClass': 'crumbnav__root',
      'currentClass': 'active'
      'moreMenuClass': 'c-more',
      'breadcrumbClass': 'crumbnav-crumb',
      'buttonClass': 'c-button',
      'mainModifier': '-main',
      'parentModifier': '-parent',
      'moreModifier': '-more',
      'rootsModifier': '-roots',
      'largeModifier': '-large',
      'hoverIntent': false,
      'hoverIntentTimeout': 150,
      'calcItemWidths': false,
      'hover': false,
      'titleText': 'Menu',
    },
    options
  )

  @.options = settings
  $nav = $(@)
  # TODO Add support for multiple menus? At the moment breaks javascript execution!
  $navUl = if $nav.children('ul').length == 1 then $nav.children('ul') else alert("Unsupported number of ul's inside the navigation!");
  $current = $('li.'+settings.currentClass, $navUl)
  if $current.length > 1 then alert('Multiple active elements in the menu! There should be only one.')
  $root = $()
  $topParents = $()
  $parents = $()
  $breadcrumb = $()
  $breadcrumbLength = 0
  $currentChildMenu = $()
  $topParentButtons = $()
  $parentButtons = $()
  $moreMenu = $()
  # TODO Should we use a button element?
  $button = $('<span class="'+settings.buttonClass+'"><i></i></span>')
  $moreMenu = $('<li class="'+settings.moreMenuClass+'"><ul class="'+settings.moreMenuClass+'-popup"></ul></li>').append($button.clone().addClass(settings.moreModifier))

  # Add title if not present
  if $nav.children('.'+settings.titleClass).length == 0
    $nav.prepend('<div class="'+settings.titleClass+'">'+settings.titleText+'</div>')

  addBreadcrumbClasses = ->
    # Breadcrumb trail
    $currentParents = $current.parentsUntil($navUl, 'li')
    $breadcrumb = $currentParents.add($current)
    $breadcrumbLength = $breadcrumb.length
    $breadcrumb
    .addClass(settings.breadcrumbClass)
    .each (index) ->
      $(@).addClass('-out-'+index+' -in-'+($breadcrumbLength - index - 1))

    # Breadcrumb length modifier class.
    $nav.addClass('-length-'+$breadcrumbLength);

    # Root class
    # If current element exists and is not top level item.
    if $current.length && $breadcrumbLength > 1
    then $root = $navUl.children('.'+settings.breadcrumbClass).addClass(settings.rootClass)
    else $root = $nav.addClass(settings.firstLevelClass)

  # Set item classes in the markup
  addItemClasses = ->
    $navUl.find("li").addClass(settings.itemClass)

  # Set parent classes in the markup
  addParentClasses = ->
    $navUl.find(">li").each ->
      if $(@).has("ul").length
        $(@).addClass(settings.topModifier)
        $topParents = $topParents.add($(@))
    $navUl.find("ul li").each ->
      if $(@).has("ul").length
        $(@).addClass(settings.parentModifier)
        $parents = $parents.add($(@))

  # Add in touch buttons
  addButtons = ->
    if $navUl.children('li').length > 1
      $nav.addClass(settings.multipleRootsClass)
    $navUl.before($button.clone().addClass(settings.rootsModifier))
    $navUl.after($button.clone().addClass(settings.mainModifier))
    $topParentButtons = $button.clone().addClass(settings.topModifier).appendTo($topParents)
    $parentButtons = $button.clone().addClass(settings.parentModifier).appendTo($parents)

  getCloseElements = ->
    $nav.add($parents).add($topParents)
  getOpenElements = ->
    if $breadcrumbLength = 1
    then $nav.add($breadcrumb)
    else $nav.add($breadcrumb).not($current)

  closeMenu = ->
    close(getCloseElements())
    if $nav.hasClass(settings.largeModifier)
      addMoreMenu()
      calcWidth()

  openMenu = ->
    open(getOpenElements())
    removeMoreMenu()

  open = (elements) -> elements.removeClass(settings.closedClass).addClass(settings.openClass)
  close = (elements) -> elements.removeClass(settings.openClass).addClass(settings.closedClass)

  closeRootsMenu = ->
    $nav.removeClass(settings.rootsOpenClass).addClass(settings.rootsClosedClass)
    $nav.find('.'+settings.rootsOpenClass).removeClass(settings.rootsOpenClass).addClass(settings.rootsClosedClass)
  openRootsMenu = ->
    $nav.removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass)
    .children('ul').children('li').removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass)
    $nav.children('.'+settings.rootsModifier).removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass)

  addListeners = ->
    # Toggle touch for nav menu
    $('> .'+settings.mainModifier, $nav).on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      if $nav.hasClass(settings.openClass)
        closeMenu()
      else
        closeRootsMenu()
        openMenu()
    )
    # Toggle for top parent menus
    $topParentButtons.on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      # remove openClass from all elements that are not current
      $parent = $(@).parent('li')
      if $parent.hasClass(settings.openClass)
        close($parent)
      else
        close($parent.siblings())
        open($parent)
    )
    # Toggle for parent menus
    $parentButtons.on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      $parent = $(@).parent('li')
      if $parent.hasClass(settings.openClass)
        close($parent)
      else
        open($parent)
    )
    # Toggle moreMenu
    $('.'+settings.moreModifier,$moreMenu).click((e) ->
      e.stopPropagation()
      e.preventDefault()
      if $moreMenu.hasClass(settings.openClass)
        close($moreMenu)
      else
        open($moreMenu)
    )

    # Toggle touch for roots menu
    $nav.children('.'+settings.rootsModifier).on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      if $nav.hasClass(settings.rootsOpenClass) is true
        closeRootsMenu()
      else
        closeMenu()
        openRootsMenu()
    )

  addMoreMenu = ->
    $currentChildMenu = $($breadcrumb[$breadcrumb.length - 2]).find('> ul')
    if $currentChildMenu.length
      $currentChildMenu.append($moreMenu)

  removeMoreMenu = ->
    if $.contains(document.documentElement, $moreMenu[0])
      $('> ul > li', $moreMenu).each(->
        $(@).insertBefore($moreMenu)
      )
      $moreMenu.detach()

  calcWidth = ->
    if $currentChildMenu.length
      navWidth = 0;
      moreMenuWidth = $moreMenu.outerWidth(true)
      $visibleMenuItems = $currentChildMenu.children('li').not($moreMenu)
      $visibleMenuItems.each(->
        navWidth += $(@).outerWidth( true )
      )
      availableSpace = $currentChildMenu.outerWidth(true) - $('>li',$currentChildMenu)[0].offsetLeft - moreMenuWidth - 50;

      if (navWidth > availableSpace)
        lastItem = $visibleMenuItems.last()
        lastItem.attr('data-width', lastItem.outerWidth(true))
        lastItem.prependTo($('> ul', $moreMenu))
        calcWidth()
      else
        firstMoreElement = $('> ul > li', $moreMenu).first();
        if navWidth + firstMoreElement.data('width') < availableSpace
          firstMoreElement.insertBefore($moreMenu)

      if $('> ul >li', $moreMenu).length
        $moreMenu.css('display','block')
      else
        $moreMenu.css('display','none')

  # Get the breakpoint set with data-breakpoint
  if $nav.data('breakpoint') then breakpoint = $nav.data('breakpoint')

  resizer = ->
    if $(window).width() <= breakpoint
      $nav.removeClass(settings.largeModifier)
      closeMenu()
      if $.contains(document.documentElement, $moreMenu[0])
        removeMoreMenu()
    else
      $nav.addClass(settings.largeModifier)
      closeMenu()
      if not $.contains(document.documentElement, $moreMenu[0])
        addMoreMenu()
      calcWidth()

  @.makeNav = ->
    $current = $('li.'+settings.currentClass, $navUl)
    addItemClasses()
    addParentClasses()
    addBreadcrumbClasses()
    addButtons()
    closeMenu()
    closeRootsMenu()
    # Call once to set
    resizer()
    addListeners()

  @.makeNav()
  # Call on browser resize
  $(window).on('resize', resizer)
  @
