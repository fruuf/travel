user = require "./user"
travel = require "./travel"
admin = require "./admin"
app = angular.module "app", [
  "ui.router"
  "ngCookies"
  "ui.bootstrap"
  user
  travel
  admin
]

app.service "api", require "./app/api"


app.run ($state, api) ->
  api.auth (login) ->
    if login
      $state.go "travel.feed"
    else
      $state.go "user.login"
