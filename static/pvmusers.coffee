
ko.components.register 'users',

  viewModel:
    class PVMUsers

      constructor: () ->
        @users = ko.observableArray([])
        @allRoles = ko.observableArray([])
        @allGroups = ko.observableArray([])
        @sortedUsers = ko.computed =>
          @users().sort()
        @init()

      getAllRoles : () ->
        @allRoles []
        pvm.methods.listRoles.call (r) =>
          @allRoles r
#
      getAllGroups : () ->
        pvm.methods.listInstanceGroups.call (r) =>
          arr = Object.keys r
          allGroups = new Array()
          allGroups.push name: name, details: r[name] for name in arr
          @allGroups allGroups
#
      init : =>
        refreshUsers = (r) =>
          @users r

        pvm.methods.listUsers.call refreshUsers
        @getAllGroups()
        @getAllRoles()

      deleteUser : (name) =>
        pvm.methods.deleteUser.call name, @init

      addUser : (form)->
        pvm.methods.addUser.call [form.username.value, form.password.value, form.role.value], @init

  template:
    require : "/static/requirejs/text.js!views?template=users"


ko.components.register 'user',

  viewModel:

    class User

      constructor : (params) ->
        @name = ko.observable(params.name)
        @role = ko.observable(new Object())
        @scope = ko.observable(new Object())
        @allRoles = params.allRoles
        @allGroups = params.allGroups
        @sortedRoles = ko.computed =>
          @allRoles().sort()
        @sortedGroups = ko.computed =>
          @allGroups().sort()

        @init()

      scoped : (role, group) =>
        if @scope()[role].indexOf(group) >= 0
          buttoncss : 'btn-primary', bool : true, glyphstyle : 'white', glyphcss: 'glyphicon-ok'
        else
          buttoncss : 'btn-default', bool : false, glyphstyle : '', glyphcss: 'glyphicon-plus'

      getUserScope : =>
        pvm.methods.getUserScope.call @name(), (r) =>
          @scope r

      getUserRole : =>
        pvm.methods.getUserRole.call @name(), (r) =>
          @role r

      init : =>
        @getUserScope()
        @getUserRole()

      flipScope : (role, group) =>
        console.log role
        console.log group


        if @scope()[role].indexOf(group) >= 0
          @scope()[role] = @scope()[role].filter (i) -> i != group
        else
          @scope()[role].push group
        pvm.methods.updateUserScope.call [@name(), @scope()], @getUserScope

  template:
    require : "/static/requirejs/text.js!views?template=user"
