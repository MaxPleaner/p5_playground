module.exports = (Utils) ->
  _Shader = ->

    @frag = """
      uniform sampler2D p5Drawing;

      uniform float min;
      uniform float max;

      void main() {
        vec2 uv = vTexCoord;
        vec4 col = texture2D(p5Drawing, uv);
        if (luminance(col.rgb) < min) {
          col.rgb = vec3(0.0);
        }
        gl_FragColor = col;
      }
    """

    @params = {
      min: 0.05,
      max: 100
    }

    @setup = (p5, shader) =>
      shader.setUniform('min', @params.min)
      shader.setUniform('max', @params.max)

    @draw = (p5, shader) =>

    this
  .apply {}

  Utils.ShaderBuilder(_Shader)
