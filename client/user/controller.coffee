Api = require "api"

class UserController
  constructor: (@$state, @api, @$cookies) ->
    @email = ""
    if @$cookies.get "email"
      @email = @$cookies.get "email"

  continue: ->
    exp = new Date()
    exp.setDate exp.getDate() + 50
    @$cookies.put "email", @email,
      expires: exp

    @api.request "profile/auth",
      email: @email
    .then (data) =>
      if data.auth
        @$state.go "travel.feed"
      else if data.email
        @$state.go ".login",
          email: @email
      else
        @$state.go ".register",
          email: @email


module.exports = ["$state", "api", "$cookies",  UserController]
