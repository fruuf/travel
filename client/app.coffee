admin = require "./admin"
Api = require "api"
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


app.factory "api", ["$q", ($q) ->
  new class AngularApi extends Api
    request: (action, data = {}) ->
      $q (resolve, reject) =>
        super action, data
        .then resolve, reject
      .catch (err) ->
        toastr.error err.message
]

app.run ["$state", "api", "$rootScope", ($state, api, $rootScope) ->
  api.request "profile/auth"
  .then (data) ->
    if data.auth
      $state.go "travel.feed"
    else
      $state.go "user.login"
  events = [
    "conversation/update"
    "user/update"

  ]
  for event in events
    do (event) ->
      api.action event, (data) ->
        $rootScope.$broadcast event, data


]
