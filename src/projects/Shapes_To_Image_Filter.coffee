module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using Image filters on things besides images. See https://p5js.org/reference/#/p5/filter"

  @Shader = Utils.Shaders.PostProcessSinWave

  @onSetup = ->
    # We create a 2d canvas that the line drawing is produced on
    @g = @createGraphics(@width, @height);

    # basic initialization on the offscreen graphics
    @g.stroke(255,0,130);
    @g.strokeWeight(1);
    @g.noFill();
    @g.translate(@width / 2, @height / 2);

    Project.Shader.setup.call(this, [@g])

  @draw = ->
    Utils.showFps.call(this)

    @g.background(0,30);

    # draw the rotating box to the 2d canvas
    @g.push();
    @g.rotate(@millis()/1000);
    @g.rect(-100,-100,200,200);
    @g.pop();

    # We insert a rectangle onto our 3d canvas to hold the textured 2d rectangle
    Project.Shader.draw.call(this, [@g])
    @rect(-@width/2,-@height/2,@width,@height);

  Project
.apply {}