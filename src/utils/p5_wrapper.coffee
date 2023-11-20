# The following methods will be invoked in the p5 lifecycle,
# if they're defined on a particular project:
#
#   - setup({size, background_color, extra_args})
#   - onSetup()
#      this is called inside setup() but after the default functionality happens
#   - draw()
#   - preload()
#   - mousePressed()
#   - mouseReleased()
#
# As well as the following attributes:
#
#   - BACKGROUND_COLOR (array of 3 numbers, optional)
#   - WEBGL (boolean, optional)
#   - DESCRIPTION (string, required)
#   - NO_LOOP (boolean, optional)
#       if true, draw will only happen manually
#   - NO_SMOOTH (boolean, optional)
#       if true, won't apply anti aliasing

module.exports = class P5Wrapper
  constructor: (processor) ->
    @processor = processor
    @paused = false
    @redrawing = false

  # bound to @p5 instance
  default_setup: ({size, background_color, webgl} = {}) ->
    @createCanvas size[0], size[1], if webgl then @WEBGL else @P2D
    @background background_color... if background_color

  start: ({size, background_color, extra_args = {}} = {}) =>
    @p5 = new p5 (p) =>
      p.mousePressed = @processor.mousePressed?.bind p
      p.mouseReleased = @processor.mouseReleased?.bind p

      p.preload = @processor.preload?.bind p

      p.setup = =>
        (@processor.setup || @default_setup).call p, { size, background_color, webgl: @processor.WEBGL, extra_args... }
        @processor.onSetup.call(p) if @processor.onSetup
        p.noLoop() if @processor.NO_LOOP
        p.noSmooth() if @processor.NO_SMOOTH

      p.draw = =>
        return if @paused && !@redrawing
        @processor.draw?.call p
        @redrawing = false
    this

  redraw: ->
    @redrawing = true
    @p5.redraw()

  remove: ->
    @p5.remove()

  pause: ->
    @paused = true
  
  resume: ->
    @paused = false
  
  halt: ->
    @p5.noLoop(true)

