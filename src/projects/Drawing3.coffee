module.exports = ->
  Project = this

  @WEBGL = false
  @DESCRIPTION = ""
  # @HAS_GUI = true
  # @NO_LOOP = true

  @Params = {
    min_n: 200
    max_n: 3000
    speed: 0.1
    line_length_var: 50
    pts_per_line: 4
    min_height: 350
  }

  @setup = ->
    @frameRate(10)
    @all_pts

  @draw = ->
    @background(0)
    height = Utils.remap(@sin(@frameCount * Project.Params.speed), -1, 1, 100, @height - 100)
    n = Utils.remap(height, 0, @height, Project.Params.min_n, Project.Params.max_n)

    for i in [0..n]
      pts = []
      pos = [
        @random(@width),
        @random(height)
      ]
      pts.push(pos)
      last_pt = pts[0]
      for j in [0...Project.Params.pts_per_line - 1]
        pt = [
          last_pt[0] + @random(-Project.Params.line_length_var, Project.Params.line_length_var)
          last_pt[1] + @random(-Project.Params.line_length_var, Project.Params.line_length_var)
        ]
        last_pt = pt
        pts.push(pt)

      @stroke [255, 0, 0]
      @noFill()
      @strokeWeight 2
      # debugger
      @bezier(..._.flatten(pts))

  # @draw = ->

  this
.apply {}