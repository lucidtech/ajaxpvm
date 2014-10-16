// Generated by CoffeeScript 1.6.2
(function() {
  describe("Communications with SOAP Proxy", function() {
    var randomArrayOfAPIs, testObject, users;

    randomArrayOfAPIs = ['getVersion', 'listApi', 'generateSSLCSR', 'deleteProxyConfig', 'pvm_setCACert'];
    testObject = new Object();
    users = new Array();
    this.interval = new Object();
    testObject = new PVMAjax('https', '192.168.92.146', 'soap', '8080');
    testObject.username('admin');
    testObject.password('admin1');
    testObject.host.host = 'localhost:8000';
    testObject.host.protocol = 'http:';
    testObject.login();
    beforeEach(function(done) {
      return this.interval = setInterval(function() {
        if (testObject.methodNames().length > 160) {
          return done();
        }
      }, 300);
    });
    it("successfully logs in and populates methods", function(done) {
      var m, _i, _len;

      clearInterval(this.interval);
      for (_i = 0, _len = randomArrayOfAPIs.length; _i < _len; _i++) {
        m = randomArrayOfAPIs[_i];
        expect(testObject.methods[m]).not.toBe(void 0);
      }
      return done();
    });
    it("calls listUsers (which takes no params)", function(done) {
      var _this = this;

      testObject.methods.listUsers.host.host = 'localhost:8000';
      testObject.methods.listUsers.host.protocol = 'http:';
      testObject.methods.listUsers.call();
      this.interval = setInterval(function() {
        if (testObject.methods.listUsers.resultState() === 0) {
          expect(testObject.methods.listUsers.resultMessage()).toBe("");
          users = testObject.methods.listUsers.resultValue();
          return done();
        }
      }, 300);
      return setTimeout(function() {
        clearInterval(_this.interval);
        return done();
      }, 5000);
    });
    it("calls getUserScope on an existing user", function(done) {
      var _this = this;

      clearInterval(this.interval);
      testObject.methods.getUserScope.host.host = 'localhost:8000';
      testObject.methods.getUserScope.host.protocol = 'http:';
      testObject.methods.getUserScope.call(users[0]);
      this.interval = setInterval(function() {
        if (testObject.methods.getUserScope.resultState() === 0) {
          expect(testObject.methods.getUserScope.resultMessage()).toBe("");
          return done();
        }
      }, 300);
      return setTimeout(function() {
        clearInterval(_this.interval);
        return done();
      }, 5000);
    });
    return it("gets an error on getUserScope with a bogus user", function(done) {
      clearInterval(this.interval);
      testObject.methods.getUserScope.host.host = 'localhost:8000';
      testObject.methods.getUserScope.host.protocol = 'http:';
      testObject.methods.getUserScope.call('wanglebangledanglefoobar');
      return setTimeout(function() {
        expect(testObject.methods.getUserScope.resultState()).not.toBe(0);
        return done();
      }, 4000);
    });
  });

}).call(this);

/*
//@ sourceMappingURL=jsToSoapProxyCommsTest.map
*/
