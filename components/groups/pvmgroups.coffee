ko.components.register 'groups',

  viewModel:
    class Groups

      constructor : () ->
        @groups       = ko.observable(new Object())
        @groupsIndex  = ko.computed =>
          Object.keys @groups()
        .publishOn('groups/groupsIndex')
        @init()

      getGroups : () =>
        loadList = (r) =>
          @groups r
        pvm.methods.listInstanceGroups.call loadList

      deleteGroup : (name) =>
        pvm.methods.deleteInstanceGroup.call name, @init

      addGroup : (form)->
        pvm.methods.addInstanceGroup.call form.groupname.value, @init

      init : () =>
        @getGroups()

  template:
    require : "/static/requirejs/text.js!views?template=groups/groups"

