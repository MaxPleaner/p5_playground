module.exports = ->
  Project = this

  @BACKGROUND_COLOR = [255, 0, 0]
  @DESCRIPTION = "An interactive tool to create bezier formulas. NOTE: if applying to image pixels, you will have to remap these canvas-space values to image-space"
  @NO_SMOOTH = true

  @p1 = { pos: [255, 211], handle: null }
  @p2 = { pos: [260, 135], handle: null }
  @p3 = { pos: [335, 155], handle: null }
  @p4 = { pos: [322, 212], handle: null }
  @pts = [@p1, @p2, @p3, @p4]

  @preload = ->
    Project.img = @loadImage("public/cat.jpeg")
  
  @onSetup = ->
    Project.img.resize 200, 200
    for pt in Project.pts
      pt.handle = new Utils.Draggable(pt.pos[0], pt.pos[1], 10, 10)

  @draw = ->
    Utils.showFps.call(this)

    @image Project.img, 0, 0, @width, @height

    for pt in Project.pts
      pt.handle.update(this)
      pt.handle.show(this)
      pt.pos[0] = pt.handle.x
      pt.pos[1] = pt.handle.y

    @stroke 255, 0, 0
    pts = (pt.pos for pt in Project.pts).flat()
    @bezier(pts...)
    
    msg = "Bezier Points: " + Project.pts.map (pt) ->
      pt.pos.join(",")
    .join("   ")
    Utils.showMsg(msg)

  @mousePressed = () ->
    for pt in Project.pts
      pt.handle.pressed(this)

  @mouseReleased = () ->
    for pt in Project.pts
      pt.handle.released(this)

  Project
.apply {}