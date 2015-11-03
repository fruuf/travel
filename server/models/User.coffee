bcrypt = require "bcrypt"
{STRING, BOOLEAN, INTEGER, GEOMETRY} = require "sequelize"

module.exports = sequelize.define "User",
  email:
    type: STRING
    unique: yes
    validate:
      isEmail: yes
  password: STRING
  name: STRING
  country: STRING
  profession: STRING
  about: STRING
  online: BOOLEAN
  admin: BOOLEAN
  position:
    type: GEOMETRY "POINT"
,
  instanceMethods:
    setPassword: (password) ->
      salt = bcrypt.genSaltSync(10)
      hash = bcrypt.hashSync(password, salt)
      @password = hash
      @save()
    verifiyPassword: (password) ->
      bcrypt.compareSync password, @password
