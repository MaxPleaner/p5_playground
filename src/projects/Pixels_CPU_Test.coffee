module.exports = ->
  Project = this

  @BACKGROUND_COLOR = [255, 0, 0]
  @DESCRIPTION = "Manipulating pixels one by one in a CPU loop. See https://p5js.org/reference/#/p5/pixels"

  @draw = ->
    Utils.showFps.call(this)
    @fill 255
    @ellipse @mouseX, @mouseY, 50, 50

    Utils.update_each_pixel.call this, (pixel) ->
      pixel = Utils.brighten(pixel, 0.95)
      pixel = Utils.threshold pixel, 20, 255
      pixel

  Project
.apply {}