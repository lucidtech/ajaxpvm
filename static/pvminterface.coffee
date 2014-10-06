class PVMInterface

# augments Jquery.Soap for use with PVM
# Jquery.Soap will not fire AJAX call until @soap object is passed data object.
# however many PVM soap calls dont take any parameters - so we have to pass
# an XML string to data in order to get Jquery.Soap to fire
#
# mySoapInterface = New PVMInterface New $.soap, "https", "127.0.0.1", "8080"[, "route"], "username", "password"
# mySoapInterface.soap "getVersion", success, error
#
# myOtherSoapInterface = New PVMInterface New $.soap, "https", "127.0.0.1", "8080"[, "route"], "username", "password"
# myOtherSoapInterface.soap "doSomething", {with: this, data: params}, success, error


  _xmlify = (str) ->
    "<" + str + "></" + str + ">"

  constructor: (protocol, targetHost, targetPort, targetURL, username, password) ->
      @xmlPreamble      = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body>'
      @xmlPostfix       = '</soap:Body></soap:Envelope>'
      namespace         = if password?
                            "/" + targetURL + "/"
                          else
                            ""
      url               = protocol + "//" + username +  ":" + password + "@" + targetHost + ":" + targetPort + namespace
      @soap             = $.soap
      @soap url: url

#
# call method (string) with params (object), pass in call back functions for success and fail
# params is optional
# success and fail should take a single value - soapObject.
# To use the soapObject as JSON or String or XML use soapObject.toJSON(), toString(), toXML()
# soap('myMethod', {key: value...}, yay, boo)
#

  method : (methodName, params, success, error) ->

    if arguments.length >= 3
      if !error
        # params were not passed in
        error     = success
        success   = params
        data      = @xmlPreamble + _xmlify(methodName) + @xmlPostfix
        # method    = null
      else
        data      = params
        # method    = methodName

      @soap data: data, success: success, error: error
    else
      # invalid number of arguments
