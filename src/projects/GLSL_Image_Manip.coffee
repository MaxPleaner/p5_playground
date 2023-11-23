module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using GLSL to post process an image."
  @NO_SMOOTH = true

  @PARAMS = [
    { name: "period", type: "float", default: 30, min: 0, max: 100 },
    { name: "speed", type: "float", default: 10, min: 0, max: 100 },
    { name: "amp", type: "float", default: 0.02, min: 0, max: 0.1 }
  ]

  @preload = ->
    @img = @loadImage("public/brick.jpeg")

  @setup = ->
    @img.resize(@width, @height)

  @draw = ->
    @rect(-@width/2, -@height/2, @width, @height);

  Utils.applyMacro this, Utils.Shaders.SinWave(
    add: (shader) ->
      @shader(shader)
    setUniforms: (shader) ->
      p5Drawing: @img
  )

  Project
.apply {}