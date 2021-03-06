ko.components.register 'clouds',

  viewModel:
    class Clouds

      constructor : () ->
        @clouds = {}
        @cloudsIndex = ko.observableArray()

        # registered here in the parent - so that child siblings can access
        @regionsIndex = ko.observableArray()

        @init()

      getClouds : () ->
        loadList = (r) =>
          @clouds = r
          index = Object.keys @clouds
          @cloudsIndex index
        pvm.methods.listSupportedClouds.call loadList

      init : () ->
        @getClouds()

  template:
    require : "/static/requirejs/text.js!views?template=instances/clouds"

ko.components.register 'regions',

  viewModel:
    class Regions

      constructor : (@params) ->
        @regions = {}
        @regionsIndex = @params.regionsIndex
        @init()

      getRegions : () =>
        loadList = (r) =>
          @regions = r.region
          @regionsIndex @regions.values
        pvm.methods.getCloudParams.call [@params.cloud, 'listInstances'], loadList

      init : () ->
        @getRegions()

  template:
    require : "/static/requirejs/text.js!views?template=instances/regions"


ko.components.register 'instances',

  viewModel:
    class Instances

      constructor: (params) ->
        # unwrap params
        @cloud = params.cloud
        @groupsIndex = ko.observable(new Array()).subscribeTo('groups/groupsIndex')
        @groupsInstancesIndex = ko.observable(new Object())
        @updateGroupsInstancesIndex = ko.computed =>
          @groupsIndex().forEach (group, index, array) =>
            if typeof @groupsInstancesIndex()[group] == 'undefined'
              pvm.methods.getInstanceGroup.call group, (list) =>
                @groupsInstancesIndex()[group] = list
        @regions = params.regions
        # -- these are observables - and will update as their models update
        @protectedInstancesIndex = new Object()
        # -- hold all the instance objects, and an index to them
        @instances = ko.observableArray()
        # -- for performance reasons, when we filter the view - we compute the new index then completely replace the view observable Array
        # -- because functions on Observable Arrays (like push) cause a re-render on ever event which is slow and buggy.
        @filterValue = ko.observable('')
        @filteredGroup = ko.observable('')
        @filterProtected = ko.observable('')
        @groupsOptions = ko.computed =>
          ['all Groups'].concat @groupsIndex()

        @updateInstances = ko.computed =>
          loadRegionInstances = (region) =>
            pvm.methods.listInstances.call [@cloud, region: region], (list) =>
              tempArray = @instances()
              tempArray.push new Instance list[obj], obj, region for obj in Object.keys list
              @instances tempArray
          loadRegionInstances region for region in @regions()

        @items = ko.computed =>
          match = (obj) =>
            isTextFiltered = () =>
              s = @filterValue().toLowerCase()
              if s != ""
                obj.instance.search.toLowerCase().indexOf(s) >= 0
              else
                true
            isGroupFiltered = () =>
              if @filteredGroup() == "all Groups"
                 true
              else
                 @groupsInstancesIndex()[@filteredGroup().toString()].indexOf(obj.name) >= 0
            testForProtected = () =>
              switch @filterProtected()
                when 'protected'
                  @protectedInstancesIndex.indexOf(obj.name) >= 0
                when 'unprotected'
                  @protectedInstancesIndex.indexOf(obj.name)  == -1
                else
                  true
            isGroupFiltered() && isTextFiltered() && testForProtected()
          @instances().filter match
        @init()

      getAllProtectedInstances : () ->
#       get all instances that are currently protected
        pvm.methods.listProtectedInstances.call (list) =>
          @protectedInstancesIndex = list

      init : () ->
        @getAllProtectedInstances()
        # need to get the protects instances index

      class Instance

        constructor: (@details, @name, @region) ->
          @instance = new Object
          @init()

        unwrapDetails : (details) ->
          temp = new Object()
          searchString = new String()
          temp[item.name] = item.value for item in details
          searchString = searchString + " " + object[Object.keys(object)[0]] for object in temp.tags
          searchString = searchString + " " + temp.platform + " " + temp.FQN + " " + temp.URStatus + " " + temp.state
          temp.search = searchString
          temp

        init : () ->
          @instance.name = @name
          @instance.region = @region
          $.extend @instance, @unwrapDetails @details

  template:
    require : "/static/requirejs/text.js!views?template=instances/instances"

