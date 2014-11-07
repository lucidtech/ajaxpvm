describe "Communications with SOAP Proxy", ->

  randomArrayOfAPIs = ['getVersion', 'listApi', 'generateSSLCSR', 'deleteProxyConfig', 'pvm_setCACert']
  testObject = new Object()
  users = new Array()

  testObject = new PVMAjax 'https', '192.168.92.146', 'soap', '8080', {protocol: 'http:', host: 'localhost:8000'}
  testObject.username 'admin'
  testObject.password 'admin1'

  #override JS to point to server and not jasmine test runner
  testObject.host.host = 'localhost:8000'
  testObject.host.protocol = 'http:'

  testObject.login()

  it "successfully logs in and populates methods", (done) ->
    interval = setInterval ->
      if Object.keys(testObject.methods).length > 0
        expect(testObject.methods[m]).not.toBe(undefined) for m in randomArrayOfAPIs
        clearInterval interval
        done()
    , 300
    setTimeout ->
      clearInterval interval
      done()
    , 5000

  it "calls listUsers (which takes no params)", (done) ->
    test = testObject.methods.listUsers
    test.host.host = 'localhost:8000'
    test.call()
    interval = setInterval ->
      if test.resultState() == 0
        expect(test.resultMessage()).toBe ""
        users = test.resultValue()
        clearInterval interval
        done()
    , 300
    setTimeout ->
      clearInterval interval
      done()
    , 5000

  it "calls getUserScope on an existing user", (done) ->
    test = testObject.methods.getUserScope
    test.host.host = 'localhost:8000'
    test.call(users[0])
    interval = setInterval ->
      if test.resultState() == 0
        expect(test.result()).not.toBe ""
        clearInterval interval
        done()
    , 300
    setTimeout ->
      clearInterval interval
      done()
    , 5000

  it "gets an error on getUserScope with a bogus user", (done) ->
    test = testObject.methods.getUserScope
#   overwrite default PVMError function (that throws an alert dialog
    test.pvmError = () -> null
    test.host.host = 'localhost:8000'
    test.call('wanglebangledanglefoobar')
    interval = setInterval ->
      if test.resultState() > 0
        expect(test.resultState()).not.toBe 0
        clearInterval interval
        done()
    , 300
    setTimeout ->
      clearInterval interval
      done()
    , 5000
