
ko.components.register 'ha',

  #High Availability APIs
  #Use these APIs to configure and perform high availability operations in ProtectV.
  #• configureHeartBeat
  #• configureHaService
  #• getHaConfig
  #• getHaHeartBeatConfig
  #• getHaStatus
  #• registerPeer
  #• unregisterAllPeers
  #• unregisterPeer

  viewModel:
    class HighAvailability

      constructor : () ->
        # getHaStatus
        @active               = ko.observable()
        @master               = ko.observable()
        @instances            = ko.observable()
        #derived
        @role                 = ko.pureComputed ->
          @instances().role
        @status               = ko.pureComputed ->
          @instances().statusStr
        @statusRefreshTimer   = new Object()

        # getHaHeartBeatConfig
        @retryCount           = ko.observable()
        @responseTimeoutSecs  = ko.observable()
        @periodSecs           = ko.observable()

        # getHaConfig
        @virtualIp            = ko.observable()

        # registerPeer
        @peerInstanceId       = ko.observable() #the peer's FQN instance
        @peerHaPort           = ko.observable() #the default should be 7080

        @dirty                = ko.computed =>
          @retryCount()
          @responseTimeoutSecs()
          @periodSecs()
          @virtualIp()
          if ko.computedContext.isInitial()
            false
          else
            true

        @init()

      getHAInfo : () =>
        pvm.methods.getHaConfig.call (config) =>
          @virtualIp config.virtualIp
        pvm.methods.getHaHeartBeatConfig.call (config) =>
          @retryCount config.retryCount
          @responseTimeoutSecs config.responseTimeourtSecs
          @periodSecs config.periodSecs
        pvm.methods.getHaStatus.call (status) =>
          @active status.active
          @master status.master
          @instances status.instances

      setHAInfo : () =>
        pvm.methods.configureHeartBeat.call [@periodSecs(), @responseTimeoutSecs(), @retryCount()]
        pvm.methods.configureHaService.call @virtualIp()

      updatePeer : () =>
        if @peerInstanceId() == 'None'
#• unregisterAllPeers
#• unregisterPeer
        else
          pvm.methods.registerPeer.call [@peerInstanceId(), @peerHaPort()]


#• configureHeartBeat
#• configureHaService
#• registerPeer
#• unregisterAllPeers
#• unregisterPeer
#        pvm.methods.


      startRefreshTimer : =>
        @statusRefreshTimer = setInterval =>
          @getHAInfo()
        , 180000 #3 minutes

      init : () =>
        @startRefreshTimer()

  template :
    require : "/static/requirejs/text.js!views?template=settings/ha/ha"
