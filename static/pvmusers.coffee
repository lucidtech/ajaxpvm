
ko.components.register 'users',

  viewModel:
    class PVMUsers

      constructor: () ->
        @users = ko.observableArray([])
        @allRoles = ko.observableArray([])
        @allGroups = ko.observableArray([])
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
        @scope = ko.observable(new Object())
        @role = ko.observable()
        @allGroups = params.allGroups
        @assignedGroups = ko.computed =>
          arr = new Array()
          arr.push group for group in @scope()[role] for role in Object.keys @scope()
          arr
        @unassignedGroups = ko.computed =>
          arr = new Array()
          arr.push item.name for item in @allGroups()
          arr.filter (i)=>@assignedGroups().indexOf(i) < 0
        @scopeView = ko.computed =>
          arr = new Array()
          roles = Object.keys @scope()
          arr.push role: role, groups: @scope()[role] for role in roles
          arr

        @init()

#
#
#scope -> role : ['gr','gr'], role: [], role: []
#
#roles -> [role, role, role]
#
#groups -> [group, group, group]
#
#memory model
#
#role : [group: bool, group: bool, group, bool], role... etc.
#
#
#load
#	scope -> memory model
#
#toggle
# @role.group(!@role.group())
#
#save
#	memory model -> scope
#
#
#      THIS WILL RETURN THE RIGHT
#
#groups = ['one','two','three']
#roles = ['admin','observer','user']
#jimmy =
#    admin : []
#    observer : ['one']
#    user : ['two', 'one']
#
#jimmyRoleView = (scope, groups, roles) ->
#    roles.map (r) ->
#        scopeForThisRole = new Array()
#        scopeForThisRole = scope[r]
#        userGroups = new Array()
#        userGroups = groups
#        go = userGroups.map (g) ->
#            gobj = new Object
#            gobj[g] = scopeForThisRole.indexOf(g) >= 0
#            gobj
#        robj = new Object
#        robj[r] = go
#        robj
#




      getUserScope : =>
        pvm.methods.getUserScope.call @name(), (r) =>
          @scope r

      getUserRole : =>
        pvm.methods.getUserRole.call @name(), (r) =>
          @role r

      init : =>
        @getUserScope()
        @getUserRole()

      addToScope: (parentObj, thisGroup) =>
        @scope()[parentObj.role].push thisGroup
        pvm.methods.updateUserScope.call [@name(), @scope()], @getUserScope

      removeFromScope: (thisRole, thisGroup) =>
        index = @scope()[thisRole].indexOf thisGroup
        if index > -1
          @scope()[thisRole].splice index, 1
        pvm.methods.updateUserScope.call [@name(), @scope()], @getUserScope

#pvm.methods.updateUserScope.call(['admin', {'admin':['all-machines','HelloDolly']}])

  template:
    require : "/static/requirejs/text.js!views?template=user"
