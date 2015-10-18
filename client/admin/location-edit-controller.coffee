module.exports = class LocationEditController
  constructor: (@api, @$state, $stateParams, @$scope) ->
    #console.log "maps", google.maps
    @geocoder = new google.maps.Geocoder()
    @api.request "admin/locationEditLoad",
      location: $stateParams.location
    .then (res) =>
      @location = res.location
      @tag = res.tag

  lookup: (address) ->
    @geocoder.geocode
      'address': address
    , (results, status) =>
      if status == google.maps.GeocoderStatus.OK and results.length
        res = results[0]
        console.log res
        @location.address = res.formatted_address
        location = res?.geometry?.location
        #console.log location
        if location
          @location.coords = [location.lng(), location.lat()]

        @$scope.$digest()
      else
        toastr.error status

  save: ->
    @api.request "admin/locationEditSave", @location
    .then (res) =>
      toastr.success "location saved"
      
