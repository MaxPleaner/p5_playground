module.exports = ->
  Project = this

  @BACKGROUND_COLOR = [255, 0, 0]
  @DESCRIPTION = "Using a bezier as boundaries for a pixel sorting function. See https://happycoding.io/tutorials/p5js/images/pixel-sorter"
  @NO_LOOP = true
  @NO_SMOOTH = true

  @preload = ->
    Project.img = @loadImage("public/cat.jpeg")
  
  @onSetup = ->
    Project.img.resize 200, 200

  @draw = ->
    Utils.showFps.call(this)

    bezier_pts = [
      [255, 211],
      [260, 135],
      [335, 155],
      [322, 212]
    ].map (pt) =>
      [
        Utils.remap(pt[0], 0, @width, 0, Project.img.width),
        Utils.remap(pt[1], 0, @height, 0, Project.img.height)
      ]

    x_range = [
      _.min(bezier_pts.map((pt) -> pt[0])),
      _.max(bezier_pts.map((pt) -> pt[0]))
    ]

    Utils.update_image_pixels.call this, Project.img, (img) ->
      valid_x = (x) ->
        x > x_range[0] && x < x_range[1]

      bezier_val = (x) ->
        x_01 = Utils.remap(x, x_range[0], x_range[1], 0, 1)
        Utils.cubicBezier(x_01, ...bezier_pts)[1]

      valid_y = (x, y) ->
        y > bezier_val(x)
      
      for x in [0..img.width - 1] when valid_x(x)
        pixels = for y in [0..img.height - 1] when valid_y(x, y)
          img.get(x, y)

        sorted = pixels.sort (a, b) ->
          Utils.luminance(b) - Utils.luminance(a)

        for y in [0..img.height - 1] when valid_y(x, y)
          y_val = bezier_val(x)
          new_val = sorted[Math.round(y - y_val)]
          if new_val
            img.set(x, y, new_val)

    @image Project.img, 0, 0, @width, @height

  Project
.apply {}