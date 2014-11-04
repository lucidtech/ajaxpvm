
ko.components.register 'users',

  viewModel:
    class PVMUsers

      constructor: () ->
        @users = ko.observableArray([])
        @allRoles = ko.observableArray([])
        @sortedUsers = ko.computed =>
          @users().sort()
        @sortedRoles = ko.computed =>
          @allRoles().sort()
        @sortedGroups = ko.observable().subscribeTo('groupsIndex')
        @init()

      getAllRoles : () ->
        @allRoles []
        pvm.methods.listRoles.call (r) =>
          @allRoles r

      init : =>
        refreshUsers = (r) =>
          @users r

        pvm.methods.listUsers.call refreshUsers
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
        @scoped = (role, group) =>
          ko.computed =>
            if Object.keys(@scope()).length != 0
              if @scope()[role].indexOf(group) >= 0
                buttoncss : 'btn-primary', bool : true, glyphstyle : 'white', glyphcss: 'glyphicon-ok'
              else
                buttoncss : 'btn-default', bool : false, glyphstyle : '', glyphcss: 'glyphicon-plus'
            else
              buttoncss : '', bool : false, glyphstyle : '', glyphcss: ''
        @init()

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
        if @scope()[role].indexOf(group) >= 0
          @scope()[role] = @scope()[role].filter (i) -> i != group
        else
          @scope()[role].push group
        pvm.methods.updateUserScope.call [@name(), @scope()], @getUserScope

  template:
    require : "/static/requirejs/text.js!views?template=user"
