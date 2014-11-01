ko.components.register 'objects',

  viewModel:
    class master

      constructor : () ->
        @pvmMaster = ko.observable(1)
        @pvmGroups = ko.observable new Object()

  template:
    require : "/static/requirejs/text.js!views?template=objects"

