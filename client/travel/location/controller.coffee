_ = require "lodash"

class LocationController
  constructor: (@api) ->
    @api.request "location"
    .then (res) =>
      console.log res
      @locations = res.locations

module.exports = ["api", LocationController]
