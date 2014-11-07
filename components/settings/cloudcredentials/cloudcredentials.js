// Generated by CoffeeScript 1.6.2
(function() {
  var cloudCredentials,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ko.components.register('cloudcredentials', {
    viewModel: cloudCredentials = (function() {
      function cloudCredentials() {
        this.init = __bind(this.init, this);
        var _this = this;

        this.credentials = ko.observable(new Object());
        this.cloudName = ko.pureComputed(function() {
          return Object.keys(_this.credentials())[0];
        });
        this.username = ko.pureComputed(function() {
          if (_this.cloudName() != null) {
            return _this.credentials()[_this.cloudName()].username;
          }
        });
        this.server = ko.pureComputed(function() {
          if (_this.cloudName() != null) {
            return _this.credentials()[_this.cloudName()].server;
          }
        });
        this.init();
      }

      cloudCredentials.prototype.init = function() {
        var _this = this;

        return pvm.methods.listCloudCredentials.call(function(r) {
          return _this.credentials(r);
        });
      };

      return cloudCredentials;

    })(),
    template: {
      require: "/static/requirejs/text.js!views?template=settings/cloudcredentials/cloudcredentials"
    }
  });

}).call(this);

/*
//@ sourceMappingURL=cloudcredentials.map
*/
