module.exports = ->
  Project = this

  @DESCRIPTION = "Using Image filters on things besides images. In this case, some procedural RGB noise. Essentially we just draw our shapes into a `createGraphics()` and then call `image()` with that. See https://p5js.org/reference/#/p5/filter"
  @NO_LOOP = true

  @setup = ->
    # We create a 2d canvas that the line drawing is produced on
    @g = @createGraphics(@width, @height);

    freq = 0.01
    @g.noStroke()

    for x in [0..@width] by 4
      for y in [0..@height] by 4
        col = [0..2].map (i) =>
          @noise(freq * x + (i * 1000), freq * y + (i * 1000)) * 255
        @g.fill(col);
        @g.rect(x, y, 4, 4);

    @image(@g, 0, 0, @width, @height);

    # THRESHOLD, GRAY, OPAQUE, INVERT, POSTERIZE, BLUR, ERODE, DILATE or BLUR
    @filter(@POSTERIZE, 9)

  # @draw = ->
  #   Utils.showFps.call(this)

  Project
.apply {}