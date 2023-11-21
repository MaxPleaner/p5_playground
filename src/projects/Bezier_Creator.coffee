module.exports = ->
  Project = this

  @DESCRIPTION = "An interactive tool to create bezier formulas. Drag the points around to see updated point values. NOTE: if using these values for image manipulation, you'll have to remap them from canvas space to image space."
  @NO_SMOOTH = true
  @WEBGL = true
  @SIZE = [700,700]

  @p1 = { pos: [255, 211], handle: null }
  @p2 = { pos: [260, 135], handle: null }
  @p3 = { pos: [335, 155], handle: null }
  @p4 = { pos: [322, 212], handle: null }

  # Remap to Webgl coords, they were created with the other renderer
  @pts = [@p1, @p2, @p3, @p4].map (p) ->
    {p..., pos: p.pos.map (val) -> val - 350 }

  @preload = ->
    Project.img = @loadImage("public/cat.jpeg")
  
  @setup = ->
    Project.img.resize 200, 200
    for pt in Project.pts
      pt.handle = new Utils.Draggable(webgl: Project.WEBGL, x: pt.pos[0], y: pt.pos[1], w: 10, h: 10)

  @draw = ->
    Utils.showFps.call(this)

    @image Project.img, -@width / 2, -@height / 2, @width, @height

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

    # @translate(-@width/2, 0, -@height/2)

  @mousePressed = () ->
    for pt in Project.pts
      pt.handle.pressed(this)

  @mouseReleased = () ->
    for pt in Project.pts
      pt.handle.released(this)

  Project
.apply {}