module.exports = ->
  @DESCRIPTION = "Manipulating pixels one by one in a CPU loop. Use mouse to control. Bad performance is, expected, unfortunately. See https://p5js.org/reference/#/p5/pixels"
  @WEBGL = true

  @draw = ->
    @fill 255
    @ellipse @mouseX - @width / 2, @mouseY - @height / 2, 50, 50

    Utils.update_each_pixel.call this, (pixel) ->
      pixel = Utils.PixelOps.brighten(pixel, 0.95)
      pixel = Utils.PixelOps.threshold pixel, 20, 255
      pixel

  this
.apply {}