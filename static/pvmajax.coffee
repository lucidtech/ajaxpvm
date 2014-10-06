class PVMAjax

  host =
    protocol  : window.location.protocol
    host      : window.location.host
    route     : "pvm"
    port      : "8080"

  constructor : (@username, @password, @pvmProtocol, @pvmURL, @pvmRoute, @pvmPort) ->
    @methods = ko.observableArray()
    @descriptions = new Object()
    @initialize()

  successFunction : (r) ->
    console.log 'success'
    console.log r

  errorFunction : (r) ->
    console.log 'error'
    console.log r


  initialize : () ->
    $.ajax
      dataType  : 'json'
      url       : window.location.protocol + '//' + window.location.host + '/init'
      data      :
        username  : @username
        password  : @password
        protocol  : @pvmProtocol
        host      : @pvmURL
        route     : @pvmRoute
        port      : @pvmPort
      success   : @getMethods()
#                  @loadDescriptions()


  bindDescriptions : () ->
    unless @descriptions? || @methods()?
      @methods()[m].description = m for m of @descriptions


  getMethods : (success, error) ->
    unless error
      error = @errorFunction
    unless success
      success = @successFunction
    $.ajax
      dataType  : 'json'
      url       : window.location.protocol + '//' + window.location.host + '/methods'
      success   : (r) =>
                    @methods.push new SOAPMethod m for m in r
#                    @bindDescriptions()
#                    success r
      error     : error

  loadDescriptions : () ->
    $.ajax
      dataType  : 'json'
      url       : window.location.protocol + '//' + window.location.host + '/pvm'
      data      :
        method    : 'listApi'
        params    : {}
      success   : (r) =>
#                    @descriptions = r
#                    @bindDescriptions()
                    success r
      error     : @error


window.PVMAjax = PVMAjax