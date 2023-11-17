module.exports = class P5Wrapper

  constructor: (processor) ->
    @processor = processor

  # bound to @p5 instance
  default_setup: ({size, background_color}) ->
    @createCanvas size...
    @background background_color... if background_color

  start: ({size = [500, 500], background_color = [0], extra_args = {}} = {}) =>
    @p5 = new p5 (p) =>
      p.setup = (@processor.setup || @default_setup).bind p, { size, background_color, extra_args... }
      p.draw = @processor.draw?.bind p
    this

  stop: ->
    @p5.remove()

