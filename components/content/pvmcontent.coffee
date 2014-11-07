ko.components.register 'pvmcontent',

  viewModel:
    class PVMRouting

      constructor : ->
        @currentView  = ko.observable('settings')
        @views        = ko.observableArray ['clouds', 'users', 'groups', 'settings', 'methods']

  template:
    require : "/static/requirejs/text.js!views?template=content/content"

