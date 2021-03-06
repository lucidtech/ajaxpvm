// Generated by CoffeeScript 1.6.2
(function() {
  var Tests,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ko.components.register('performance', {
    viewModel: Tests = (function() {
      var Test;

      function Tests(params) {
        var _this = this;

        this.tests = ko.observableArray();
        this.init(params.params);
        this.totalTests = this.tests().length;
        this.lastTest = 0;
        this.sortedTests = ko.computed(function() {
          return _this.tests.sort(function(one, theOther) {
            if (one.average() === theOther.average()) {
              return 0;
            } else {
              if (one.average() > theOther.average()) {
                return -1;
              } else {
                return 1;
              }
            }
          });
        });
      }

      Test = (function() {
        function Test(params) {
          this.run = __bind(this.run, this);
          this.successTimer = __bind(this.successTimer, this);
          var _this = this;

          this.p = params;
          this.call = params.call;
          this.params = params.params;
          this.numberOfRuns = ko.observable(0);
          this.total = ko.observable(0);
          this.shortest = ko.observable(0);
          this.longest = ko.observable(0);
          this.start = Date.now();
          this.average = ko.computed(function() {
            if (_this.numberOfRuns() === 0) {
              return 0;
            } else {
              return _this.total() / _this.numberOfRuns();
            }
          });
          this.bars = ko.computed(function() {
            var f, factor;

            factor = function(longest) {
              var candidateFactor;

              candidateFactor = (window.screen.width / longest) * 0.9;
              if (window.factor > candidateFactor) {
                window.factor = candidateFactor;
              }
              return window.factor;
            };
            f = factor(_this.longest());
            return [
              {
                value: _this.shortest(),
                width: _this.shortest() * f
              }, {
                value: _this.average(),
                width: _this.average() * f
              }, {
                value: _this.longest(),
                width: _this.longest() * f
              }
            ];
          });
        }

        Test.prototype.successTimer = function() {
          var elapsed;

          this.numberOfRuns(this.numberOfRuns() + 1);
          elapsed = Date.now() - this.start;
          if (this.numberOfRuns() === 1) {
            this.shortest(elapsed);
          }
          this.longest(Math.max(this.longest(), elapsed));
          this.shortest(Math.min(this.shortest(), elapsed));
          return this.total(this.total() + elapsed);
        };

        Test.prototype.run = function() {
          var getParam,
            _this = this;

          if (this.params) {
            getParam = function(p) {
              var b;

              _this.start = Date.now();
              console.log(p);
              b = p.match(/true/i);
              return pvm.methods[_this.call].call(!b, _this.successTimer);
            };
            return pvm.methods[this.params].call(getParam);
          } else {
            this.start = Date.now();
            return pvm.methods[this.call].call(this.successTimer);
          }
        };

        return Test;

      })();

      Tests.prototype.init = function(params) {
        var tempArry, test, _i, _len,
          _this = this;

        window.factor = 1000000;
        tempArry = new Array();
        $(document).ajaxComplete(function() {
          var nextTest;

          if (_this.lastTest + 1 >= _this.totalTests) {
            nextTest = 0;
          } else {
            nextTest = _this.lastTest + 1;
          }
          _this.lastTest = nextTest;
          return _this.tests()[nextTest].run();
        });
        for (_i = 0, _len = params.length; _i < _len; _i++) {
          test = params[_i];
          tempArry.push(new Test(test));
        }
        this.tests(tempArry);
        return this.tests()[0].run();
      };

      return Tests;

    }).call(this),
    template: {
      require: "/static/requirejs/text.js!views?template=performance/performance"
    }
  });

}).call(this);

/*
//@ sourceMappingURL=performance.map
*/
