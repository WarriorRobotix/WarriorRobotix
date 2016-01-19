window.is_ie = ->
  userAgent = window.navigator.userAgent
  userAgent.match(/MSIE/i) || userAgent.match(/Trident/i)

window.ie_ready = ->
  $('nav .dropdown-button .arrow-down').replaceWith('&#x25BE;')
