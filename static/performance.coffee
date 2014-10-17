ko.components.register 'performance',

  viewModel:

    class Tests

      constructor : (params) ->
        @tests = ko.observableArray()
        @init(params.params)
        @totalTests = @tests().length
        @lastTest = 0
        @sortedTests = ko.computed =>
          @tests.sort (one, theOther) ->
            if one.average() == theOther.average()
              0
            else
              if one.average() > theOther.average()
                -1
              else
                1

      class Test

        constructor : (params) ->
          @p = params
          @call = params.call
          @params = params.params
          @numberOfRuns = ko.observable(0)
          @total = ko.observable(0)
          @shortest = ko.observable(0)
          @longest = ko.observable(0)
          @start = Date.now()
          @average = ko.computed =>
            if @numberOfRuns() == 0
              0
            else
              @total() / @numberOfRuns()
          @bars = ko.computed =>
            factor = (longest) ->
                candidateFactor = (window.screen.width / longest) * 0.9
                if window.factor > candidateFactor
                  window.factor = candidateFactor
                window.factor

            f = factor(@longest())
            [
              {value: @shortest(), width: @shortest() * f},
              {value: @average(), width: @average() * f},
              {value: @longest(), width: @longest() * f}
            ]

        successTimer : =>
          @numberOfRuns @numberOfRuns()+1
          elapsed = (Date.now() - @start)
          if @numberOfRuns() == 1
            @shortest elapsed
          @longest Math.max(@longest(), elapsed)
          @shortest Math.min(@shortest(), elapsed)
          @total @total() + elapsed

        run : =>
          @start = Date.now()
          if @params
            pvm.methods[@call].call @params, @successTimer
          else
            pvm.methods[@call].call @successTimer

      init : (params) ->
        window.factor = 1000000
        $( document ).ajaxComplete =>
          if @lastTest + 1 == @totalTests
            nextTest = 0
          else
            nextTest = @lastTest + 1
          @lastTest = nextTest
          @tests()[nextTest].run()
        @tests.push new Test test for test in params
        @tests()[0].run()

  template:
    require : "/static/requirejs/text.js!views?template=performance"
