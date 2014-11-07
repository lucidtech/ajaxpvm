// Generated by CoffeeScript 1.6.2
(function() {
  var Networking,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ko.components.register('networking', {
    viewModel: Networking = (function() {
      function Networking() {
        this.init = __bind(this.init, this);        this.dns = ko.observable();
        this.interfaces = ko.observableArray();
        this.routes = ko.observableArray();
        this.pvmIps = ko.observableArray();
        this.init();
      }

      Networking.prototype.init = function() {
        var dns, getInterface, getPvmIp, getRoutes,
          _this = this;

        dns = function(r) {
          return _this.dns(r);
        };
        pvm.methods.listDNS.call(dns);
        getInterface = function(interfaceList) {
          var iface, pushInterface, _i, _len, _results;

          _results = [];
          for (_i = 0, _len = interfaceList.length; _i < _len; _i++) {
            iface = interfaceList[_i];
            pushInterface = function(r) {
              return _this.interfaces.push({
                "interface": iface,
                details: r
              });
            };
            _results.push(pvm.methods.getNetworkInterfaceInfo.call(iface, pushInterface));
          }
          return _results;
        };
        pvm.methods.listNetworkInterfaces.call(getInterface);
        getRoutes = function(routeList) {
          return _this.routes(routeList);
        };
        pvm.methods.listNetworkRoutes.call();
        pvm.methods.listNetworkRoutes.call(getRoutes);
        getPvmIp = function(ipList) {
          return _this.pvmIps(ipList);
        };
        return pvm.methods.pvm_getAddress.call(getPvmIp);
      };

      return Networking;

    })(),
    template: {
      require: "/static/requirejs/text.js!views?template=settings/networking/networking"
    }
  });

}).call(this);

/*
//@ sourceMappingURL=networking.map
*/