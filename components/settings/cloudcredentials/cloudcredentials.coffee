ko.components.register 'cloudcredentials',

  viewModel:
    class cloudCredentials

      constructor: () ->
        @credentials            = ko.observable(new Object())
        @cloudName              = ko.pureComputed =>
                                    Object.keys(@credentials())[0]
        @username               = ko.pureComputed =>
                                    if @cloudName()?
                                      @credentials()[@cloudName()].username
        @server                 = ko.pureComputed =>
                                    if @cloudName()?
                                      @credentials()[@cloudName()].server
        @init()

      init : () =>
        pvm.methods.listCloudCredentials.call (r) => @credentials r

  template:
    require : "/static/requirejs/text.js!views?template=settings/cloudcredentials/cloudcredentials"

