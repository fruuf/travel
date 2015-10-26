Api = require "api"

class UserRegisterController
  constructor: (@$state, @api, $stateParams) ->
    @email = $stateParams.email
    @$state.go "user" if not @email
    @name = @email
    match = @email.match /^(.+)@/
    if match
      @name = match[1].replace /[\._-]/g, " "
        .replace /\s+/g, " "
        .split " "
        .map (word) ->
          word = word.toLowerCase()
          "#{word.charAt(0).toUpperCase()}#{word.slice 1}"
        .join " "

  continue: ->
    if @email and @password and @password == @passwordRepeat
      @api.request "profile/register",
        email: @email
        password: @password
        name: @name
        file: @file
      .then (data) =>
        if data.token
          Api.setToken data.token
          @$state.go "travel.feed"
    else
      toastr.error "your passwords dont match"
      @passwordRepeat = ""

module.exports = ["$state", "api", "$stateParams", UserRegisterController]
