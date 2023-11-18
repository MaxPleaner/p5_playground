default_vert = """
  precision highp float; varying vec2 vPos;
  attribute vec3 aPosition;
  attribute vec2 aTexCoord;
  varying vec2 vTexCoord;
  void main() {
    vTexCoord = aTexCoord;
    vec4 positionVec4 = vec4(aPosition, 1.0);
    positionVec4.xy = positionVec4.xy * 2.0 - 1.0;
    gl_Position = positionVec4;
    vPos = gl_Position.xy;
  }
"""

default_frag_frontmatter = """
      precision highp float; varying vec2 vPos;
      varying vec2 vTexCoord;
      uniform float iTime;
"""

module.exports = ({vert = default_vert, postprocess, frag, setup, draw}) ->
  frag = default_frag_frontmatter + frag

  ->
    Shader = this

    @checkShaderError = (shaderObj, shaderText) =>
      gl = shaderObj._renderer.GL
      glFragShader = gl.createShader(gl.FRAGMENT_SHADER)
      gl.shaderSource(glFragShader, shaderText)
      gl.compileShader(glFragShader)
      if !gl.getShaderParameter(glFragShader, gl.COMPILE_STATUS)
        return gl.getShaderInfoLog(glFragShader)
      return null

    @setup = (extra_args = []) ->
      Shader.shader = @createShader(vert, frag)
      shaderError = Shader.checkShaderError(Shader.shader, frag)
      if shaderError
        throw shaderError
      else
        @shader(Shader.shader)
        setup.call(this, Shader.shader, extra_args...)

    @draw = (extra_args = []) ->
      Shader.shader.setUniform('iTime', @millis() / 1000.0);
      draw.call(this, Shader.shader, extra_args...)
      if postprocess
        @rect(-@width/2, -@height/2, @width, @height);

    Shader
  .apply {}