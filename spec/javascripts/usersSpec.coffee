
  groupsViewModel = ko.components.Ub.groups.viewModel
  usersViewModel = ko.components.Ub.users.viewModel
  userViewModel = ko.components.Ub.user.viewModel

  window.pvm = new PVMAjax 'https', '192.168.92.146', 'soap', '8080', {protocol: 'http', host: 'localhost:8000'}
  pvm.username 'admin'
  pvm.password 'admin1'

  #override JS to point to server and not jasmine test runner
  pvm.host.host = 'localhost:8000'
  pvm.host.protocol = 'http:'

  pvm.login()

#  describe "loading Users and associating their roles with groups", ->
#
#    g = new Object()
#    u = new Object()
#
#    beforeEach (done)->
#      interval = setInterval ->
#        if Object.keys(pvm.methods).length > 160
#          clearInterval interval
#          g = new groupsViewModel()
#          u = new usersViewModel()
#          interval = setInterval ->
#            if g.groupsIndex().length > 0 && u.users().length > 0
#              clearInterval interval
#              done()
#          , 500
#      , 500
#
#    it "gets all the Groups from the PVM server", ->
#      expect(g.groupsIndex().length).toBeGreaterThan(0)
#
#    it "gets all the Users from the PVM server", ->
#      expect(u.users().length).toBeGreaterThan(0)
#
#    it "allows me to add a user", (done) ->
#      u.addUser {username: {value: 'wibbleflop'}, password: {value: 'flimflam'}, role: {value: 'admin'}}
#      setTimeout ->
#        expect(u.users().indexOf('wibbleflop')).toBeGreaterThan(-1)
#        done()
#      , 2000
#
#    it "allows me to delete a user", (done) ->
#      u.deleteUser 'wibbleflop'
#      setTimeout ->
#        expect(u.users().indexOf('wibbleflop')).toBe(-1)
#        done()
#      , 2000

  describe "Managing an individual user", ->

    g = new Object()
    u = new Object()
    user = new Object()

    beforeEach (done)->
      interval = setInterval ->
        if Object.keys(pvm.methods).length > 160
          clearInterval interval
          g = new groupsViewModel()
          u = new usersViewModel()
          interval = setInterval ->
            if g.groupsIndex().length > 0 && u.users().length > 0
              clearInterval interval
              user = new userViewModel name: u.users()[1]
              interval = setInterval ->
                if user.role() != "" && Object.keys(user.scope()).length > 0
                  clearInterval interval
                  done()
              , 300
          , 300
      , 300

    it "has a role for the user", ->
      expect(user.role().length).toBeGreaterThan(0)

    it "has a scope for the user", ->
      expect(Object.keys(user.scope()).length).toBeGreaterThan(0)

    it "returns a button css state depending on a role for a group", ->
      expect(user.scoped(user.role(), g.groupsIndex()[0]).buttoncss).not.toBe('')

    it "allows the state of the button to flip if the users role for the group is changed", (done) ->
      currentButtonCSS = user.scoped(user.role(), g.groupsIndex()[0]).buttoncss
      user.flipScope(user.role(), g.groupsIndex()[0])
      setTimeout ->
        expect(user.scoped(user.role(), g.groupsIndex()[0])().buttoncss).not.toBe(currentButtonCSS)
        done()
      , 3000
