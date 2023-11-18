module.exports = (Utils) ->
  ->
    # Updating each pixel individually (shader style) has good performance.
    # Fn is called with each [r,g,b,a] pixel value.
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

    # performance here is a bit more shifty
    # Fb is called with the full list of [r,g,b,a] pixels.
    @update_all_pixels = (fn) ->

    this
  .apply {}