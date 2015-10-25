class TravelProfileController
  constructor: ( @api, @$scope ) ->
    @api.request "profile"
    .then (res) =>
      @profile = res.profile

  update: ->
    @api.request "profile/update", @profile
    .then (res) =>
      @profile = res.profile
      toastr.success "Update successful"

module.exports = ["api", "$scope", TravelProfileController]
