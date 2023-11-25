sketch = require "../vendor/trunk/sketch"

module.exports = ->
  Project = this

  @STANDALONE = true
  @DESCRIPTION = "Clone of https://generated.space/sketch/trunk/"
  @HAS_GUI = true

  @SIZE = [700, 700]
  @PARAMS = {
    rings: 50
    ringsMin: 1
    ringsMax: 200

    dim_init: 50
    dim_initMin: 1
    dim_initMax: 200

    dim_delta: 4
    dim_deltaMin: 1,
    dim_deltaMax: 10,

    chaos_init: .2
    chaos_initMin: 0
    chaos_initMax: 1
    chaos_initStep: .01

    chaos_delta: 0.12
    chaos_deltaMin: 0
    chaos_deltaMax: 1
    chaos_deltaStep: .01

    chaos_mag: 20
    chaos_magMin: 0
    chaos_magMax: 100
  }

  @start = ->
    @sketch = sketch
      size: Project.SIZE
      params: Project.PARAMS
      userSetup: ->
        Project.gui?.destroy()
        Project.gui = Utils.addGui(this, Project.PARAMS)
        # Project.gui.setChangeHandler ->
        #   Project.redraw()
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