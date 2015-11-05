module.exports = angular.module "appDistance", [

]
.filter "distance", ->
  (distance) ->
    if distance
      log = Math.floor (Math.log distance) / (Math.log 10)
      shift = log - 1
      rel = Math.round Math.pow(10, shift) * Math.round (distance * (Math.pow 10, - shift))
      if log > 2
        "#{rel / 1000}km"
      else
        "#{rel}m"
    else
      ""
