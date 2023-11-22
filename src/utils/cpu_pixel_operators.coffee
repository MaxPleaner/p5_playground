module.exports = (Utils) ->
  ->
    @brighten = ([r, g, b, a], amount) ->
      [r * amount, g * amount, b * amount, a]

    @threshold = ([r, g, b, a], min, max) ->
      col = [r,g,b]
      if Utils.luminance(col) < min
        col = [0,0,0]
      else if Utils.luminance(col) > max
        col = [255,255,255]
      [col..., a]

    this
  .apply {}