# Mandelbrot. See https://p5js.org/reference/#/p5/createShader
module.exports = (Utils) ->
  Utils.ShaderBuilder({
    frag: """
      uniform sampler2D p5Drawing;

      void main() {
        vec2 uv = vTexCoord;
        vec4 col = texture2D(p5Drawing, uv);
        gl_FragColor = col;
  }
    """

    setup: (shader, graphics) ->

    draw: (shader, graphics) ->
      shader.setUniform('p5Drawing', graphics);

})