module.exports = (Utils) ->
  Mandelbrot: require('./shaders/mandelbrot')(Utils)
  PostprocessTest: require('./shaders/postprocess_test')(Utils)