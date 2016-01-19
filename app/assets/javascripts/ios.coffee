window.is_ios = ->
  userAgent = window.navigator.userAgent
  userAgent.match(/iPad/i) || userAgent.match(/iPhone/i)

window.ios_ready = ->
  $('select').each ->
    t = $(this)
    t.addClass('browser-default')
    t_next = t.next()
    if (`typeof t_next !== 'undefined'` && t_next.is('label'))
      t.before(t_next.detach())
      t.closest('.input-field').removeClass('input-field')

  if window.navigator.userAgent.match(/iPad/i)
    $('nav').addClass('force-sidenav')
