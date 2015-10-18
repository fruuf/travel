admin = angular.module "admin", ["app"]

admin.controller "AdminController", require "./admin-controller"
admin.controller "AdminLocationController", require "./location-controller"
admin.controller "AdminLocationItemController", require "./location-item-controller"

admin.config ($stateProvider) ->
  $stateProvider
  .state "admin",
    url: "/admin"
    views:
      "main@":
        template: require "./admin-template"
        controller: "AdminController as AdminCtrl"

  .state "admin.location",
    url: "/location"
    views:
      "main@":
        template: require "./location-template"
        controller: "AdminLocationController as AdminCtrl"

  .state "admin.location.item",
    url: "/:item"
    views:
      "main@":
        template: require "./location-item-template"
        controller: "AdminLocationItemController as AdminCtrl"
