module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using GLSL as a postprocessor for 3D shapes. Use mouse to control. Click to accelerate. It's passing through a sequence of shaders (sin wave, thresholding, pixelation). See https://graha.ms/posts/blog/2022-11-10-using-p5-shaders-for-post-processing/"

  @setup = ->
    Project.graphics = @createGraphics(@width, @height, @WEBGL);

    Project.graphics.strokeWeight(1);
    Project.graphics.noFill();

  @draw = ->
    Utils.showFps.call(this)

    Project.graphics.background(0, 10);

    mouseX = @mouseX - @width / 2
    mouseY = @mouseY - @height / 2

    acceleration = 0.1
    if @mouseIsPressed
      acceleration += 1
    else
      acceleration -= 1
    acceleration = Math.max(0.1, Math.min(acceleration, 2.0))

    # draw the rotating box to the 2d canvas
    Project.graphics.push();
    Project.graphics.stroke(255,0,130);
    Project.graphics.translate(mouseX, mouseY);
    Project.graphics.rotate(acceleration * @millis() / 100);
    Project.graphics.rect(-50,-50,100,100);
    Project.graphics.pop();

    @image(Project.graphics_to_show, -@width / 2, -@height / 2, @width, @height)

  Utils.addShaderSequence(this, 'graphics', [
    Utils.Shaders.SinWave,
    Utils.Shaders.Threshold,
    Utils.Shaders.Pixelate
  ])

  Project
.apply {}