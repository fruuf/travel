class TravelProfileController
  constructor: ( @api, @$scope ) ->
    @api.request "profile"
    .then (res) =>
      @profile = res.profile

  update: ->
    if @profilePicture
      @api.sendFile @profilePicture
    @api.request "profile/update", @profile
    .then (res) =>
      toastr.success "Update successful"

module.exports = ["api", "$scope", TravelProfileController]
