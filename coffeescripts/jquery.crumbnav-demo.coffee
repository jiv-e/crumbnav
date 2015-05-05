$ = jQuery

$.fn.crumbnavDemo = (options) ->

  $nav = $(@)

  $nav.crumbnav();

  $nav.clickHandler = (e) ->
    e.preventDefault()
    $nav.find('*').unbind('click')
    $nav.refreshNav($(@))
    $('a').on('click', $nav.clickHandler)
    return false;

  $('a').on('click', $nav.clickHandler)

  @
