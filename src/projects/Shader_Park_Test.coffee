require("shader-park-core/dist/shader-park-p5.js")

module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "A test of incorporating https://github.com/shader-park/shader-park-core"

  `
  ShaderParkCode = function() {
    rotateX(mouse.y * PI / 2);
    metal(.5);
    shine(.4);
    const col = vec3(0, 0, 1) + normal*.1;
    color(col);
    rotateY(getRayDirection().y*4+time);
    boxFrame(vec3(.4), .02);
    expand(.02);
    blend(nsin(time) * .6);
    sphere(.2);
  }
  `
  # ShaderParkCode = ->
    # rotateY(mouse.x * PI / 2 + time*.5);

  @setup = ->
    @sdf = @createShaderPark(ShaderParkCode, {
      scale: 1.0, 
      drawGeometry: () => @sphere(100)
    })
  
  @draw = ->
    @clear();
    @orbitControl();
    
    # The Shader Park distance field is drawn to an invisible sphere.
    # A good practice is to keep your coordinate space in Shader Park
    # close to (0, 0, 0) and then move the sdf around later on with P5
    @sdf.draw();
    @push();
    @normalMaterial();
    @translate(-20, -20, 125 * @sin(@millis() * 0.00125));
    @rotateX(@millis()*0.001);
    @rotateY(@millis()*0.0008);
    @box();
    @pop();

  Project
.apply {}