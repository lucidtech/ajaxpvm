class SOAPMethod

  constructor : (soapMethod) ->
    @name   = ko.observable soapMethod.method
    @params = ko.observableArray()
    tempArry = new Array()
    tempArry.push name: name, type: type for {name, type} in soapMethod.takes
    tempArry.sort()
    @params tempArry
    @description = ko.observable ''
    @host =
      protocol  : window.location.protocol
      host      : window.location.host
      route     : "pvm"
    @resultValue = ko.observable()
    @resultState = ko.observable()
    @resultMessage = ko.observable()
    @result = ko.computed =>
      if @resultState()?
        if @resultState() == 0
          @resultValue()
        else
          @resultMessage()
      else
        null


  pvmError : (r) =>
    alert r[1]

  successFunction : (r) =>
    console.log 'success'
    @resultValue r

  errorFunction : (r) =>
    console.log 'error'
    console.log r

  call : (context, event, paramsArr, success, error) ->

    name = @name()

    # Assign Params
    #
    # If called by knockout in view - arguments[0..1] are context & event
    # If called from console or invoked some other way - need to re-assign arguments
    #

    # no arguments means paramsArr must be set to empty array
    if arguments.length == 0
      paramsArr = []

    # if one argument, it must be paramsArr or successFunction
    if arguments.length == 1
      if typeof arguments[0] == "function"
        success = arguments[0]
        paramsArr = []
      else
        paramsArr = arguments[0]

    # if 2 arguments, could be from knockout or other... check to see if last argument is function
    if arguments.length == 2
      if typeof arguments[1] == "function"
        paramsArr = arguments[0]
        success = arguments[1]
      else
        # if knockout, then need to set paramsArr to empty array
        paramsArr = []

    # if 3 arguments and last is function - then was not call by knockout
    if arguments.length == 3 && typeof arguments[2] == "function"
      paramsArr = arguments[0]
      success = arguments[1]
      error = arguments[2]

    #params must be an array - since server will unpack.  Make sure to pack params as an Array
    if typeof paramsArr != "object"
      paramsArr = [paramsArr]
    else
      if typeof paramsArr.length == "undefined"
        paramsArr = [paramsArr]

    params = JSON.stringify paramsArr

    #assign defaults to error and success if undefined
    unless error
      error = @errorFunction
    unless success
      success = @successFunction

    pvmError = @pvmError

    $.ajax
      dataType  : 'json'
      url       : @host.protocol + '//' + @host.host + '/pvm'
      data      :
        method    : name
        params    : params
      success   : (r) ->
        if r[0] == 0
          success r[2]
        else
          pvmError r
      error     : error

window.SOAPMethod = SOAPMethod