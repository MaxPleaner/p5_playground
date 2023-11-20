# The following methods will be invoked in the p5 lifecycle,
# if they're defined on a particular project:
#   - setup()
#   - draw()
#   - preload()
#   - mousePressed()
#   - mouseReleased()
#
# As well as the following attributes:
#   - SIZE (array of 2 numbers, optional - defaults to P5Wrapper.SIZE)
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

  # The default size if the processor didn't override it.
  @SIZE = [700,700]

  start: ({size, background_color, extra_args = {}} = {}) =>
    @p5 = new p5 (p) =>
      p.mousePressed = @processor.mousePressed?.bind p
      p.mouseReleased = @processor.mouseReleased?.bind p

      p.preload = @processor.preload?.bind p

      p.setup = =>
        @createCanvas P5Wrapper.SIZE[0], P5Wrapper.SIZE[1], if @processor.WEBGL then @WEBGL else @P2D
        p.noLoop() if @processor.NO_LOOP
        p.noSmooth() if @processor.NO_SMOOTH
        @processor.setup?.call p

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

