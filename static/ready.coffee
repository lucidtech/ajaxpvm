window.pvm = new PVMAjax 'https', '192.168.92.146', 'soap', '8080'

#bypass manual login for testing
pvm.username 'admin'
pvm.password 'admin1'
pvm.login()
waitForLogin =  setInterval ->
                  if pvm.loginSuccess()
                    clearInterval waitForLogin
                    ko.applyBindings()
                , 500