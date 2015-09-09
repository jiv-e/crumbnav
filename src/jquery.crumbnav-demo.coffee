$ = jQuery

$.fn.crumbnavDemo = (options) ->

  $nav = $(@)
  document.nav = $nav
  $nav.crumbnav(options);

  $nav.clickHandler = (e) ->
    e.preventDefault()
    $nav.find('*').unbind('click')
    removeMoreMenu()
    removeButtons()
    $nav.find('> ul *').removeClass()
    $(e.target).parent('li').addClass($nav.options.currentClass)
    $nav.makeNav()
    $('a').on('click', $nav.clickHandler)
    return false;

  $('a').on('click', $nav.clickHandler)

  removeMoreMenu = ->
    $moreMenu = $('.more')
    if $moreMenu.length
      $('.more__popup > li').each(->
        $(@).insertBefore($moreMenu)
      )
      $moreMenu.detach()

  removeButtons = ->
    $('.'+$nav.options.buttonClass).remove()

  @
