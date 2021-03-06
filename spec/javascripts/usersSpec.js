// Generated by CoffeeScript 1.6.2
(function() {
  var groupsViewModel, userViewModel, usersViewModel;

  groupsViewModel = ko.components.Ub.groups.viewModel;

  usersViewModel = ko.components.Ub.users.viewModel;

  userViewModel = ko.components.Ub.user.viewModel;

  window.pvm = new PVMAjax('https', '192.168.92.146', 'soap', '8080', {
    protocol: 'http',
    host: 'localhost:8000'
  });

  pvm.username('admin');

  pvm.password('admin1');

  pvm.host.host = 'localhost:8000';

  pvm.host.protocol = 'http:';

  pvm.login();

  describe("Managing an individual user", function() {
    var g, u, user;

    g = new Object();
    u = new Object();
    user = new Object();
    beforeEach(function(done) {
      var interval;

      return interval = setInterval(function() {
        if (Object.keys(pvm.methods).length > 160) {
          clearInterval(interval);
          g = new groupsViewModel();
          u = new usersViewModel();
          return interval = setInterval(function() {
            if (g.groupsIndex().length > 0 && u.users().length > 0) {
              clearInterval(interval);
              user = new userViewModel({
                name: u.users()[1]
              });
              return interval = setInterval(function() {
                if (user.role() !== "" && Object.keys(user.scope()).length > 0) {
                  clearInterval(interval);
                  return done();
                }
              }, 300);
            }
          }, 300);
        }
      }, 300);
    });
    it("has a role for the user", function() {
      return expect(user.role().length).toBeGreaterThan(0);
    });
    it("has a scope for the user", function() {
      return expect(Object.keys(user.scope()).length).toBeGreaterThan(0);
    });
    it("returns a button css state depending on a role for a group", function() {
      return expect(user.scoped(user.role(), g.groupsIndex()[0]).buttoncss).not.toBe('');
    });
    return it("allows the state of the button to flip if the users role for the group is changed", function(done) {
      var currentButtonCSS;

      currentButtonCSS = user.scoped(user.role(), g.groupsIndex()[0]).buttoncss;
      user.flipScope(user.role(), g.groupsIndex()[0]);
      return setTimeout(function() {
        expect(user.scoped(user.role(), g.groupsIndex()[0])().buttoncss).not.toBe(currentButtonCSS);
        return done();
      }, 3000);
    });
  });

}).call(this);

/*
//@ sourceMappingURL=usersSpec.map
*/
