module.exports = ->
  Utils = this
  
  ########################################
  # Dont mess with the ordering here.
  # Some files depend on others being loaded beforehand.
  ########################################

  # TODO: Make loading dependencies more explicit

  @P5Wrapper = require './utils/p5_wrapper'
  @Draggable = require("./utils/draggable")
  
  Object.assign(this, require('./utils/cpu_pixel_utils')(this))
  Object.assign(this, require('./utils/cpu_pixel_operators')(this))

  @ShaderBuilder = require('./utils/shader_builder')
  @Shaders = require('./utils/shaders')(this)

  # Mixing are designed as feature sets which can be easily added to a project.
  @Mixins =
    BezierCreator: require('./utils/mixins/bezier_creator')(this)

  # ===============
  # Macros
  # ===============

  @applyMacro = (project, macro) ->
    Object.entries(macro).forEach ([key, addedFn]) ->
      orig = project[key]
      project[key] = (args...) ->
        orig?.call(this, args...)
        addedFn.call(this, args...)

  # ===============
  # Pixel / Shader utils
  # ===============

  @luminance = (pixel) ->
    0.299 * pixel[0] + 0.587 * pixel[1] + 0.114 * pixel[2]

  @checkShaderError = (shaderObj, shaderText) =>
    gl = shaderObj._renderer.GL
    glFragShader = gl.createShader(gl.FRAGMENT_SHADER)
    gl.shaderSource(glFragShader, shaderText)
    gl.compileShader(glFragShader)
    if !gl.getShaderParameter(glFragShader, gl.COMPILE_STATUS)
      return gl.getShaderInfoLog(glFragShader)
    return null

  # ===============
  # Shaping Functions
  # ===============

  @cubicBezier = (t, P0, P1, P2, P3) ->
    x = (1 - t) ** 3 * P0[0] + 3 * (1 - t) ** 2 * t * P1[0] + 3 * (1 - t) * t ** 2 * P2[0] + t ** 3 * P3[0]
    y = (1 - t) ** 3 * P0[1] + 3 * (1 - t) ** 2 * t * P1[1] + 3 * (1 - t) * t ** 2 * P2[1] + t ** 3 * P3[1]
    [x, y]

  @remap = (value, oldMin, oldMax, newMin, newMax) ->
    (value - oldMin) * (newMax - newMin) / (oldMax - oldMin) + newMin

  # ===============
  # UI Helpers
  # ===============
  
  @showFps = ->
    Utils.fps ||= $("#fps")
    Utils.fps.text("FPS: #{@frameRate().toFixed()}")

  @showMsg = (msg) ->
    Utils.custom_msg ||= $("#custom_msg")
    Utils.custom_msg.text(msg)

  Utils
.apply {}