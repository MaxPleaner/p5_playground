# Mandelbrot. See https://p5js.org/reference/#/p5/createShader
module.exports = (Utils) ->
  Utils.ShaderBuilder({
    fs: "
      precision highp float; varying vec2 vPos;
      uniform vec2 p;
      uniform float r;
      const int I = 500;
      void main() {
        vec2 c = p + vPos * r, z = c;
        float n = 0.0;
        for (int i = I; i > 0; i --) {
          if(z.x*z.x+z.y*z.y > 4.0) {
            n = float(i)/float(I);
            break;
          }
          z = vec2(z.x*z.x-z.y*z.y, 2.0*z.x*z.y) + c;
        }
        gl_FragColor = vec4(0.5-cos(n*17.0)/2.0,0.5-cos(n*13.0)/2.0,0.5-cos(n*23.0)/2.0,1.0);
      }
    "

    setup: (shader) ->
      @noStroke()
      shader.setUniform('p', [-0.74364388703, 0.13182590421])

    draw: (shader) ->
      shader.setUniform('r', 1.5 * Math.exp(-6.5 * (1 + Math.sin(Date.now() / 2000))));
      @quad(-1, -1, 1, -1, 1, 1, -1, 1)
  })