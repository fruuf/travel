{STRING, BOOLEAN, INTEGER} = require "sequelize"

module.exports = sequelize.define "Tag",
  name:
    type: STRING
    unique: yes
