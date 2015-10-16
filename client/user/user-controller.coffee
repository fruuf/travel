

module.exports = class UserController
  constructor: (@$state, @api) ->

  login: (user) ->
    if user.email and user.password
      @api.request "user/login", user
      .then (data) =>
        if data.token
          @api.token data.token


  register: (user) ->
    if user.email and user.password and user.password == user.passwordRepeat
      @api.request "user/register", user
      .then (data) =>
        if data.err
          console.log data.err
          toastr.error "Invalid credentials"
        else if data.user
          toastr.success "Registration successful"
          #@UserService.setUser data.user
          #@UserService.connect()
          @$state.go "user.login"
    else
      toastr.error "Invalid credentials"
