module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using GLSL as a postprocessor. See https://graha.ms/posts/blog/2022-11-10-using-p5-shaders-for-post-processing/"

  @Shader = Utils.Shaders.PostprocessTest

  @onSetup = ->
    # We create a 2d canvas that the line drawing is produced on
    Project.graphics = @createGraphics(@width, @height);

    # basic initialization on the offscreen graphics
    Project.graphics.stroke(255,0,130);
    Project.graphics.strokeWeight(1);
    Project.graphics.noFill();
    Project.graphics.translate(@width / 2, @height / 2);

    Project.Shader.setup.call(this, [Project.graphics])

  @draw = ->
    Utils.showFps.call(this, Project.graphics)

    Project.graphics.background(0,30);

    # draw the rotating box to the 2d canvas
    Project.graphics.push();
    Project.graphics.rotate(@millis()/1000);
    Project.graphics.rect(-100,-100,200,200);
    Project.graphics.pop();

    # We insert a rectangle onto our 3d canvas to hold the textured 2d rectangle
    Project.Shader.draw.call(this, [Project.graphics])

  Project
.apply {}