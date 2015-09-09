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
  $current = $()
  $parents = $()
  $breadcrumb = $()
  $currentChildMenu = $()
  $buttonParents = $()
  $moreMenu = $()
  # TODO Should we use a button element?
  $button = '<span class="'+settings.buttonClass+'"><i></i></span>'
  $moreMenu = $('<li class="more" data-width="80"><span class="more__button"><i></i></span><ul class="more__popup"></ul></li>')

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
    if $navUl.children('li').length > 1
      $nav.addClass(settings.multipleRootsClass)
      #$navUl.before($($button).addClass(settings.buttonRootsMenuClass))
    $navUl.after($($button).addClass(settings.buttonMenuClass))
    $buttonParents = $parents.not($root).append($button)

  getCloseElements = ->
    $nav.add($nav.children('.'+settings.buttonMenuClass)).add($parents).add($parents.children('.'+settings.buttonClass))
  getOpenElements = ->
    $nav.add($nav.children('.'+settings.buttonMenuClass)).add($breadcrumb).add($breadcrumb.children('.'+settings.buttonClass))

  closeMenu = ->
    close(getCloseElements())
    if $nav.hasClass(settings.largeClass)
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
    $nav.children('.'+settings.buttonRootsMenuClass).removeClass(settings.rootsClosedClass).addClass(settings.rootsOpenClass)

  addListeners = ->
    # Toggle touch for nav menu
    $('> .'+settings.buttonMenuClass, $nav).on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      if $nav.hasClass(settings.openClass)
        closeMenu()
      else
        closeRootsMenu()
        openMenu()
    )
    # Toggle for subMenus
    $('.'+settings.buttonClass,$buttonParents).on('click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      # remove openClass from all elements that are not current
      $parent = $(@).parent('.'+settings.parentClass)
      if $parent.hasClass(settings.openClass)
        close($parent.add($parent.find('.'+settings.openClass)))
      else
        open($parent.add($(@)))
    )
    # Toggle moreMenu
    $moreMenu.click((e) ->
      e.stopPropagation()
      e.preventDefault()
      $('.more__popup').toggle()
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

  @.makeNav = ->
    $current = $('li.'+settings.currentClass, $navUl)
    addParentClasses()
    addBreadcrumbClasses()
    addButtons()
    closeMenu()
    closeRootsMenu()
    # Call once to set
    resizer()
    addListeners()


  addMoreMenu = ->
    $currentChildMenu = $($breadcrumb[$breadcrumb.length - 2]).find('> ul')
    if $currentChildMenu.length
      $currentChildMenu.append($moreMenu)

  removeMoreMenu = ->
    if $('.more').length > 0
      $('.more__popup > li').each(->
        $(@).insertBefore($moreMenu)
      )
      $moreMenu.detach()

  calcWidth = ->
    if $currentChildMenu.length
      navWidth = 0;
      moreMenuWidth = $moreMenu.outerWidth(true)
      $visibleMenuItems = $currentChildMenu.find(' > li:not(.more)')
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
        firstMoreElement = $('ul > li', $moreMenu).first();
        if navWidth + firstMoreElement.data('width') < availableSpace
          firstMoreElement.insertBefore($moreMenu)

      if $('> ul >li', $moreMenu).length
        $moreMenu.css('display','inline-block')
      else
        $moreMenu.css('display','none')

  # Get the breakpoint set with data-breakpoint
  if $nav.data('breakpoint') then breakpoint = $nav.data('breakpoint')

  resizer = ->
    if $(window).width() <= breakpoint
      $nav.removeClass(settings.largeClass)
      if $('.more').length > 0
        removeMoreMenu()
    else
      $nav.addClass(settings.largeClass)
      if $nav.hasClass(settings.closedClass)
        if $('.more').length == 0
          addMoreMenu()
        calcWidth()

  @.makeNav()
  # Call on browser resize
  $(window).on('resize', resizer)
  @
