

module.exports = class FeedController
  constructor: (@api, @$scope) ->
    @feedList = []
    @userStore = {}
    @api.request "feed"
    .then (res) =>
      # console.log res
      if res.feed
        @feedList.push item for item in res.feed
