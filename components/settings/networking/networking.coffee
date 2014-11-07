ko.components.register 'networking',

  viewModel:
    class Networking

      constructor: () ->
        @dns = ko.observable()
        @interfaces = ko.observableArray()
        @routes = ko.observableArray()
        @pvmIps = ko.observableArray()

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
    require : "/static/requirejs/text.js!views?template=settings/networking/networking"
