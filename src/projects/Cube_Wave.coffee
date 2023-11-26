
module.exports = ->
  Project = this
  @DESCRIPTION = "Webgl 3d stuff. Taken from https://github.com/Carla-de-Beer/P5js-Projects/tree/master/cube-wave"
  @HAS_GUI = true
  @WEBGL = true

  w = 24;

  @setup = ->
    @distArray = [];
    @xArray = [];
    @zArray = [];
    @isoY = @atan(1 / @sqrt(2))
    @maxD = @dist(0, 0, 200, 200)
    @colorMode(@RGB)

    # Precompute geometries
    for z in [0...@height] by w
      for x in [0...@width] by w
        @zArray.push z
        @xArray.push x
        @distArray.push @dist(x, z, @width * 0.5, @height * 0.5)

  @draw = ->
    @background(100)
    @orbitControl()
    @ortho(-400 - w * 0.5, 400, 400, -400, 0, 1000)
    @rotateX(-@QUARTER_PI)
    @rotateY(@isoY)
    @ambientLight(255, 0, 0)
    @pointLight(200, 200, 200, 0, 0, 100)
    offset = 0.0
    for i in [0...@xArray.length]
      @push()
      d = @distArray[i]
      x = @xArray[i]
      z = @zArray[i]
      offset = @map(d, 0, @maxD, -@PI, @PI)
      h = @map(@sin(@angle + offset), -1, 1, 25, 225)
      @translate(x - @width * 0.5, 0, z - @height * 0.5)
      @ambientMaterial(h, 255, 255 - h)
      @box(w - 1, h, w - 1)
      @pop()
    @angle -= 0.2

  Project
.apply {}