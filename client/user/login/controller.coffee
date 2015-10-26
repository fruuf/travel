Api = require "api"

class UserLoginController
  constructor: (@$state, @api, @$stateParams) ->
    @password = ""
    @email = @$stateParams.email
    @$state.go "user" if not @email

  continue: ->
    if @email and @password
      @api.request "profile/login",
        email: @email
        password: @password
      .then (data) =>
        if data.token
          Api.setToken data.token
          @$state.go "travel.feed"

module.exports = ["$state", "api", "$stateParams", UserLoginController]
