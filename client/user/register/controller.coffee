class UserRegisterController
  constructor: (@$state, @api) ->
    @data = {}

  register: ->
    if @data.email and @data.password and @data.password == @data.passwordRepeat
      @api.request "profile/register", @data
      .then (data) =>

        toastr.success "Registration successful"
        @$state.go "user.login",
          email: @data.email
      , (err) ->
        toastr.error "Invalid credentials"

    else
      toastr.error "Invalid credentials"

module.exports = ["$state", "api", UserRegisterController]
