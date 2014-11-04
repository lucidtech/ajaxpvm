class PVMAjax

  constructor : (@pvmProtocol, @pvmURL, @pvmRoute, @pvmPort, hostLocation) ->
    @username = ko.observable('')
    @password = ko.observable('')
    @loginSuccess = ko.observable(false)
    @methods  = new Object()
    @host =
      protocol  : hostLocation.protocol
      host      : hostLocation.host
      route     : "pvm"

  successFunction : (r) =>
    console.log 'success'
    @loginSuccess true

  errorFunction : (r) ->
    console.log 'error'
    console.log r


  login : () ->
    $.ajax
      dataType  : 'json'
      url       : @host.protocol + '//' + @host.host + '/init'
      data      :
        username  : @username()
        password  : @password()
        protocol  : @pvmProtocol
        host      : @pvmURL
        route     : @pvmRoute
        port      : @pvmPort
      success   : @getMethods
      error     : @errorFunction

  getMethods : () =>
    unless error
      error = @errorFunction
    unless success
      success = @successFunction
    $.ajax
      dataType  : 'json'
      url       : @host.protocol + '//' + @host.host + '/methods'
      success   : (r) =>
                    @methods[m.method] = new SOAPMethod m, @host for m in r
                    @successFunction r
      error     : @errorFunction

window.PVMAjax = PVMAjax
#window.pvm = new PVMAjax 'https', '192.168.92.146', 'soap', '8080'
