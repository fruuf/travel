Sequelize = require "sequelize"
config = require "../../config"
global.sequelize = new Sequelize config.mysql.database, config.mysql.username, config.mysql.password,
  dialect: "mysql"

global.Conversation = require "./Conversation"
global.Image = require "./Image"
global.Location = require "./Location"
global.Message = require "./Message"
global.Tag = require "./Tag"
global.Token = require "./Token"
global.User = require "./User"

User.belongsToMany Conversation,
  through: 'ConversationUser'
Conversation.belongsToMany User,
  through: 'ConversationUser'

Conversation.hasMany Message,
Message.belongsTo Conversation

Message.belongsTo User



Location.belongsToMany Tag,
  through: 'LocationTag'
Tag.belongsToMany Location,
  through: 'LocationTag'

Location.hasMany Image

Token.belongsTo User
User.hasMany Token

User.hasMany Image

User.belongsToMany Location,
  through: 'LocationUser'
Location.belongsToMany User,
  through: 'LocationUser'

sequelize.sync()
###
sequelize
.query 'SET FOREIGN_KEY_CHECKS = 0',
  raw: true
.then ->
  sequelize.sync
    force: true
###
