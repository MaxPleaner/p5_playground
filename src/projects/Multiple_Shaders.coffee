module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Using two GLSL shaders in sequence to process an image. First is a sin wave, second is pixelation. Thanks to https://github.com/aferriss/p5jsShaderExamples/blob/gh-pages/4_image-effects/4-10_two-pass-blur/sketch.js"
  @NO_SMOOTH = true

  vert = """
    precision highp float; varying vec2 vPos;
    attribute vec3 aPosition;
    attribute vec2 aTexCoord;
    varying vec2 vTexCoord;
    void main() {
      vTexCoord = aTexCoord;
      vec4 positionVec4 = vec4(aPosition, 1.0);
      positionVec4.xy = positionVec4.xy * 2.0 - 1.0;
      gl_Position = positionVec4;
      // vPos = gl_Position.xy;
    }
  """

  sin_manip = """
      precision highp float; varying vec2 vPos;
      varying vec2 vTexCoord;

      uniform sampler2D p5Drawing;
      uniform float iTime;

      void main() {
        vec2 uv = vTexCoord;
        float sinVal = (uv.x * 30.0) + (iTime * 10.0);
        uv.y += sin(sinVal) * 0.02;
        vec4 col = texture2D(p5Drawing, uv);
        gl_FragColor = col;
      }
  """

  dither = """
      precision highp float; varying vec2 vPos;
      varying vec2 vTexCoord;

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

  pixelate = """
      precision highp float; varying vec2 vPos;
      varying vec2 vTexCoord;

      uniform sampler2D p5Drawing;

      const float resolution = 100.0;

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

  @preload = ->
    Project.img = @loadImage("public/brick.jpeg")

  @setup = ->
    scale = 0.2
    Project.img.resize(@width * scale, @height * scale)

    Project.shader1 = @createShader(vert, sin_manip)
    Project.shader2 = @createShader(vert, pixelate)

    err = Utils.checkShaderError(Project.shader1, sin_manip)
    err ||= Utils.checkShaderError(Project.shader2, pixelate)
    throw err if err

    Project.graphics1 = @createGraphics(@width, @height, @WEBGL)
    Project.graphics2 = @createGraphics(@width, @height, @WEBGL)

    Project.graphics1.shader(Project.shader1)
    Project.graphics2.shader(Project.shader2)

  @draw = ->
    Project.graphics1.rect(-@width/2, -@height/2, @width, @height);
    Project.graphics2.rect(-@width/2, -@height/2, @width, @height);

    Project.shader1.setUniform('p5Drawing', Project.img)
    Project.shader1.setUniform('iTime', @millis() / 2000)
    Project.shader2.setUniform('p5Drawing', Project.graphics1)

    @image(Project.graphics2, -@width / 2, -@height / 2, @width, @height)

  Project
.apply {}