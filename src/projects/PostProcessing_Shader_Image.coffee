module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using GLSL to post process an image."

  @Shader = Utils.Shaders.PostProcessSinWave

  @preload = ->
    Project.img = @loadImage("public/brick.jpeg")

  @setup = ->
    Project.img.resize(@width, @height)
    Project.Shader.setup.call(this, [Project.img])

  @draw = ->
    Utils.showFps.call(this)

    Project.Shader.draw.call(this, [Project.img])

  Project
.apply {}