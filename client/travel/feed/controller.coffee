class FeedController
  constructor: (@api, @$scope) ->
    @feed = []
    @type = no
    @api.request "feed"
    .then (res) =>
      for item in res.feed
        item.hidden = no
        @feed.push item



  filter: (type) ->
    if @type == type
      @type = no
    else
      @type = type

    for item in @feed
      if @type and not (item.type == @type)
        item.hidden = yes
      else
        item.hidden = no


module.exports = ["api", "$scope", FeedController]
