Number.prototype.toRadians = ->
  @ * Math.PI / 180

module.exports =
  calculate: (coordsA, coordsB) ->
    result = no
    # console.log "distance", coordsA, coordsB
    if coordsA and coordsB and coordsA[0] and coordsA[1] and coordsB[0] and coordsB[1]
      lat1 = coordsA[1]
      lon1 = coordsA[0]

      lat2 = coordsB[1]
      lon2 = coordsB[0]

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
      formatted = "0m"
      if d
        log = Math.floor (Math.log d) / (Math.log 10)
        shift = log - 1
        rel = Math.pow(10, shift) * Math.round (d * (Math.pow 10, - shift))
        if log > 2
          formatted = "#{rel / 1000}km"
        else
          formatted = "#{rel}m"

      result =
        distance: Math.round d
        formatted: formatted

    result
