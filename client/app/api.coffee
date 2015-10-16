requestStore = {}
requestCounter = 0
authActionFire = no
authAction = no

module.exports = class api
  constructor: (@$q, $rootScope, @$cookies) ->
    $rootScope.user = @user = {}
    @login = no
    @socket = io()
    @socket.on "response", (data) ->
      request = requestStore[data.id]
      if data.data.err
        request.reject data.data
      else
        request.resolve data.data

    @socket.on "server", (res) ->
      console.log "server", res.type, res.data
      $rootScope.$broadcast res.type, res.data

    @socket.on "token", (res) =>
      if res.user
        @login = res.user
      else
        @login = no
        @$cookies.remove "token"

      if authAction
        authAction @login
      else
        authActionFire = yes

    token = @$cookies.get "token"
    if token
      @socket.emit "token",
        token: token
        oldToken: no
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
    @$cookies.put "token", token
    @socket.emit "token",
      oldToken: oldToken
      token: token
    @

  request: (target, data = {}) ->
    deferred = @$q.defer()
    timeout = window.setTimeout ->
      console.log "err_timeout"
      deferred.reject
        err: "timeout"
    , 2000

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
