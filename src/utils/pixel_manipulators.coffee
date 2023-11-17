module.exports = ->
  @update_each_pixel = (fn) ->
    @loadPixels()
    density = @pixelDensity()
    num_pixels = 4 * (density * @width) * (density * @height)

    for i in [0..num_pixels] by 4
      # performance is very sensitive in here
      # avoiding map, slice, etc. to preserve frame rate
      [r, g, b, a] = [
        @pixels[i], @pixels[i + 1],
        @pixels[i + 2], @pixels[i + 3]
      ]

      pixel = fn([r,g,b,a])

      @pixels[i] = pixel[0]
      @pixels[i + 1] = pixel[1]
      @pixels[i + 2] = pixel[2]
      @pixels[i + 3] = pixel[3]

    @updatePixels()

  this
.apply {}