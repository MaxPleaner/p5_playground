module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using GLSL as a postprocessor. See https://graha.ms/posts/blog/2022-11-10-using-p5-shaders-for-post-processing/"

  @Shader = Utils.Shaders.PostProcessSinWave
  # @Shader = Utils.Shaders.PostProcessTemplate

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
    Utils.showFps.call(this, @g)

    @g.background(0,30);

    # draw the rotating box to the 2d canvas
    @g.push();
    @g.rotate(@millis()/1000);
    @g.rect(-100,-100,200,200);
    @g.pop();

    # We insert a rectangle onto our 3d canvas to hold the textured 2d rectangle
    Project.Shader.draw.call(this, [@g])

  Project
.apply {}