
ko.components.register 'users',

  viewModel:
    class PVMUsers

      constructor: () ->
        @names = ko.observableArray()
        @roles = ko.observableArray()
        @groups = ko.observableArray()
        @allRoles = ko.observableArray()
        @init()

      getRoleFor : (name) ->
        pvm.methods.getUserRole.call name, (r) =>
          @roles.push name : name, role : r[2]

      getGroupsFor : (name) ->
        pvm.methods.getUserScope.call name, (r) =>
          tempArray = new Array()
          add = (item) ->
            if item.groups.length > 0
              tempArray.push item
          add role: ro, groups: r[2][ro] for ro of r[2]
          @groups.push name : name, scope : tempArray

      getAllRoles : () ->
        pvm.methods.listRoles.call (r) =>
          @allRoles r[2]

      init : =>
        refreshView = (data) =>
          if data[0] == 0
            @names data[2]
            for name in @names()
              @getGroupsFor(name)
              @getRoleFor(name)
              @getAllRoles()

        pvm.methods.listUsers.call refreshView

      deleteUser : (object) =>
        pvm.methods.deleteUser.call object.name, @init

      addUser : (form)->
        pvm.methods.addUser.call [form.username.value, form.password.value, form.role.value]

  template:
    require : "/static/requirejs/text.js!views?template=users"
