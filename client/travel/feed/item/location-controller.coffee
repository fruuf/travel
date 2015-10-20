module.exports = class TravelFeedLocationController
  constructor: (@api, @$scope, $stateParams) ->
    @api.request "location",
      location: $stateParams.location
    .then (res) =>
      console.log res
      @location = res.location
      @user = res.user
      @status = res.status

  setStatus: (location, status) ->
    @api.request "location/setStatus",
      location: location
      status: status
    .then (res) =>
      @status = status
