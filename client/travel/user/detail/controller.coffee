class TravelUserDetailController
  constructor: (@api, $stateParams, $scope) ->
    @user = {}
    @api.request "user/detail",
      user: $stateParams.user
    .then (res) =>
      @locations = res.locations
      @user = res.user
      description = []
      description.push res.user.country if user.country
      description.push res.user.profession if user.profession
      description.push res.distance.formatted if res.distance
      @user.description = description


    $scope.$on "user.update", (event, data) =>
      if data._id == @user._id
        @user = _.merge @user, data
        $scope.$digest()

module.exports = ["api","$stateParams", "$scope", TravelUserDetailController]
