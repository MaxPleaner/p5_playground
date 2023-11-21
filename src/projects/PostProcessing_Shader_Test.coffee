module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using GLSL as a postprocessor for 3D shapes. See https://graha.ms/posts/blog/2022-11-10-using-p5-shaders-for-post-processing/"

  @setup = ->
    # We create a 2d canvas that the line drawing is produced on
    @graphics = @createGraphics(@width, @height);

    # basic initialization on the offscreen graphics
    @graphics.stroke(255,0,130);
    @graphics.strokeWeight(1);
    @graphics.noFill();
    @graphics.translate(@width / 2, @height / 2);

  @draw = ->
    Utils.showFps.call(this)

    @graphics.background(0,30);

    # draw the rotating box to the 2d canvas
    @graphics.push();
    @graphics.rotate(@millis()/1000);
    @graphics.rect(-100,-100,200,200);
    @graphics.pop();

    # We insert a rectangle onto our 3d canvas to hold the textured 2d rectangle
    @rect(-@width/2,-@height/2,@width,@height);

  Utils.applyMacro this, Utils.Shaders.PostProcessSinWave(
    add: (shader) ->
      @shader(shader)
    draw: (shader) ->
      shader.setUniform('p5Drawing', @graphics)
  )


  Project
.apply {}