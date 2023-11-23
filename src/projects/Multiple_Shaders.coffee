module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using two GLSL shaders in sequence to process an image. Sin Wave => Dithering => Pixelate. Thanks to https://github.com/aferriss/p5jsShaderExamples/blob/gh-pages/4_image-effects/4-10_two-pass-blur/sketch.js"
  @NO_SMOOTH = true

  @params = {
    period: 100.0,
    periodMin: 0.0,
    periodMax: 200.0,

    speed: 10.0,
    speedMin: 0.0,
    speedMax: 20.0,
    speedStep: 0.1,

    amp: 0.01
    ampMin: 0.0,
    ampMax: 0.1,
    ampStep: 0.001,

  }

  @preload = ->
    @img = @loadImage("public/brick.jpeg")

  @setup = ->
    scale = 0.2
    @img.resize(@width * scale, @height * scale)
    Project.gui = @createGui(this)
    Project.gui.addObject(Project.params)

  @draw = ->
    console.log(Project.params.x)
    @image(@output, -@width / 2, -@height / 2, @width, @height)

  Utils.addShaderSequence(this, [
    [Utils.Shaders.SinWave, {
      setUniforms: (shader) ->
        {
          period: Project.params.period,
          speed: Project.params.speed,
          amp: Project.params.amp
        }
    }],
    [Utils.Shaders.Dither, {}]
    [Utils.Shaders.Pixelate, {}]
  ],
  {
    input: -> @img,
    output: (result) -> @output = result
  })

  Project
.apply {}