module.exports = ->
  Utils = this
  
  ########################################
  # Dont mess with the ordering here.
  # Some files depend on others being loaded beforehand.
  ########################################

  # TODO: Make loading dependencies more explicit

  @P5Wrapper = require './utils/p5_wrapper'
  @Draggable = require("./utils/draggable")

  @Noise = require './utils/noise'
  
  Object.assign(this, require('./utils/cpu_pixel_utils')(this))
  @PixelOps = require('./utils/cpu_pixel_operators')(this)

  @ShaderBuilder = require('./utils/shader_builder')
  @Shaders = require('./utils/shaders')(this)

  # Mixing are designed as feature sets which can be easily added to a project.
  @Macros = require("./utils/macros")(this)

  @webglNoSmooth = (img) ->
    @_canvas.getTexture(img).setInterpolation(@NEAREST, @NEAREST);

  # ===============
  # GUI
  # ===============
  @addGui = (p5, params_object) ->
    p5._gui = p5.createGui(p5)
    p5._gui.addObject(params_object)
    { top, right } = p5.canvas.getBoundingClientRect()
    offset = p5._gui.content().getBoundingClientRect().width
    p5._gui.setPosition(right - offset, top)
    p5._gui

  # ===============
  # Macros
  # TODO: move these to macros file
  # ===============

  @applyMacro = (project, macro) ->
    Object.entries(macro).forEach ([key, addedFn]) ->
      orig = project[key]
      project[key] = (args...) ->
        orig?.call(this, args...)
        addedFn.call(this, args...)

  # input and output are functions, called with `this` set to the p5 instance.
  # they should determine where to fetch the input from and where to draw the output to.
  # Note that this function assumes the shader has a sampler2D uniform called 'p5Drawing'.
  @addShaderSequence = (project, shaders, {input, output}) ->
    if shaders.length == 0
      throw "Shader Sequence needs at least one entry. Use Noop shader if you don't want to do anything."

    shaders.forEach ([shader, {setup, setUniforms}], idx) =>
      userSetup = setup
      userSetUniforms = setUniforms

      shaderMacro = shader(
        add: (shader) ->
          this["graphics#{idx}"] = @createGraphics(@width, @height, @WEBGL)
          if idx == shaders.length - 1
            output.call(this, this["graphics#{idx}"])
          this["graphics#{idx}"].shader(shader)

        setup: (shader) ->
          userSetup?.call(this, shader)

        setUniforms: (shader) ->
          this["graphics#{idx}"].rect(-@width/2, -@height/2, @width, @height);
          source = if idx == 0 then input.call(this) else this["graphics#{idx-1}"]
          shader.setUniform('p5Drawing', source)
          userSetUniforms?.call(this, shader)
      )
      Utils.applyMacro project, shaderMacro

  # ===============
  # Pixel / Shader utils
  # TODO: move these to somewhere else
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
  # TODO: move somewhere else
  # ===============

  @cubicBezier = (t, P0, P1, P2, P3) ->
    x = (1 - t) ** 3 * P0[0] + 3 * (1 - t) ** 2 * t * P1[0] + 3 * (1 - t) * t ** 2 * P2[0] + t ** 3 * P3[0]
    y = (1 - t) ** 3 * P0[1] + 3 * (1 - t) ** 2 * t * P1[1] + 3 * (1 - t) * t ** 2 * P2[1] + t ** 3 * P3[1]
    [x, y]

  @remap = (value, oldMin, oldMax, newMin, newMax) ->
    (value - oldMin) * (newMax - newMin) / (oldMax - oldMin) + newMin

  # ===============
  # UI Helpers
  # TODO: move to own file
  # ===============
  
  @showFps = ->
    Utils.fps ||= $("#fps")
    Utils.fps.text("FPS: #{@frameRate().toFixed()}")

  @showMsg = (msg) ->
    Utils.custom_msg ||= $("#custom_msg")
    Utils.custom_msg.text(msg)

  Utils
.apply {}