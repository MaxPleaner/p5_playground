module.exports = (Utils) ->
  _Shader = ->
    @postprocess = true

    @frag = """
      uniform sampler2D p5Drawing;

      const float resolution = 200.0;

      vec2 pixelate(vec2 coords, float resolution) {
          vec2 pixelSize = vec2(1.0 / resolution, 1.0 / resolution);
          return (floor(coords * resolution) * pixelSize);
      }

      void main() {
        vec2 pixelatedCoords = pixelate(vTexCoord, resolution);
        vec4 color = texture2D(p5Drawing, pixelatedCoords);
        gl_FragColor = color;
      } 
    """

    @setup = (p5) =>

    @draw = (p5, shader) =>

    this
  .apply {}

  Utils.ShaderBuilder(_Shader)
