requestStore = {}
requestCounter = 0
authActionFire = no
authAction = no
delivery = no

class api
  constructor: (@$q, $rootScope, @$cookies) ->
    $rootScope.user = @user = {}
    @login = no
    @socket = io()
    @socket.on 'connect', =>
      dl = new Delivery @socket

      dl.on 'delivery.connect', (dl) ->
        delivery = dl

      token = @$cookies.get "token"
      if token
        @socket.emit "token",
          token: token
          oldToken: no
      else
        authActionFire = yes


    @socket.on "response", (data) ->
      request = requestStore[data.id]
      if data.err
        toastr.error data.err
        request.reject data.err
      else
        request.resolve data.data

    @socket.on "server", (res) ->
      console.log "server", res.type, res.data
      $rootScope.$broadcast res.type, res.data

    @socket.on "token", (res) =>
      if res.user
        @login = res.user
        if navigator.geolocation
          navigator.geolocation.getCurrentPosition (pos) =>
            coords = [
              pos.coords.longitude
              pos.coords.latitude
            ]
            @socket.emit "location", coords
      else
        @login = no
        @$cookies.remove "token"

      if authAction
        authAction @login
      else
        authActionFire = yes




  auth: (cb) ->
    authAction = cb
    if authActionFire
      authActionFire = no
      authAction @login
    @


  token: (token = no) ->
    oldToken = @$cookies.get "token"
    exp = new Date()
    exp.setDate exp.getDate() + 50
    @$cookies.put "token", token,
      expires: exp
    @socket.emit "token",
      oldToken: oldToken
      token: token
    @

  request: (target, data = {}) ->
    deferred = @$q.defer()
    timeout = window.setTimeout ->
      toastr.error "timeout (10sek)"
      deferred.reject
        err: "timeout"
    , 10000

    requestCounter = requestCounter + 1
    do (requestCounter) =>
      request =
        reject: (data) ->
          window.clearTimeout timeout
          delete requestStore[requestCounter]
          deferred.reject data
        resolve: (data) ->
          window.clearTimeout timeout
          delete requestStore[requestCounter]
          deferred.resolve data

      requestStore[requestCounter] = request
      @socket.emit "request",
        target: target
        data: data
        id: requestCounter
    deferred.promise

  sendFile: (file) ->
    delivery.send file

module.exports = ["$q", "$rootScope", "$cookies", api]
