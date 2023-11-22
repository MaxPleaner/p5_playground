module.exports = ->
  Project = this

  @DESCRIPTION = "Using Image filters on things besides images. In this case, some procedural RGB noise. Essentially we just draw our shapes into a `createGraphics()` and then call `image()` with that. See https://p5js.org/reference/#/p5/filter"
  # @NO_LOOP = true
  @WEBGL = true
  @NO_SMOOTH = true

  @setup = ->
    @g = @createGraphics(@width, @height);

  @draw = ->
    speed = 1.5
    offset = @frameCount * 0.005
    freq = 0.01
    pow = 1.02
    @g.noStroke()
    for x in [0..@width] by 4
      for y in [0..@height] by 4
        col = [0..2].map (i) =>
          val = @noise(freq * x, freq * y, offset + i * speed) * 255
          Math.max(0, Math.min(255, Math.pow(val, pow)))
          # val
          # @noise(freq * x + offset + (i * 1000), freq * y + (i * 1000)) * 255
        @g.fill(col);
        @g.rect(x, y, 4, 4);

    @image(@g, -@width / 2, -@height / 2, @width, @height);

    # THRESHOLD, GRAY, OPAQUE, INVERT, POSTERIZE, BLUR, ERODE, DILATE or BLUR
    @filter(@POSTERIZE, 6)

  Project
.apply {}