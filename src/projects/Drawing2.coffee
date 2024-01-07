module.exports = ->
  Project = this

  @WEBGL = false
  @DESCRIPTION = "just some experimentation with drawing"
  @HAS_GUI = true
  @NO_LOOP = true

  @params = {
  }

  @setup = ->
    Project.gui = Utils.addGui this, Project.params

  @draw = ->
    @background(0)
    radius_range = [50, 300]
    num_circles = 3
    for radius in [radius_range[0]...radius_range[1]] by (radius_range[1] - radius_range[0]) / num_circles
      Project.imperfect_circle.call(this,
        radius: radius,
        final_resolution: 360,
        imperfection_every_n_verts: 50,
        imperfection_amt: 20.0,
        iterations: 7,
      )

  # downsample is performed in increments of 6
  @imperfect_circle = ({radius, imperfection_every_n_verts, imperfection_amt, final_resolution, iterations}) ->
    # @beginShape()
    @stroke(255)
    @noFill()
    for it in [0...iterations]
      verts = []
      for i in [0...final_resolution] by imperfection_every_n_verts
        radian = i * (Math.PI / 180)  # Convert degrees to radians
        vert = {
          x: @width / 2 + @cos(radian) * (radius + @random(-imperfection_amt, imperfection_amt))
          y: @height / 2 + @sin(radian) * (radius + @random(-imperfection_amt, imperfection_amt))
        }
        verts.push(vert)
      resampled = Project.resampleShape.call(this, verts, final_resolution)

      # for i in [0...resampled.length] by 2
      #   vert1 = resampled[i]
      #   vert2 = resampled[i + 1] if i + 1 < resampled.length
      #   @line(vert1.x, vert1.y, vert2.x, vert2.y)  if vert2

      resampled.forEach (vert) =>
        @vertex(vert.x, vert.y)

      @endShape(@CLOSE)

  @catmullRomInterpolate = (p0, p1, p2, p3, t) ->
    v0 = (p2 - p0) * 0.5
    v1 = (p3 - p1) * 0.5
    t2 = t * t
    t3 = t * t2
    return (2 * p1 - 2 * p2 + v0 + v1) * t3 + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1

  @resampleShape = (vertices, targetCount) ->
    n = vertices.length
    # Ensure that the shape is closed by repeating the first few vertices at the end
    vertices.push(vertices[0])
    vertices.push(vertices[1])
    vertices.push(vertices[2])

    resampled = []
    eachSegment = (n - 1) / targetCount # Adjust to accommodate the extra vertices at the end
    for i in [0...targetCount]
      idx = (i * eachSegment)
      idx0 = (Math.floor(idx) - 1 + n) % n
      idx1 = Math.floor(idx) % n
      idx2 = (idx1 + 1) % n
      idx3 = (idx1 + 2) % n
      factor = idx - idx1

      p0 = vertices[idx0]
      p1 = vertices[idx1]
      p2 = vertices[idx2]
      p3 = vertices[idx3]

      interpolatedX = Project.catmullRomInterpolate.call(this, p0.x, p1.x, p2.x, p3.x, factor)
      interpolatedY = Project.catmullRomInterpolate.call(this, p0.y, p1.y, p2.y, p3.y, factor)

      resampled.push({ x: interpolatedX, y: interpolatedY })

    return resampled;
  Project
.apply {}