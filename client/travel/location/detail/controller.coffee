class TravelLocationDetailController
  constructor: (@api, $stateParams) ->
    @api.request "location/detail",
      location: $stateParams.location
    .then (res) =>
      @location = res.location
      @users = res.users
      @status = res.status

  setStatus: (status) ->
    @api.request "location/status",
      location: @location._id
      status: status
    .then (res) =>
      @status = status

module.exports = ["api","$stateParams", TravelLocationDetailController]
