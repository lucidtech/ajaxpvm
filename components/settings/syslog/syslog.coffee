ko.components.register 'syslog',

#  Logging APIs
#    Use these APIs to perform system log operations.
#    • cancelClearLogJob
#    • debugLogTransfer
#    • disableSyslogForwarding
#    • enableSyslogForwarding
#    • getSyslogServerInfo
#    • listClearLogJobs
#    • safeLogTransfer
#    • scheduleClearLogJob
#    • updateSyslogServer
#

  viewModel:
    class Syslog

      constructor: () ->

        # syslog server settings
        @ip1              = ko.observable()
        @port1            = ko.observable()
        @ip2              = ko.observable()
        @port2            = ko.observable()
        @forwarding       = ko.observable()
        @unsetInfo        = true
        @dirtyInfo        = ko.pureComputed =>
          @ip1()
          @port1()
          @ip2()
          @port2()
          @forwarding()
          if @unsetInfo
            false
          else
            true


        # log purge configuration
        @logPurgeJobs       = ko.observableArray(new Array())
        @newPurgeJob        =
                                category  : ko.observable()
                                tillday   : ko.observable()
                                freq      : ko.observable()
                                day       : ko.observable()
                                hour      : ko.observable()
                                minute    : ko.observable()

        @newPurgeJobOptions =
                                category  : ['all', 'debug', 'audit', 'system', 'external']
                                tillday   : [1, 7, 30, 60, 90, 365]
                                freq      : ['monthly', 'weekly', 'daily']
                                day       :
                                  weekly    : ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
                                  monthly   : [1..31]
                                hour      : [0..23]
                                minute    : ['00', '15', '30', '45']

        @init()

      formatCategory : (category, age) ->
        ageDays = (age) ->
          if age == 1
            age + " day"
          else
            age + " days"
        "Purge " +  category.toLowerCase() + " events older than " + ageDays age

      formatMinute : (minute) ->
        minuteString = minute.toString()
        if minuteString.length == 1
          '0' + minuteString
        else
          minuteString

      formatFrequency : (period, day) ->
        dayOfWeek = (day) ->
          switch day
            when 6
              "Sunday"
            when 0
              "Monday"
            when 1
              "Tuesday"
            when 2
              "Wednesday"
            when 3
              "Thursday"
            when 4
              "Friday"
            when 5
              "Saturday"

        dayOfMonth = (day) ->
          floor = Math.floor(((day/10) - Math.floor(day/10) + 0.01) * 10)
          if (day > 10) && (day < 20)
            day.toString() + "th"
          else
            switch floor
              when 1
                day.toString() + "st"
              when 2
                day.toString() + "nd"
              when 3
                day.toString() + "rd"
              else
                day.toString() + "th"

        switch period.toLowerCase()
          when "weekly"
            "weekly on a " + dayOfWeek day
          when "monthly"
            "monthly on the " + dayOfMonth day
          when "daily"
            "every day"

      getSyslogServerInfo : () =>
        map = (r) =>
          @ip1 r.ip1
          @ip2 r.ip2
          @port1 r.port1
          @port2 r.port2
          @forwarding if r.enabled == 'no' then false else true
          @unsetInfo = false
        pvm.methods.getSysLogServerInfo.call map

      setSyslogServerInfo : () =>
        refresh = =>
          if @forwarding()
            pvm.methods.enableSyslogForwarding.call @getSyslogServerInfo
          else
            pvm.methods.disableSyslogForwarding.call @getSyslogServerInfo
        pvm.methods.updateSyslogServer.call [@ip1(), @port1(), @ip2(), @port2()], refresh

      getPurgeJobInfo : () =>
        map = (r) =>
          tempArry = new Array()
          tempArry.push r[job] for job in Object.keys(r)
          @logPurgeJobs tempArry
        pvm.methods.listClearLogJobs.call map

      addJob : () =>
        days = =>
              if @newPurgeJob.freq() == 'weekly'
                  @newPurgeJobOptions.day.weekly.indexOf(@newPurgeJob.day())
              else
                if @newPurgeJob.freq() == 'daily'
                  0
                else
                  @newPurgeJob.day()

        pvm.methods.scheduleClearLogJob.call [
                                                @newPurgeJob.freq(),
                                                days(),
                                                @newPurgeJob.hour(),
                                                parseInt(@newPurgeJob.minute()),
                                                @newPurgeJob.category(),
                                                @newPurgeJob.tillday()
                                              ], @getPurgeJobInfo


      deleteJob : (item) =>
        pvm.methods.cancelClearLogJob.call [[item.id]], =>
          @logPurgeJobs.remove item

      init : () =>
        @getSyslogServerInfo()
        @getPurgeJobInfo()


  template:
    require : "/static/requirejs/text.js!views?template=settings/syslog/syslog"

