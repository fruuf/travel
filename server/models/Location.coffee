{STRING, BOOLEAN, INTEGER, GEOMETRY} = require "sequelize"

module.exports = sequelize.define "Location",
  halfDistance:
    type: INTEGER
    defaultValue: 10
  name: STRING
  address: STRING
  position:
    type: GEOMETRY "POINT"
