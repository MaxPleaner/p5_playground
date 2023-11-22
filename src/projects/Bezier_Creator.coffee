module.exports = ->
  Project = this

  @DESCRIPTION = "An interactive tool to create bezier formulas. Drag the points around to see updated point values. NOTE: if using these values for image manipulation, you'll have to remap them from canvas space to image space."
  @NO_SMOOTH = true
  @WEBGL = true
  @SIZE = [700,700]

  @preload = ->
    @img = @loadImage("public/cat.jpeg")
  
  @setup = ->
    @img.resize 200, 200

  @draw = ->
    @image @img, -@width / 2, -@height / 2, @width, @height

  Utils.applyMacro(this, Utils.Macros.BezierCreator(
    initialPts: [
      {pos: [-96,-111] },
      {pos: [-80,-231] },
      {pos: [-10,-181] },
      {pos: [-29,-125] },
    ],
    handleColor: [255, 0, 0],
    strokeWeight: 4
  ))

  Project
.apply {}