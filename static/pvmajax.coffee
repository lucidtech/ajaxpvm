class PVMAjax

  host =
    protocol  : window.location.protocol
    host      : window.location.host
    route     : "pvm"
    port      : "8080"

  constructor : (@pvmProtocol, @pvmURL, @pvmRoute, @pvmPort) ->
    @username = ko.observable('')
    @password = ko.observable('')
    @methodNames = ko.observableArray()
    @methods  = new Object()
    @descriptions = new Object()

  successFunction : (r) ->
    console.log 'success'
    console.log r

  errorFunction : (r) ->
    console.log 'error'
    console.log r


  login : () ->
    $.ajax
      dataType  : 'json'
      url       : window.location.protocol + '//' + window.location.host + '/init'
      data      :
        username  : @username()
        password  : @password()
        protocol  : @pvmProtocol
        host      : @pvmURL
        route     : @pvmRoute
        port      : @pvmPort
      success   : () =>
                    @getMethods()
                    @loadDescriptions()


  bindDescriptions : () ->
    if Object.keys(@descriptions).length != 0 && @methodNames().length != 0
      @methods[m].description @descriptions[m].split('\n') for m in @methodNames()


  getMethods : (success, error) ->
    unless error
      error = @errorFunction
    unless success
      success = @successFunction
    $.ajax
      dataType  : 'json'
      url       : window.location.protocol + '//' + window.location.host + '/methods'
      success   : (r) =>
                    @methods[m.method] = new SOAPMethod m for m in r
                    @methodNames Object.keys(@methods)
                    @bindDescriptions()
                    success r
      error     : error

  loadDescriptions : () ->
    $.ajax
      dataType  : 'json'
      url       : window.location.protocol + '//' + window.location.host + '/pvm'
      data      :
        method    : 'listApi'
        params    : {}
      success   : (r) =>
                    @descriptions = r[2]
                    @bindDescriptions()
#                    success r
      error     : @error


window.PVMAjax = PVMAjax