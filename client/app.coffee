admin = require "./admin"
#fileread = require "./app/fileread"
app = angular.module "app", [
  "ui.router"
  "ngCookies"
  "ui.bootstrap"
  'ngFileUpload'
  # 'ngImgCrop'
  (require "./user").name
  (require "./travel").name
  #admin
  #fileread

]

console.log require "./travel/controller"

app.service "api", require "./app/api"


app.run ["$state", "api", ($state, api) ->
  api.auth (login) ->
    if login
      $state.go "travel.feed"
    else
      $state.go "user.login"
]
