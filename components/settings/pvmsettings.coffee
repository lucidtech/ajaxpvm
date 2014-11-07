ko.components.register 'settings',

  viewModel:
    class PVMSettings

      constructor: () ->
        @init()

      init : () =>

  template:
    require : "/static/requirejs/text.js!views?template=settings/settings"

