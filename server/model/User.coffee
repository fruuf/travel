mongoose = require "mongoose"
Schema = mongoose.Schema

userSchema = Schema
  token: [
      value:
        type: String
        index: on
      lastUsed:
        type: Date
        default: Date.now
      created:
        type: Date
        default: Date.now
    ]
  createdAt:
    type: Date
    default: Date.now
  updatedAt:
    type: Date
    default: Date.now
  email:
    type: String
    required: yes
    unique: yes
    index: yes
  password: String
  name: String
  country: String
  profession: String
  about: String
  online: Boolean
  coords:
    type: [Number,Number]
    index: "2d"

userSchema.methods.toJSON = ->
  obj = this.toObject()
  delete obj.password
  delete obj.token
  delete obj.email
  obj


module.exports = mongoose.model "User", userSchema
