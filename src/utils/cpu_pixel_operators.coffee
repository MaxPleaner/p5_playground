module.exports = (Utils) ->
  ->
    @brighten = ([r, g, b, a], amount) ->
      [r * amount, g * amount, b * amount, a]

    @threshold = ([r, g, b, a], min, max) ->
      [
        Math.max(min, Math.min(max, r)),
        Math.max(min, Math.min(max, g)),
        Math.max(min, Math.min(max, b)),
        a
      ]

    this
  .apply {}