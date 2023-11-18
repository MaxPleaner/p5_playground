module.exports = (Utils) ->
  Mandelbrot: require('./shaders/mandelbrot')(Utils)
  PostProcessSinWave: require('./shaders/postprocess_sin_wave')(Utils)
  PostProcessTemplate: require('./shaders/postprocess_template')(Utils)