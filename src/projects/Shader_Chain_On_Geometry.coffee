module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using GLSL as a postprocessor for 3D shapes. Use mouse to control. Click to increase the effect. It's passing through a sequence of shaders (sin wave, thresholding, pixelation). See https://graha.ms/posts/blog/2022-11-10-using-p5-shaders-for-post-processing/"

  @setup = ->
    @graphics = @createGraphics(@width, @height, @WEBGL);

    @graphics.strokeWeight(1);
    @graphics.noFill();

  @draw = ->
    Utils.showFps.call(this)

    @graphics.background(0, 10);

    mouseX = @mouseX - @width / 2
    mouseY = @mouseY - @height / 2

    # draw the rotating box to the 2d canvas
    @graphics.push();
    @graphics.stroke(255,0,130);
    @graphics.translate(mouseX, mouseY);
    @graphics.rotate((@millis()) / 1000);
    @graphics.rect(-50,-50,100,100);
    @graphics.pop();

    @image(@shader_out, -@width / 2, -@height / 2, @width, @height)

  Utils.addShaderSequence(this, [
    [Utils.Shaders.SinWave, {
      setUniforms: (shader) ->
        increment = 0.01

        @speed ||= 10.0
        @amp ||= 0.01
        if @mouseIsPressed
          @speed *= 1 + increment
          @amp *= 1 + increment
        else
          @speed *= 1 - increment
          @amp *= 1 - increment
        
        @speed = Math.max(Math.min(@speed, 50.0), 10.0)
        @amp = Math.max(Math.min(@amp, 0.5), 0.01)
        
        {
          speed: @speed,
          amp: @amp
        }
    }]
    [Utils.Shaders.Threshold, {}]
    [Utils.Shaders.Pixelate, {}]
  ], {
    input: -> @graphics,
    output: (result) -> @shader_out = result
  })

  Project
.apply {}