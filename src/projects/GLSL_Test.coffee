module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Mandelbrot shader written in a GLSL string. See https://p5js.org/reference/#/p5/createShader"

  Utils.applyMacro this, Utils.Shaders.Mandelbrot(
    add: (shader) ->
      @shader(shader)
    draw: (shader) ->
      @rect(-@width/2, -@height/2, @width, @height);
  )

  Project
.apply {}