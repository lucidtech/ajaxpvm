// Generated by CoffeeScript 1.6.2
(function() {
  var SOAPMethod,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SOAPMethod = (function() {
    function SOAPMethod(soapMethod) {
      this.errorFunction = __bind(this.errorFunction, this);
      this.successFunction = __bind(this.successFunction, this);
      var name, type, _i, _len, _ref, _ref1;

      this.name = ko.observable(soapMethod.method);
      this.params = ko.observableArray();
      _ref = soapMethod.takes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _ref1 = _ref[_i], name = _ref1.name, type = _ref1.type;
        this.params.push({
          name: name,
          type: type
        });
      }
      this.description = ko.observable('');
      this.result = ko.observable();
    }

    SOAPMethod.prototype.successFunction = function(r) {
      console.log('success');
      return this.result(r);
    };

    SOAPMethod.prototype.errorFunction = function(r) {
      console.log('error');
      return console.log(r);
    };

    SOAPMethod.prototype.call = function(context, event, paramsObject, success, error) {
      if (!error) {
        error = this.errorFunction;
      }
      if (!success) {
        success = this.successFunction;
      }
      return $.ajax({
        dataType: 'json',
        url: window.location.protocol + '//' + window.location.host + '/pvm',
        data: {
          method: this.name,
          params: paramsObject
        },
        success: success,
        error: error
      });
    };

    return SOAPMethod;

  })();

  window.SOAPMethod = SOAPMethod;

}).call(this);

/*
//@ sourceMappingURL=soapMethods.map
*/
