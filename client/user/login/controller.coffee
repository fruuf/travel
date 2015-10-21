class UserLoginController
  constructor: (@$state, @api, @$cookies, $stateParams) ->
    @data = {}
    if @$cookies.get "email"
      @data.email = @$cookies.get "email"
    if $stateParams.email
      @data.email = $stateParams.email

  login: ->
    exp = new Date()
    exp.setDate exp.getDate() + 50
    @$cookies.put "email", @data.email,
      expires: exp
    if @data.email and @data.password
      @api.request "profile/login", @data
      .then (data) =>
        if data.token
          @api.token data.token

module.exports = ["$state", "api", "$cookies", "$stateParams", UserLoginController]
