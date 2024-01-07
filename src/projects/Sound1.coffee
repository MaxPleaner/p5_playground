require 'p5.collide2d'
require "p5/lib/addons/p5.sound"

window.oldestNote = null

module.exports = ->
    Project = this

    @WEBGL = true
    @DESCRIPTION = "playing with p5 sound library - https://p5js.org/reference/#/libraries/p5.sound"
    @HAS_GUI = true

    @params = {
      dot_radius: 10,

      num_dots: 10,

      seed: 0,

      line_speed: 10,
      line_speedMin: 0,
      line_speedMax: 20,
      line_speedStep: 0.01

      note_length: 0.05,
      note_lengthMin: 0.01,
      note_lengthMax: 1.0,
      note_lengthStep: 0.01,

      min_note: 50,
      min_noteMin: 0,
      min_noteMax: 400,
      min_noteStep: 1,

      max_note: 400,
      max_noteMin: 0,
      max_noteMax: 400,
      max_noteStep: 1,

      walk_speed: 2.0
      walk_speedMin: 0.0
      walk_speedMax: 50.0,
      walk_speedStep: 0.01

      walk_every_n_frames: 3,
      walk_every_n_framesMin: 0,
      walk_every_n_framesMax: 200,
      walk_every_n_framesStep: 1
    }

    @seed_dot_positions = ->
      @dot_positions = []
      for i in [0...Project.params.num_dots]
        x = Utils.remap(
          @random(), 0, 1
          (-@width / 2) + Project.params.dot_radius,
          (@width / 2) - Project.params.dot_radius,
        )
        y = Utils.remap(
          @random(), 0, 1
          (-@height / 2) + Project.params.dot_radius,
          (@height / 2) - Project.params.dot_radius,
        )
        @dot_positions.push([x, y])    

    @add_dots = ->
      @fill(255)
      @noStroke()
      for i in [0...Project.params.num_dots]
        @circle(
          @dot_positions[i][0],
          @dot_positions[i][1],
          Project.params.dot_radius
        )

    @add_line = ->
      @line_dir = -1 if @line_dir is undefined
      @line_y = -@height / 2 if @line_y is undefined

      @strokeWeight(6)
      @stroke(255, 0, 0)
      @strokeWeight(6)

      if @line_y <= -@height / 2 || @line_y >= @height / 2
        @line_dir *= -1

      @line(-@width / 2, @line_y, @width / 2, @line_y)
      @line_y += @line_dir * Project.params.line_speed

    @findCollisions = ->
      collisions = []
      for dot in @dot_positions
        collision = @collideLineCircle(
          -@width / 2, @line_y, @width / 2, @line_y,
          dot[0], dot[1],
          Project.params.dot_radius,
        )
        collisions.push(dot) if collision
      collisions

    @playSounds = (collisions) ->
      for dot in collisions
        note = Utils.remap(
          dot[0], -@width / 2, @width / 2,
          Project.params.min_note, Project.params.max_note
        )
        @synth?.play(note, 1, 0, Project.params.note_length)

    @preload = ->
      @font = @loadFont('public/MigaeSemibold.otf')

    @setup = ->
      @seed = Project.params.seed
      Project.seed_dot_positions.call(this)
      Project.gui = Utils.addGui this, Project.params

    @mousePressed = ->
      @synth = new p5.PolySynth()
      @userStartAudio()

    @walk_dots = ->
      return unless @frameCount % Project.params.walk_every_n_frames == 0
      # apply random walk to each dot
      for i in [0...Project.params.num_dots]
        @dot_positions[i][0] += @random(-Project.params.walk_speed, Project.params.walk_speed)
        @dot_positions[i][1] += @random(-Project.params.walk_speed, Project.params.walk_speed)

        # wrap around screen
        @dot_positions[i][0] = -@width / 2 if @dot_positions[i][0] > @width / 2
        @dot_positions[i][0] = @width / 2 if @dot_positions[i][0] < -@width / 2
        @dot_positions[i][1] = -@height / 2 if @dot_positions[i][1] > @height / 2
        @dot_positions[i][1] = @height / 2 if @dot_positions[i][1] < -@height / 2

    @draw = ->
      @background(0)
      if Project.params.seed != @seed || Project.params.num_dots != @dot_positions.length
        @randomSeed(Project.params.seed)
        @seed = Project.params.seed
        Project.seed_dot_positions.call(this)
      Project.walk_dots.call(this)
      Project.add_dots.call(this)
      Project.add_line.call(this)
      collisions = Project.findCollisions.call(this)
      Project.playSounds.call(this, collisions)
      unless @synth
        @textSize(32)
        @fill('deeppink')
        @textFont(@font);
        @text("click to start audio", -@width/2 + 50, -@height/2 + 50)
      

    Project
.apply {}