module.exports = (Utils) ->
  Mandelbrot: require('./shaders/mandelbrot')(Utils)
  SinWave: require('./shaders/sin_wave')(Utils)
  Threshold: require('./shaders/threshold')(Utils)
  Pixelate: require('./shaders/pixelate')(Utils)