// Generated by CoffeeScript 1.6.2
(function() {
  var PVMUsers, User,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  ko.components.register('users', {
    viewModel: PVMUsers = (function() {
      function PVMUsers(params) {
        var _this = this;

        this.params = params;
        this.deleteUser = __bind(this.deleteUser, this);
        this.init = __bind(this.init, this);
        this.users = ko.observableArray([]);
        this.allRoles = ko.observableArray([]);
        this.sortedUsers = ko.computed(function() {
          return _this.users().sort();
        });
        this.sortedRoles = ko.computed(function() {
          return _this.allRoles().sort();
        });
        this.sortedGroups = ko.computed(function() {
          return Object.keys(_this.params.groups());
        });
        this.init();
      }

      PVMUsers.prototype.getAllRoles = function() {
        var _this = this;

        this.allRoles([]);
        return pvm.methods.listRoles.call(function(r) {
          return _this.allRoles(r);
        });
      };

      PVMUsers.prototype.init = function() {
        var refreshUsers,
          _this = this;

        refreshUsers = function(r) {
          return _this.users(r);
        };
        pvm.methods.listUsers.call(refreshUsers);
        return this.getAllRoles();
      };

      PVMUsers.prototype.deleteUser = function(name) {
        return pvm.methods.deleteUser.call(name, this.init);
      };

      PVMUsers.prototype.addUser = function(form) {
        return pvm.methods.addUser.call([form.username.value, form.password.value, form.role.value], this.init);
      };

      return PVMUsers;

    })(),
    template: {
      require: "/static/requirejs/text.js!views?template=users"
    }
  });

  ko.components.register('user', {
    viewModel: User = (function() {
      function User(params) {
        this.flipScope = __bind(this.flipScope, this);
        this.init = __bind(this.init, this);
        this.getUserRole = __bind(this.getUserRole, this);
        this.getUserScope = __bind(this.getUserScope, this);
        var _this = this;

        this.name = ko.observable(params.name);
        this.role = ko.observable(new Object());
        this.scope = ko.observable(new Object());
        this.scoped = function(role, group) {
          return ko.computed(function() {
            if (Object.keys(_this.scope()).length !== 0) {
              if (_this.scope()[role].indexOf(group) >= 0) {
                return {
                  buttoncss: 'btn-primary',
                  bool: true,
                  glyphstyle: 'white',
                  glyphcss: 'glyphicon-ok'
                };
              } else {
                return {
                  buttoncss: 'btn-default',
                  bool: false,
                  glyphstyle: '',
                  glyphcss: 'glyphicon-plus'
                };
              }
            } else {
              return {
                buttoncss: '',
                bool: false,
                glyphstyle: '',
                glyphcss: ''
              };
            }
          });
        };
        this.init();
      }

      User.prototype.getUserScope = function() {
        var _this = this;

        return pvm.methods.getUserScope.call(this.name(), function(r) {
          return _this.scope(r);
        });
      };

      User.prototype.getUserRole = function() {
        var _this = this;

        return pvm.methods.getUserRole.call(this.name(), function(r) {
          return _this.role(r);
        });
      };

      User.prototype.init = function() {
        this.getUserScope();
        return this.getUserRole();
      };

      User.prototype.flipScope = function(role, group) {
        if (this.scope()[role].indexOf(group) >= 0) {
          this.scope()[role] = this.scope()[role].filter(function(i) {
            return i !== group;
          });
        } else {
          this.scope()[role].push(group);
        }
        return pvm.methods.updateUserScope.call([this.name(), this.scope()], this.getUserScope);
      };

      return User;

    })(),
    template: {
      require: "/static/requirejs/text.js!views?template=user"
    }
  });

}).call(this);

/*
//@ sourceMappingURL=pvmusers.map
*/
