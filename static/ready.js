// Generated by CoffeeScript 1.6.2
(function() {
  var waitForLogin;

  window.pvm = new PVMAjax('https', '192.168.92.146', 'soap', '8080');

  pvm.username('admin');

  pvm.password('admin1');

  pvm.login();

  waitForLogin = setInterval(function() {
    if (pvm.loginSuccess()) {
      clearInterval(waitForLogin);
      return ko.applyBindings();
    }
  }, 500);

}).call(this);

/*
//@ sourceMappingURL=ready.map
*/
