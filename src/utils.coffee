module.exports = ->
  @P5Wrapper = require './utils/p5_wrapper'
  Object.assign(this, require('./utils/pixel_manipulators'))

  this
.apply {}