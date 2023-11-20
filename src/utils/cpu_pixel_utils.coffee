module.exports = (Utils) ->
  ->
    # Updating each pixel individually (shader style) has decent performance.
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

    # performance here is a bit more sensitive.
    # Fn is called with a list of all pixels e.g. [[r,g,b,a], [r,g,b,a], ...]
    # Use .get(x,y) and .set(x,y,val) in the callback to read and write values.
    @update_image_pixels = (img, fn) ->  
      img.loadPixels()
      fn.call(this, img)
      img.updatePixels()

    this
  .apply {}