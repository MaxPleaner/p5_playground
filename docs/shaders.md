# Shaders

Shaders are listed in `src/utils.shader.coffee`.

They are constructed through a macro object `src/utils/shader_builder.coffee`.

For example, here is `src/utils/shaders/mandelbrot.coffee`:

```coffee
# Mandelbrot. See https://p5js.org/reference/#/p5/createShader
module.exports = (Utils) ->
  Utils.ShaderBuilder

    frag: "
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

    setup: (p5, shader) ->
      shader.setUniform('p', [-0.74364388703, 0.13182590421])

    draw: (p5, shader) ->
      shader.setUniform('r', 1.5 * Math.exp(-6.5 * (1 + Math.sin(p5.millis() / 2000))));
```

Some explanation here:

1. The vert shader is using a default definition from `shader_builder.coffee`.
   It's possible to provide a custom `vert:` option in the individual shader definitions, but that's not needd in this case.

2. There's some default front matter applied to the frag shader from `shader_builder.coffee`:

```glsl
  precision highp float; varying vec2 vPos;
  varying vec2 vTexCoord;
  uniform float iTime;
```

`iTime` is automatically set to `p5.millis() / 1000` inside `draw()`.

Inside the actual project, `Utils.applyMacro` is used to insert the shader. For example, here is `src/projects/Pixels_Shader_Test.coffee`:

```coffee
module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "Mandelbrot shader written in a GLSL string. See https://p5js.org/reference/#/p5/createShader"
  
  @draw = ->
    @quad(-1, -1, 1, -1, 1, 1, -1, 1)

  Utils.applyMacro this, Utils.Shaders.Mandelbrot(
    add: (shader) ->
      @shader(shader)
  )

  Project
.apply {}
```

The `add` function here is called before the shader's `setup` function, and should be used to apply the shader to a canvas or graphics object as needed.

In addition, it's possible to also provide `setup` and `draw` calls in the `applyMacro` call.

The ordering would look like this:

- **setup**:
  1. Your project's `setup`
  2. The macro's `add`
  3. The shader's `setup` (e.g. the one in `mandelbrot.coffee`)
  4. The macro's `setup`

- **draw**:
  1. Your project's `draw`
  2. The shader's `draw` (e.g. the one in `mandelbrot.coffee`)
  3. the macro's `draw`

### Super Important Note

Macros must be applied _at the end of the project's source code_.

E.g. if you put that `applyMacro` call before the project's `draw` definition, then the project's `draw` wouldn't be called at all.

TODO: make some sort of `registerMacro` function so this isn't necessary.