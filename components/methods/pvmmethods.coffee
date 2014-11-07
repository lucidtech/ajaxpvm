
ko.components.register 'methods',

  viewModel :

    class PVMMethods

      constructor : () ->
        @list = ko.observableArray()
        @loadDescriptions()

      loadDescriptions : () ->
        success = (r) =>
          arr = Object.keys r
          list = new Array()
          list.push name: name, description : r[name] for name in arr
          @list list
        pvm.methods.listApi.call success

  template:
      require : "/static/requirejs/text.js!views?template=methods/methods"