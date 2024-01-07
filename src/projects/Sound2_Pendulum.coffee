require 'p5.collide2d'
require "p5/lib/addons/p5.sound"

window.oldestNote = null

module.exports = ->
    Project = this

    @WEBGL = true
    @DESCRIPTION = "playing with p5 sound library - https://p5js.org/reference/#/libraries/p5.sound"
    @HAS_GUI = true

    @params = {
      minSpeed: 8, minSpeedMin: 0, minSpeedMax: 10, minSpeedStep: 0.1,
      maxSpeed: 10, maxSpeedMin: 0, maxSpeedMax: 100, maxSpeedStep: 0.1,
      boundsSize: 200, boundsSizeMin: 10, boundsSizeMax: 700, boundsSizeStep: 1
      numPts: 20, numPtsMin: 1, numPtsMax: 100, numPtsStep: 1
      leftBarMinNote: 100, leftBarMinNoteMin: 0, leftBarMinNoteMax: 1000,
      leftBarMaxNote: 200, leftBarMaxNoteMin: 0, leftBarMaxNoteMax: 1000,
      rightBarMinNote: 500, rightBarMinNoteMin: 0, rightBarMinNoteMax: 1000,
      rightBarMaxNote: 600, rightBarMaxNoteMin: 0, rightBarMaxNoteMax: 1000,
      noteDuration: 0.0001, noteDurationMin: 0.0001, noteDurationMax: 1, noteDurationStep: 0.0001
    }

    @prompt_for_initial_click = ->
      unless @synth
        @textSize(32)
        @fill('deeppink')
        @textFont(@font);
        @text("click to start audio", -@width/2 + 50, -@height/2 + 50)

    @preload = ->
      @font = @loadFont('public/MigaeSemibold.otf')

    @mousePressed = ->
      @synth = new p5.PolySynth()
      @userStartAudio()

    @setup = ->
      Project.gui = Utils.addGui this, Project.params

      @line_height = @height * 0.6
      @circle_size = 10
      Project.setupPointData.call(this)

    @setupPointData = ->
      @num_pts = Project.params.numPts
      @data = ({} for i in [0...@num_pts])

    @draw = ->
      Project.setupPointData.call(this) if Project.params.numPts isnt @num_pts
      @background(0)
      Project.prompt_for_initial_click.call(this)
      Project.draw_bounds.call(this)
      Project.draw_pts.call(this)

    @draw_pts = ->
      for i in [0...@num_pts]
        data = @data[i]
        data.x = 0 if data.x is undefined
        data.sign = 1 if data.sign is undefined
        data.vel = data.sign * Utils.remap(i / (@num_pts - 1), 0, 1, Project.params.minSpeed, Project.params.maxSpeed)
        data.x += data.vel
        y = -@line_height / 2 + i * @line_height / (@num_pts - 1)

        if data.x > @bounds_size
          diff = data.x - @bounds_size
          data.x = @bounds_size - diff
          data.sign *= -1
          note = Utils.remap(y, -@line_height / 2, @line_height / 2, Project.params.rightBarMaxNote, Project.params.rightBarMinNote)
          @synth?.play(note, 1, 0, Project.params.noteDuration)

        else if data.x < -@bounds_size
          diff = data.x - -this.bounds_size
          data.x = Math.max(-this.bounds_size - -0.25, -this.bounds_size)
          data.sign *= -1
          note = Utils.remap(y, -@line_height / 2, @line_height / 2, Project.params.leftBarMaxNote, Project.params.leftBarMinNote)
          @synth?.play(note, 1, 0, Project.params.noteDuration)

        @push()
        @circle(data.x, y, @circle_size)
        @pop()

    @draw_bounds = ->
      @bounds_size = Project.params.boundsSize
      @push()
      @stroke(0, 255, 0)
      @strokeWeight(2)
      @line(-@bounds_size, -@line_height / 2, -@bounds_size, @line_height / 2)
      @line(@bounds_size, -@line_height / 2, @bounds_size, @line_height / 2)
      @pop()


    Project
.apply {}