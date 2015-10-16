Number.prototype.toRadians = ->
  @ * Math.PI / 180

module.exports = class FeedController
  constructor: (@api, @$scope) ->
    @feedList = []
    @userStore = {}
    @api.request "feed"
    .then (res) =>
      if res.feed
        @feedList = @feedList.concat res.feed
        @calcDistance()

  calcDistance: ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition (pos) =>
        lat1 = pos.coords.latitude
        lon1 = pos.coords.longitude

        for feed in @feedList
          if (not feed.distance) and feed.lat and feed.lng
            lat2 = feed.lat
            lon2 = feed.lng

            R = 6371000
            φ1 = lat1.toRadians()
            φ2 = lat2.toRadians()
            Δφ = (lat2-lat1).toRadians()
            Δλ = (lon2-lon1).toRadians()

            a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2)

            c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
            d = R * c
            feed.distance = "#{d}m"


        @$scope.$digest()
