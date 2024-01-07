module.exports = ->
  Project = this

  @WEBGL = false
  @DESCRIPTION = "just some experimentation with drawing"
  @HAS_GUI = true

  @params = {
    speed: 0.00005, speedMin: 0.0, speedMax: 0.001, speedStep: 0.00001
  }

  @setup = ->
    Project.gui = Utils.addGui this, Project.params
    @angle = 0

  @draw = ->
    @background(255)
    @translate(@width / 2, @height / 2)
    for i in [0...100]
      # @stroke(@random(255), @random(255), @random(255))
      @rotate(@angle + i)
      @ellipse(50 + i * 10, 50 + i * 10, 100 + i * 20, 100 + i * 20)
    
    @angle += Project.params.speed

  Project
.apply {}