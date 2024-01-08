module.exports = ->
  Project = this

  @WEBGL = false
  @DESCRIPTION = "just some experimentation with drawing"
  @HAS_GUI = true
  # @NO_LOOP = true

  @params = {
    minRadius: 0, minRadiusMin: 0, minRadiusMax: 100, minRadiusStep: 1
    maxRadius: 832, maxRadiusMin: 0, maxRadiusMax: 1000, maxRadiusStep: 1
    numCircles: 11, numCirclesMin: 1, numCirclesMax: 30, numCirclesStep: 1
    circleMovementFrames: 11, circleMovementFramesMin: 1, circleMovementFramesMax: 30, circleMovementFramesStep: 1
    circleResolution: 2160, circleResolutionMin: 360, circleResolutionMax: 360 * 8, circleResolutionStep: 360
    imperfectionFreq: 16.0, imperfectionFreqMin: 3.0, imperfectionFreqMax: 100.0, imperfectionFreqStep: 1.0
    imperfectionAmp: 13.0, imperfectionAmpMin: 0.0, imperfectionAmpMax: 30.0, imperfectionAmpStep: 1.0
    iterations: 6, iterationsMin: 1, iterationsMax: 10, iterationsStep: 1
  }

  # Overrides for debugging circle connections
  Object.assign(@params, {
  #   iterations: 1,
  #   circleMovementFrames: 500,
  #   imperfectionAmp: 0.0,
    # imperfectionFreq: 100,
  })

  @setup = ->
    Project.gui = Utils.addGui this, Project.params

  @draw = ->
    @frameRate(10)

    @background(0)
    radius_range = [Project.params.minRadius, Project.params.maxRadius]
    num_circles = Project.params.numCircles
    radius_step = (radius_range[1] - radius_range[0]) / num_circles
    for radius in [radius_range[0]...radius_range[1]] by radius_step
      radius2 = Utils.remap(
        @frameCount % Project.params.circleMovementFrames,
        0, Project.params.circleMovementFrames,
        radius, radius + radius_step
      )
      Project.imperfect_circle.call(this,
        radius: radius2,
        final_resolution: Project.params.circleResolution,
        imperfection_every_n_verts: Project.params.imperfectionFreq,
        imperfection_amt: Project.params.imperfectionAmp,
        iterations: Project.params.iterations,
      )

  @imperfect_circle = ({radius, imperfection_every_n_verts, imperfection_amt, final_resolution, iterations}) ->
    @stroke(255)
    @noFill()
    for it in [0...iterations]
      @beginShape()
      verts = []
      step = final_resolution / parseFloat(imperfection_every_n_verts)
      for i in [0...final_resolution] by step
        radian = i * (Math.PI / 180)  # Convert degrees to radians
        vert = {
          x: @width / 2 + @cos(radian) * (radius + @random(-imperfection_amt, imperfection_amt))
          y: @height / 2 + @sin(radian) * (radius + @random(-imperfection_amt, imperfection_amt))
        }
        verts.push(vert)

      resampled = Project.resampleShape.call(this, verts, final_resolution)
      # debugger
      # resampled = verts

      resampled.forEach (vert) =>
        @vertex(vert.x, vert.y)

        # @push()
        # @stroke([255, 0, 0])
        # @strokeWeight(3)
        # @point(vert.x, vert.y)
        # @pop()

      @endShape(@CLOSE)

  @catmullRomInterpolate = (p0, p1, p2, p3, t) ->
    v0 = (p2 - p0) * 0.5
    v1 = (p3 - p1) * 0.5
    t2 = t * t
    t3 = t * t2
    return (2 * p1 - 2 * p2 + v0 + v1) * t3 + (-3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1
 
  @resampleShape = (vertices, targetCount) ->
    originalLength = vertices.length
    # Ensure that the shape is closed by repeating the first few vertices at the end
    # vertices.push(vertices[0])
    # vertices.push(vertices[1])
    # vertices.push(vertices[2])

    resampled = []
    eachSegment = originalLength / targetCount
    for i in [0...targetCount]
      idx = (i * eachSegment)
      idx0 = (Math.floor(idx) - 1 + originalLength) % originalLength
      idx1 = Math.floor(idx) % originalLength
      idx2 = (idx1 + 1) % originalLength
      idx3 = (idx1 + 2) % originalLength
      factor = idx - idx1

      p0 = vertices[idx0]
      p1 = vertices[idx1]
      p2 = vertices[idx2]
      p3 = vertices[idx3]

      interpolatedX = Project.catmullRomInterpolate.call(this, p0.x, p1.x, p2.x, p3.x, factor)
      interpolatedY = Project.catmullRomInterpolate.call(this, p0.y, p1.y, p2.y, p3.y, factor)

      resampled.push({ x: interpolatedX, y: interpolatedY })

    return resampled

  Project
.apply {}