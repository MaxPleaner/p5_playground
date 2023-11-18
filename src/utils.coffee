module.exports = ->
  Utils = this
  
  ########################################
  # Dont mess with the ordering here.
  # Some files depend on others being loaded beforehand.
  ########################################

  # TODO: Make loading dependencies more explicit

  @P5Wrapper = require './utils/p5_wrapper'
  
  Object.assign(this, require('./utils/cpu_pixel_utils')(this))
  Object.assign(this, require('./utils/cpu_pixel_operators')(this))

  @ShaderBuilder = require('./utils/shader_builder')
  @Shaders = require('./utils/shaders')(this)

  @showFps = ->
    Utils.fps ||= $("#fps")
    Utils.fps.text("FPS: #{@frameRate().toFixed()}")

  Utils
.apply {}