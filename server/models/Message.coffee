{STRING, BOOLEAN, INTEGER} = require "sequelize"

module.exports = sequelize.define "Message",
  content:
    type: STRING
