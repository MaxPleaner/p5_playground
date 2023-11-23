module.exports = (Utils) ->
  _Shader = ->
    @postprocess = true

    @frag = """
      uniform sampler2D p5Drawing;

      float dither2x2(vec2 position, float brightness) {
        int x = int(mod(position.x, 2.0));
        int y = int(mod(position.y, 2.0));
        int index = x + y * 2;

        float ditherValue;
        if (index == 0) ditherValue = 0.25;
        else if (index == 1) ditherValue = 0.75;
        else if (index == 2) ditherValue = 1.0;
        else ditherValue = 0.5;

        return brightness > ditherValue ? 1.0 : 0.0;
      }

      void main() {
        vec3 texColor = texture2D(p5Drawing, vTexCoord).rgb;
        float gray = dot(texColor, vec3(0.299, 0.587, 0.114));
        vec4 color = vec4(vec3(dither2x2(gl_FragCoord.xy, gray)), 1.0);
        gl_FragColor = color;
      }
    """

    @setup = (p5) =>

    @draw = (p5, shader) =>

    this
  .apply {}

  Utils.ShaderBuilder(_Shader)