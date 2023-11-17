module.exports = ->
  First = this

  @draw = ->
    @fill 255
    @ellipse @mouseX, @mouseY, 50, 50

    Utils.update_each_pixel.call this, ([r,g,b,a]) ->
      [r * 0.1, g, b, a]

  this
.apply {}