ko.components.register 'settings',

  viewModel:
    class PVMSettings

      constructor: () ->
        @cloudCredentials = ko.observable(new Object())
        @networking = ko.observable(new Object())
        @keyManager = ko.observable(new Object())
        @syslog = ko.observable(new Object())
        @ha = ko.observable(new Object())
        @snmp = ko.observable(new Object())
        @unattendedReboot = ko.observable(new Object())
        @eventPurge = ko.observable(new Object())
        @physicalServer = ko.observable(new Object())
        @exportSettings = ko.observable(new Object())
        @shutDown = ko.observable(new Object())
        @init()

      init : () =>

  template:
    require : "/static/requirejs/text.js!views?template=settings"

ko.components.register 'cloudcredentials',

  viewModel:
    class cloudCredentials

      constructor: (params) ->
        @cloudCredentials = params.cloudcredentials
        @cloudName = ko.computed =>
          Object.keys(@cloudCredentials())[0]
        @username = ko.computed =>
          if @cloudName()?
            @cloudCredentials()[@cloudName()].username
        @server = ko.computed =>
          if @cloudName()?
            @cloudCredentials()[@cloudName()].server
        @init()

      init : () =>
        refresh = (r) =>
          @cloudCredentials r
        pvm.methods.listCloudCredentials.call refresh

  template:
    require : "/static/requirejs/text.js!views?template=settings/cloudcredentials"

ko.components.register 'networking',

  viewModel:
    class Networking

      constructor: (params) ->
        @networking = params.networking
        @dns = ko.observable()
        @interfaces = ko.observableArray()
        @routes = ko.observableArray()
        @pvmIps = ko.observableArray()
        @updateNetworking = ko.computed =>
          @networking dns: @dns, interfaces: @interfaces, routes: @routes, pvmIps: @pvmIps

        @init()

      init : () =>
        dns = (r) =>
          @dns r
        pvm.methods.listDNS.call dns

        getInterface = (interfaceList) =>
          for iface in interfaceList
            pushInterface = (r) =>
              @interfaces.push  interface: iface, details: r
            pvm.methods.getNetworkInterfaceInfo.call(iface, pushInterface)
        pvm.methods.listNetworkInterfaces.call getInterface

        getRoutes = (routeList) =>
          @routes routeList
#       for some reason - this call returns empty the first time it is called. so calling it twice
        pvm.methods.listNetworkRoutes.call()
        pvm.methods.listNetworkRoutes.call getRoutes

        getPvmIp = (ipList) =>
          @pvmIps ipList
        pvm.methods.pvm_getAddress.call getPvmIp

  template:
    require : "/static/requirejs/text.js!views?template=settings/networking"

ko.components.register 'keymanager',

  viewModel:
    class KeyManager

      constructor: (params) ->
        @keyManager = params.keymanager
        @userName = ko.observable()
        @newUserName = ko.observable(@userName())
        @newPassword = ko.observable('')
        @ipAddress = ko.observable()
        @port = ko.observable()
        @protocol = ko.observable()
        @certificate = ko.observable()
        @newIpAddress = ko.observable(@ipAddress())
        @newPort = ko.observable(@port())
        @newProtocol = ko.observable(@protocol())
        @newCertificate = ko.observable(@certificate())
        @updateKeyManager = ko.computed =>
          @keyManager userName: @userName, ipAddress: @ipAddress, port: @port, protocol: @protocol, certificate: @certificate
        @init()

      updateCredentials : () =>
        pvm.methods.setKeySecureCredentials.call [@newUserName90, @newPassword()], @keyManagerCredentials

      updateProperties : () =>
        pvm.methods.setKeySecureProperties.call {NAE_IP: @newIpAddress(), NAE_Port: @newPort(), Protocol: @newProtocol()}, @keyManagerCredentials


      keyManagerCredentials : () =>
        keyManagerCreds = (r) =>
          @userName r
        pvm.methods.getKeySecureCredentials.call keyManagerCreds

      keyManagerProperties : () =>
        keyManager = (r) =>
          @ipAddress r.NAE_IP
          @port r.NAE_Port
          @protocol r.Protocol
          @certificate r.CA_Cert
        pvm.methods.getKeySecureProperties.call keyManager


      init : () =>
        @keyManagerProperties()
        @keyManagerCredentials()


  template:
    require : "/static/requirejs/text.js!views?template=settings/keymanager"

ko.components.register 'syslog',

  viewModel:
    class Syslog

      constructor: (params) ->
        @syslog = params.syslog


#updateSyslogServer
#This function updates syslog server addresses for both primary syslog server and secondary syslog server. The primary syslog server IP and port must be provided. The secondary syslog server IP and port are optional.
#After the syslog servers are updated, the syslog forwarding is disabled. Call the enableSyslogForwarding function to enable syslog forwarding.

        @ip1 = ko.observable()
        @port1 = ko.observable()
        @ip2 = ko.observable()
        @port2 = ko.observable()
        @forwarding = ko.observable()
        @newIp1 = ko.observable('')
        @newPort1 = ko.observable('')
        @newIp2 = ko.observable('')
        @newPort2 = ko.observable('')
        @updateSyslog = ko.computed =>
          @syslog ip1: @ip1, ip2: @ip2, port1: @port1, port2: @port2, forwarding: @forwarding
        @init()

#      updateCredentials : () =>
#        pvm.methods.setKeySecureCredentials.call [@newUserName90, @newPassword()], @keyManagerCredentials
#
#      updateProperties : () =>
#        pvm.methods.setKeySecureProperties.call {NAE_IP: @newIpAddress(), NAE_Port: @newPort(), Protocol: @newProtocol()}, @keyManagerCredentials
#
#
#      keyManagerCredentials : () =>
#        keyManagerCreds = (r) =>
#          @userName r
#        pvm.methods.getKeySecureCredentials.call keyManagerCreds
#
#      keyManagerProperties : () =>
#        keyManager = (r) =>
#          @ipAddress r.NAE_IP
#          @port r.NAE_Port
#          @protocol r.Protocol
#          @certificate r.CA_Cert
#        pvm.methods.getKeySecureProperties.call keyManager
#
#
#      init : () =>
#        @keyManagerProperties()
#        @keyManagerCredentials()


  template:
    require : "/static/requirejs/text.js!views?template=settings/syslog"
