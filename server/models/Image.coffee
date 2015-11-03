shortid = require "shortid"
fs  = require "fs"
path = require "path"
sharp = require 'sharp'
q = require "q"
{STRING, BOOLEAN, INTEGER} = require "sequelize"
imagePath = path.join process.cwd(), "public"


module.exports = sequelize.define "Image",
  small:
    type: STRING
    defaultValue: "/files/#{shortid.generate()}.jpeg"
  medium:
    type: STRING
    defaultValue: "/files/#{shortid.generate()}.jpeg"
  large:
    type: STRING
    defaultValue: "/files/#{shortid.generate()}.jpeg"
  hasFile: BOOLEAN
  primary: BOOLEAN
,
  instanceMethods:
    setFile: (file) ->
      q()
      .then =>
        sharp file
        .jpeg()
        .quality 80
        .resize 426, 240
        .toFile "#{imagePath}#{@small}"
      .then =>
        sharp file
        .jpeg()
        .quality 80
        .resize 854, 480
        .toFile "#{imagePath}#{@medium}"
      .then =>
        sharp file
        .jpeg()
        .quality 80
        .resize 1280, 720
        .toFile "#{imagePath}#{@large}"
      .then =>
        @hasFile = yes
        @save()

  hooks:
    beforeDestroy: (image, options) ->
      if image.hasFile
        fs.unlink (path.join imagePath, image.small)
        fs.unlink (path.join imagePath, image.medium)
        fs.unlink (path.join imagePath, image.large)
