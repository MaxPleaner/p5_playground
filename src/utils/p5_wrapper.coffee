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
#   - PARAMS (array of dictionaries)
#       these are exposed to the UI
#       each dictionary has the following keys:
#       - name (string, required)
#       - type (string, required, either string, float, int, bool, or color)
#       - default
#       - min (number, optional, only used for float/int)
#       - max (number, optional, only used for float/int)

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
        processor = @processor
        ->
          size = processor.SIZE || P5Wrapper.SIZE
          # TODO: overwrite mouseX and mouseY here to work with WEBGL
          @createCanvas size[0], size[1], if processor.WEBGL then @WEBGL else @P2D
          @noLoop() if processor.NO_LOOP
          @noSmooth() if processor.NO_SMOOTH
          processor.setup?.call this
        .call p

      p.draw = =>
        Utils.showFps.call(p)
        return if @paused && !@redrawing
        @processor.draw?.call p
        @redrawing = false

    this

  redraw: ->
    @redrawing = true
    @p5.redraw()

  remove: ->
    @processor.gui?.destroy()
    @p5.remove()

  pause: ->
    @paused = true
  
  resume: ->
    @paused = false
  
  halt: ->
    @p5.noLoop(true)

