Api = require "api"
app = angular.module "app", [
  "ui.router"
  "ngCookies"
  'ngFileUpload'
  (require "./admin/index").name
]


app.factory "api", ["$q", "$rootScope", ($q, $rootScope) ->
  $rootScope.loading = no
  new class AngularApi extends Api
    request: (action, data = {}, timeout = 10000) ->
      $rootScope.loading = yes
      promise = $q (resolve, reject) =>
        super action, data, timeout
        .then resolve, reject
      .catch (err) ->
        console.log err
        toastr.error err.message
        err

      promise.finally ->
        $rootScope.loading = no
      promise
]


app.run ["$state", "api", ($state, api) ->
  api.request "admin/auth"
  .then (data) ->
    console.log data
    if data.auth
      $state.go "admin"
    else
      $state.go "admin.denied"
  , (err) ->
    console.log err
]
