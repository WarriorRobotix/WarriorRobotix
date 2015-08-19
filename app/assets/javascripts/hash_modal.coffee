window.hash_modal=
  refresh: ()->
    @bindings = []
    @loadings = {}
    self = @
    $('.hash-modal').each ->
      loader = $(this)
      format = loader.attr('data-format')
      unless format?
        format = loader.attr('href')
        loader.attr('data-format',format)
      self.bind loader.text(), format, loader
    self.hashchange()
    return

  hashchange: ()->
    hash = location.hash.slice(1)
    modal = $(location.hash + '.modal').first()
    if (modal.length)
      modal.openModal()
    else
      @loadHash(hash)
    return

  loadHash: (hash) ->
    match = null
    for k,v of @bindings
      if hash.indexOf(v[0]) == 0
        match = k
        break

    unless match == null
      id = hash.slice(@bindings[match][0].length)
      url = @bindings[match][1].replace('$', id)
      if @loadings[url] != true
        loader = @bindings[match][2]
        loader.attr('href', url)

        self = @
        self.loadings[url] = true
        loader.one 'ajax:complete', (xhr, status) ->
          self.loadings[url] = false

        loader.click();
    return

  bind: (prefix,urlFormat,jqObj) ->
    @bindings.push [prefix,urlFormat, jqObj]
    return
