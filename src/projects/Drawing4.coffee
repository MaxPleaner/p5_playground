module.exports = ->
  Project = this

  @WEBGL = false
  @DESCRIPTION = ""
  @HAS_GUI = true
  @NO_LOOP = false

  @params = {
    numLines: 49, numLinesMin: 1, numLinesMax: 100, numLinesStep: 1
    resY: 16, resYMin: 5, resYMax: 100, resYStep: 1
    randomVar: 23, randomVarMin: 0, randomVarMax: 50, randomVarStep: 0.1
    seed: 0, seedMin: 0, seedMax: 100, seedStep: 1
    stroke: [55, 255, 0]
    strokeWeight: 1, strokeWeightMin: 1, strokeWeightMax: 10, strokeWeightStep: 1
    growthRate: 5, growthRateMin: 1, growthRateMax: 10, growthRateStep: 0.001
  }

  @buildLine = (x) ->
    lastX = parseFloat(x)
    pts = [[lastX, 0.0]]
    for i in [0..Project.params.resY]
      y = (@height / Project.params.resY) * i
      rand = Utils.remap(@random(), 0, 1, -Project.params.randomVar, Project.params.randomVar)
      newX = lastX + rand
      lastX = newX
      pts.push [lastX, y]
    pts

  @buildAllLines = ->
    @randomSeed(Project.params.seed)
    @allLines = []
    spacing = @width / parseFloat(Project.params.numLines)
    for i in [0..Project.params.numLines]
      x = spacing * i
      line = Project.buildLine.call(this, x)
      @allLines.push line
  
  @addGui = ->
    Project.gui = Utils.addGui this, Project.params
    Project.gui.setChangeHandler =>
      Project.buildAllLines.call(this)
      if Project.NO_LOOP
        Project.draw.call(this)

  @setup = ->
    Project.addGui.call(this) if Project.HAS_GUI
    Project.buildAllLines.call(this)

  @drawLine = (line) ->
    growthPt = (@frameCount * Project.params.growthRate % @height) / parseFloat(@height)
    boundary = (@height * growthPt) - (parseFloat(@height) / Project.params.resY)

    @beginShape()
    for pt in line
      # if pt[1] < (@height * growthPt) + (parseFloat(@height) / Project.params.resY)
      # boundary = 
      # y = Math.min(pt[1], @height * growthPt)
      y = Math.min(pt[1], boundary)
      @curveVertex(pt[0], y)
    @endShape()

  @draw = ->
    @background(0)
    @stroke(Project.params.stroke)
    @strokeWeight(Project.params.strokeWeight)
    @noFill()

    @allLines.forEach (line) =>
      Project.drawLine.call(this, line)

  this
.apply {}