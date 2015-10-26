Api = require "api"
Api.debug = on
#fileread = require "./app/fileread"
module.exports = angular.module "app", [
  "ui.router"
  "ngCookies"
  'ngFileUpload'
  (require "./user").name
  (require "./travel").name
]


.factory "api", ["$q", "$rootScope", "$state", ($q, $rootScope, $state) ->
  $rootScope.loading = no
  new class AngularApi extends Api
    request: (action, data = {}) ->
      $rootScope.loading = yes
      promise = $q (resolve, reject) =>
        super action, data
        .then resolve, reject
      .catch (err) ->
        if err.message == "auth"
          $state.go "user"
        else
          toastr.error err.message
      promise.finally ->
        if Api.activeRequests == 0
          $rootScope.loading = no
      promise
]
.controller "IndexController", ["$state", "api", class IndexController
  constructor: ($state, api) ->
    api.request "profile/auth"
    .then (data) ->
      if data.auth
        $state.go "travel.feed"
      else
        $state.go "user"
]
.config ["$stateProvider", "$urlRouterProvider", ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise "/index"
  $stateProvider
  .state "index",
    url: "/index"
    views:
      "main@":
        template: require "./template"
        controller: "IndexController as IndexCtrl"
]

.run ["api", "$rootScope", "$state", "$stateParams", (api, $rootScope, $state, $stateParams) ->
  $rootScope.$state = $state
  $rootScope.$stateParams = $stateParams
  events = [
    "conversation/update"
    "user/update"

  ]
  for event in events
    do (event) ->
      api.action event, (data) ->
        $rootScope.$broadcast event, data


]
