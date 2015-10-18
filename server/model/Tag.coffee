mongoose = require "mongoose"
Schema = mongoose.Schema
tagSchema = Schema
  name: String
  user: [
    ref:
      type: Schema.Types.ObjectId
      ref: "User"
      index: yes
    pos: Number
    neg: Number
  ]
  location: [
    ref:
      type: Schema.Types.ObjectId
      ref: "Location"
      index: yes
    coords: [Number, Number]
    multiplier:
      type: Number
      min: -1
      max: 1  
  ]
  createdAt:
    type: Date
    default: Date.now


tagSchema.methods.toJSON = ->
  obj = this.toObject()
  delete obj.user
  # delete obj.token
  obj


module.exports = mongoose.model "Tag", tagSchema
