
ko.components.register 'methods',

  viewModel :

    class PVMMethods

      constructor : () ->
        @list = ko.observableArray()
        @descriptions = new Object()
        @loadDescriptions()

      loadDescriptions : () ->
        success = (r) =>
          @list Object.keys r[2]
          @descriptions = r[2]
        pvm.methods.listApi.call(success)

  template:
      require : "/static/requirejs/text.js!views?template=methods"
