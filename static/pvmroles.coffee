class PVMRoles

  constructor : (@pvm) ->
    @rolesDictionary = new Object
    @init()

  init: ->
    @pvm.methods.listRolesEx.call (r) =>
      if r[0] == 0
        @rolesDictionary = r[2]

  list: ->
    Object.keys @rolesDictionary

  aclFor : (role) ->
    @rolesDictionary[role]

window.PVMRoles = PVMRoles