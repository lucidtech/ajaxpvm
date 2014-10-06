class SOAPMethod

  constructor : (soapMethod) ->
    @name   = soapMethod.method
    @params = new Array
    @params.push name: name, type: type for {name, type} in soapMethod.takes
    @description = ''
    @result = ko.observable()

  successFunction : (r) =>
    console.log 'success'
    @result r

  errorFunction : (r) =>
    console.log 'error'
    console.log r

  call : (context, event, paramsObject, success, error) ->
    unless error
      error = @errorFunction
    unless success
      success = @successFunction

    $.ajax
      dataType  : 'json'
      url       : window.location.protocol + '//' + window.location.host + '/pvm'
      data      :
        method    : @name
        params    : paramsObject
      success   : success
      error     : error

window.SOAPMethod = SOAPMethod