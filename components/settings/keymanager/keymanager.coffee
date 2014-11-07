ko.components.register 'keymanager',

  viewModel:
    class KeyManager

      constructor: () ->
        @userName             = ko.observable()
        @password             = ko.observable()
        @ipAddress            = ko.observable()
        @port                 = ko.observable()
        @protocol             = ko.observable()
        @certificate          = ko.observable()

        @unsetCredentials     = true
        @dirtyCredentials     = ko.pureComputed =>
          @userName()
          @password()
          if @unsetCredentials
            false
          else
            true

        @unsetProperties      = true
        @dirtyProperties      = ko.pureComputed =>
          @certificate()
          @ipAddress()
          @port()
          @protocol()
          if @unsetProperties
            false
          else
            true

        @init()

      updateCredentials : () =>
        pvm.methods.setKeySecureCredentials.call [@userName(), @password()], @keyManagerCredentials

      updateProperties : () =>
        pvm.methods.setKeySecureProperties.call {NAE_IP: @ipAddress(), NAE_Port: @nport(), Protocol: @protocol()}, @keyManagerCredentials

      keyManagerCredentials : () =>
        keyManagerCreds = (r) =>
          @userName r
          @unsetCredentials = false
        pvm.methods.getKeySecureCredentials.call keyManagerCreds

      keyManagerProperties : () =>
        keyManager = (r) =>
          @ipAddress r.NAE_IP
          @port r.NAE_Port
          @protocol r.Protocol
          @certificate r.CA_Cert
          @unsetProperties = false
        pvm.methods.getKeySecureProperties.call keyManager

      init : () =>
        @keyManagerProperties()
        @keyManagerCredentials()


  template:
    require : "/static/requirejs/text.js!views?template=settings/keymanager/keymanager"
