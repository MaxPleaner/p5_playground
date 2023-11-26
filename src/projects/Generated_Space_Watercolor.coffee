sketch = require '../vendor/watercolor/sketch'

module.exports = ->
  Project = this

  @STANDALONE = true
  @DESCRIPTION = "clone of https://generated.space/sketch/watercolor-3/"
  @HAS_GUI = true

  @PARAMS = {
    initial_size: 5, initial_sizeMin: 1, initial_sizeMax: 20
    initial_deviation: 350, initial_deviationMin: 0, initial_deviationMax: 1000
    deviation: 100, deviationMin: 0, deviationMax: 1000
    number_of_interpolations: 8, number_of_interpolationsMin: 1, number_of_interpolationsMax: 20
    number_of_layers: 6, number_of_layersMin: 1, number_of_layersMax: 20
    shapes_per_layer: 45, shapes_per_layerMin: 1, shapes_per_layerMax: 100
    sizex: 700, sizexMin: 100, sizexMax: 1400
    sizey: 700, sizeyMin: 100, sizeyMax: 1400
  }

  @start = ->
    @sketch = sketch Project.PARAMS, userSetup: ->
      Project.gui?.destroy()
      Project.gui = Utils.addGui(this, Project.PARAMS, liveUpdate: false)
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