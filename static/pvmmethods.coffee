
ko.components.register 'methods',

  viewModel :

    class PVMMethods

      constructor : () ->
        @list = ko.observableArray()
        @loadDescriptions()

      loadDescriptions : () ->
        success = (r) =>
          arr = Object.keys r
          @list.push name: name, description : r[2][name] for name in arr
        pvm.methods.listApi.call success

  template:
      require : "/static/requirejs/text.js!views?template=methods"
