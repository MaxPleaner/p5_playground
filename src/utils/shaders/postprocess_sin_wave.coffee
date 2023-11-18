# Mandelbrot. See https://p5js.org/reference/#/p5/createShader
module.exports = (Utils) ->
  Utils.ShaderBuilder({
    postprocess: true
    frag: """
      uniform sampler2D p5Drawing;

      const float period = 30.0;
      const float speed = 10.0;
      const float amp = 0.02;

      void main() {
        vec2 uv = vTexCoord;
        float sinVal = (uv.x * period) + (iTime * speed);
        uv.y += sin(sinVal) * amp;
        vec4 col = texture2D(p5Drawing, uv);
        gl_FragColor = col;
  }
    """

    setup: (shader, graphics) ->

    draw: (shader, graphics) ->
      shader.setUniform('p5Drawing', graphics);

  })