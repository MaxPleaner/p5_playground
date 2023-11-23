module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Mandelbrot shader written in a GLSL string. See https://p5js.org/reference/#/p5/createShader"

  @draw = ->
      @rect(-@width/2, -@height/2, @width, @height);

  Utils.applyMacro this, Utils.Shaders.Mandelbrot(
    add: (shader) ->
      @shader(shader)
  )

  Project
.apply {}