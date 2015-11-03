{STRING, BOOLEAN, INTEGER} = require "sequelize"

module.exports = sequelize.define "Token",
  value:
    type: STRING
    unique: yes
    defaultValue: Api.generateToken()
