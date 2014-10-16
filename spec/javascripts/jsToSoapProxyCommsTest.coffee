describe "Communications with SOAP Proxy", ->

  randomArrayOfAPIs = ['getVersion', 'listApi', 'generateSSLCSR', 'deleteProxyConfig', 'pvm_setCACert']
  testObject = new Object()
  users = new Array()
  @interval = new Object()

  testObject = new PVMAjax 'https', '192.168.92.146', 'soap', '8080'
  testObject.username 'admin'
  testObject.password 'admin1'

  #override JS to point to server and not jasmine test runner
  testObject.host.host = 'localhost:8000'
  testObject.host.protocol = 'http:'

  testObject.login()

  beforeEach (done) ->
    @interval = setInterval ->
      if testObject.methodNames().length > 160
        done()
    , 300

  it "successfully logs in and populates methods", (done) ->
    clearInterval @interval
    expect(testObject.methods[m]).not.toBe(undefined) for m in randomArrayOfAPIs
    done()

  it "calls listUsers (which takes no params)", (done) ->
    testObject.methods.listUsers.host.host = 'localhost:8000'
    testObject.methods.listUsers.host.protocol = 'http:'
    testObject.methods.listUsers.call()
    @interval = setInterval ->
      if testObject.methods.listUsers.resultState() == 0
        expect(testObject.methods.listUsers.resultMessage()).toBe ""
        users = testObject.methods.listUsers.resultValue()
        done()
    , 300
    setTimeout =>
      clearInterval @interval
      done()
    , 5000

  it "calls getUserScope on an existing user", (done) ->
    clearInterval @interval
    testObject.methods.getUserScope.host.host = 'localhost:8000'
    testObject.methods.getUserScope.host.protocol = 'http:'
    testObject.methods.getUserScope.call(users[0])
    @interval = setInterval ->
      if testObject.methods.getUserScope.resultState() == 0
        expect(testObject.methods.getUserScope.resultMessage()).toBe ""
        done()
    , 300
    setTimeout =>
      clearInterval @interval
      done()
    , 5000

  it "gets an error on getUserScope with a bogus user", (done) ->
    clearInterval @interval
    testObject.methods.getUserScope.host.host = 'localhost:8000'
    testObject.methods.getUserScope.host.protocol = 'http:'
    testObject.methods.getUserScope.call('wanglebangledanglefoobar')
    setTimeout ->
      expect(testObject.methods.getUserScope.resultState()).not.toBe 0
      done()
    , 4000
