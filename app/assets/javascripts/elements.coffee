'''
window.capturedElements =
  refresh: ()->
    for key of @
      console.log(key)
      delete @[key] unless key == 'refresh'
    self = @
    $('*[data-capture]').each ()->
      $element = $(@)
      self[$element.attr('data-capture')] = $element.clone()
'''
