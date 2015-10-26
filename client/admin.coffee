Api = require "api"
console.log (require "./admin/index")
app = angular.module "app", [
  "ui.router"
  "ngCookies"
  'ngFileUpload'
  (require "./admin/index").name
]


app.factory "api", ["$q", "$rootScope", ($q, $rootScope) ->
  $rootScope.loading = no
  new class AngularApi extends Api
    request: (action, data = {}) ->
      $rootScope.loading = yes
      promise = $q (resolve, reject) =>
        super action, data
        .then resolve, reject
      .catch (err) ->
        toastr.error err.message
      promise.finally ->
        $rootScope.loading = no
      promise
]

app.run ["$state", "api", ($state, api) ->
  api.request "admin/auth"
  .then (data) ->
    if data.auth
      $state.go "admin"
    else
      $state.go "admin.denied"
]
