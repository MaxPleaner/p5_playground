module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Mandelbrot shader written in a GLSL string. See https://p5js.org/reference/#/p5/createShader"

  @Shader = Utils.Shaders.Mandelbrot

  @draw = ->
    Project.Shader.draw.call(this)

  @onSetup = ->
    Project.Shader.setup.call(this)

  Project
.apply {}