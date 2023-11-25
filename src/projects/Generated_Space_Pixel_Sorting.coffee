sketch = require '../vendor/pixel-sorting/sketch'

module.exports = ->
  Project = this

  @STANDALONE = true
  @DESCRIPTION = "the original code from https://generated.space/sketch/pixel-sorting-1/"
  @HAS_GUI = true

  @PARAMS = {
    selection_size: 5,
    selection_sizeMin: 2,
    selection_sizeMax: 30,
    diagonal: false,
    canvasSize: 700
    canvasSizeMin: 200
    canvasSizeMax: 1400
    canvasSizeStep: 10
  }

  @start = ->
    @sketch = sketch(Project.PARAMS)
    Utils.applyMacro.call @sketch, @sketch,
      setup: ->
        Project.gui?.destroy()
        Project.gui = Utils.addGui(this, Project.PARAMS)
        Project.gui.setChangeHandler ->
          Project.redraw()
    Project

  @remove = ->
    @sketch.remove()
    Project.gui?.destroy()
    Project.gui = null

  @redraw = ->
    Project.remove()
    Project.start()

  Project
.apply {}