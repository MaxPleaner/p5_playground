# The following methods will be invoked in the p5 lifecycle,
# if they're defined on a particular project:
#   - setup({size, background_color, extra_args})
#   - onSetup() - this is called inside setup() but after the default functionality happens
#   - draw()
#   - preload()
# As well as the following attributes:
#   - WEBGL (boolean, optional)
#   - DESCRIPTION (string, required)


module.exports = class P5Wrapper
  constructor: (processor) ->
    @processor = processor

  # bound to @p5 instance
  default_setup: ({size, background_color, webgl} = {}) ->
    @createCanvas size[0], size[1], if webgl then @WEBGL else @P2D
    @background background_color... if background_color

  start: ({size, background_color, extra_args = {}} = {}) =>
    @p5 = new p5 (p) =>
      p.preload = @processor.preload?.bind p

      p.setup = =>
        (@processor.setup || @default_setup).call p, { size, background_color, webgl: @processor.WEBGL, extra_args... }
        @processor.onSetup.call(p) if @processor.onSetup

      p.draw = @processor.draw?.bind p
    this

  stop: ->
    @p5.remove()

