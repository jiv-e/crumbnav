$ = jQuery

$.fn.crumbnavDemo = (options) ->

  $nav = $(@)
  document.nav = $nav
  $nav.crumbnav(options);

  $nav.clickHandler = (e) ->
    e.preventDefault()
    $nav.find('*').unbind('click')
    $nav.refreshNav($(@))
    $('a').on('click', $nav.clickHandler)
    return false;

  $('a').on('click', $nav.clickHandler)

  @
