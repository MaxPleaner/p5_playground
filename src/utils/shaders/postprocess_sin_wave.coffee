# Mandelbrot. See https://p5js.org/reference/#/p5/createShader
module.exports = (Utils) ->
  _Shader = ->
    @postprocess = true

    @frag = """
      uniform sampler2D p5Drawing;

      uniform float period;
      uniform float speed;
      uniform float amp;

      void main() {
        vec2 uv = vTexCoord;
        float sinVal = (uv.x * period) + (iTime * speed);
        uv.y += sin(sinVal) * amp;
        vec4 col = texture2D(p5Drawing, uv);
        gl_FragColor = col;
      }
    """

    @params = {
      period: 30.0,
      speed: 10.0,
      amp: 0.02
    }

    @setup = (p5) =>

    @draw = (p5, shader) =>
      shader.setUniform('period', @params.period)
      shader.setUniform('speed', @params.speed)
      shader.setUniform('amp', @params.amp)

    this
  .apply {}

  Utils.ShaderBuilder(_Shader)
