admin = angular.module "admin", ["app"]
module.exports = admin.name

admin.controller "AdminController", require "./admin-controller"
admin.controller "AdminLocationController", require "./location-controller"
admin.controller "AdminLocationEditController", require "./location-edit-controller"

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
      "content@admin":
        template: require "./location-template"
        controller: "AdminLocationController as LocationCtrl"

  .state "admin.location.edit",
    url: "/:location"
    views:
      "content@admin":
        template: require "./location-edit-template"
        controller: "AdminLocationEditController as EditCtrl"
