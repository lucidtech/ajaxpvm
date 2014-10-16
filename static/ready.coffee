#defaults =
#  protocol  : window.location.protocol
#  host      : window.location.host
#  route     : "soap"
#  port      : "8080"
#  username  : "admin"
#  password  : "admin1"
#
#pvm = new PVMInterface defaults.protocol, defaults.host, defaults.port, defaults.route, defaults.username, defaults.password
#
#successFunction = (SOAPObject) ->
#  SOAPObject.toJSON
#
#errorFunction = (SOAPObject) ->
#  SOAPObject.toJSON
#
## pvm.method('getVersion', successFunction, errorFunction)
#
#$.ajax
#  dataType  : 'json'
#  url       : 'http://localhost:8000/get_pvm_data'
#  data      :
#    method  : 'getVersion'
#    params  : {}
#  success   : successFunction
#
#
#
## $.ajax({dataType: 'json', url: 'https://192.168.92.146/modern_pvm', data: 'getVersion', success: successFunction})

window.pvm = new PVMAjax 'https', '192.168.92.146', 'soap', '8080'

#bypass manual login for testing
pvm.username 'admin'
pvm.password 'admin1'
pvm.login()

#ko.components.register 'methods', require: '/static/pvmmethods.js'

waitForLogin =  setInterval ->
                  if pvm.loginSuccess()
                    clearInterval waitForLogin
                    ko.applyBindings()
#                    ko.components.register 'methods', require: 'static/methods'
#                    window.methods = new PVMMethods pvm
#                    window.roles = new PVMRoles pvm
#                    window.users = new PVMUsers pvm
                , 500
#window.users = new PVMUsers

#$ ->
#  ko.applyBindings()

#testEach = (methods) ->
#  pvm.call method for method in methods
#pvm.methods(testEach)

