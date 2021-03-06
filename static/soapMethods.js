// Generated by CoffeeScript 1.6.2
(function() {
  var SOAPMethod,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  SOAPMethod = (function() {
    function SOAPMethod(soapMethod, host) {
      this.errorFunction = __bind(this.errorFunction, this);
      this.successFunction = __bind(this.successFunction, this);
      this.pvmError = __bind(this.pvmError, this);
      var name, tempArry, type, _i, _len, _ref, _ref1,
        _this = this;

      this.name = ko.observable(soapMethod.method);
      this.params = ko.observableArray();
      tempArry = new Array();
      _ref = soapMethod.takes;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        _ref1 = _ref[_i], name = _ref1.name, type = _ref1.type;
        tempArry.push({
          name: name,
          type: type
        });
      }
      tempArry.sort();
      this.params(tempArry);
      this.description = ko.observable('');
      this.host = host;
      this.resultValue = ko.observable();
      this.resultState = ko.observable();
      this.resultMessage = ko.observable();
      this.result = ko.computed(function() {
        if (_this.resultState() != null) {
          if (_this.resultState() === 0) {
            return _this.resultValue();
          } else {
            return _this.resultMessage();
          }
        } else {
          return null;
        }
      });
    }

    SOAPMethod.prototype.pvmError = function(message) {
      return alert(message);
    };

    SOAPMethod.prototype.successFunction = function(r) {
      return console.log('success');
    };

    SOAPMethod.prototype.errorFunction = function(r) {
      return console.log('error');
    };

    SOAPMethod.prototype.call = function(context, event, paramsArr, success, error) {
      var name, params, pvmError,
        _this = this;

      name = this.name();
      if (arguments.length === 0) {
        paramsArr = [];
      }
      if (arguments.length === 1) {
        if (typeof arguments[0] === "function") {
          success = arguments[0];
          paramsArr = [];
        } else {
          paramsArr = arguments[0];
        }
      }
      if (arguments.length === 2) {
        if (typeof arguments[1] === "function") {
          paramsArr = arguments[0];
          success = arguments[1];
        } else {
          paramsArr = [];
        }
      }
      if (arguments.length === 3 && typeof arguments[2] === "function") {
        paramsArr = arguments[0];
        success = arguments[1];
        error = arguments[2];
      }
      if (typeof paramsArr !== "object") {
        paramsArr = [paramsArr];
      } else {
        if (typeof paramsArr.length === "undefined") {
          paramsArr = [paramsArr];
        }
      }
      params = JSON.stringify(paramsArr);
      if (!error) {
        error = this.errorFunction;
      }
      if (!success) {
        success = this.successFunction;
      }
      pvmError = this.pvmError;
      return $.ajax({
        dataType: 'json',
        url: this.host.protocol + '//' + this.host.host + '/pvm',
        data: {
          method: name,
          params: params
        },
        success: function(r) {
          _this.resultState(r[0]);
          _this.resultMessage(r[1]);
          _this.resultValue(r[2]);
          if (r[0] === 0) {
            return success(r[2]);
          } else {
            return pvmError(_this.resultMessage());
          }
        },
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
