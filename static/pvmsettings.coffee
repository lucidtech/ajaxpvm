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
