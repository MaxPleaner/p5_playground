# Mandelbrot. See https://p5js.org/reference/#/p5/createShader
module.exports = (Utils) ->
  Utils.ShaderBuilder({
    fs: """
      precision highp float; varying vec2 vPos;
      varying vec2 vTexCoord;

      uniform float iTime;
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
      @noStroke()
      shader.setUniform('p5Drawing', graphics);

    draw: (shader, graphics) ->
      shader.setUniform('p5Drawing', graphics);
      shader.setUniform('iTime', @millis() / 1000.0);
      @rect(-@width/2, -@height/2, @width, @height);

  })