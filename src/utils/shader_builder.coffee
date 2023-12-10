default_vert = """
  precision highp float; varying vec2 vPos;
  attribute vec3 aPosition;
  attribute vec2 aTexCoord;
  varying vec2 vTexCoord;
  void main() {
    vTexCoord = aTexCoord;
    vec4 positionVec4 = vec4(aPosition, 1.0);
    positionVec4.xy = positionVec4.xy * 2.0 - 1.0;
    positionVec4.y *= -1.0;
    gl_Position = positionVec4;
    vPos = gl_Position.xy;
  }
"""

default_frag_frontmatter = """
      precision highp float; varying vec2 vPos;
      varying vec2 vTexCoord;
      uniform float iTime;

      float luminance(vec3 col) {
        return 0.299 * col[0] + 0.587 * col[1] + 0.114 * col[2];
      }
"""

module.exports = ({vert = default_vert, frag_frontmatter = default_frag_frontmatter, frag, setup, setUniforms, preload}) ->
  frag = frag_frontmatter + frag

  shaderSetup = setup || ->
  shaderSetUniforms = setUniforms || ->

  (opts) -> # user passes draw and setup functions here
    ->
      userPreload = opts.preload
      userSetup = opts.setup
      userSetUniforms = opts.setUniforms
      userAdd = opts.add
      Uniforms = {}

      Shader = this

      @preload = ->
        userPreload?.call(this)

      @setup = ->
        Shader.shader = this.createShader(vert, frag)
        shaderError = Utils.checkShaderError(Shader.shader, frag)
        if shaderError
          throw shaderError
        else
          userAdd?.call(this, Shader.shader)
          shaderSetup(this, Shader.shader)
          userSetup?.call(this, Shader.shader)

      @draw = ->
        Shader.shader.setUniform('iTime', @millis() / 1000.0);
        Object.assign(Uniforms, shaderSetUniforms(this, Shader.shader))
        Object.assign(Uniforms, userSetUniforms?.call(this, Shader.shader))
        Object.entries(Uniforms).forEach ([key, val]) ->
          Shader.shader.setUniform(key, val)

      Shader
    .apply {}