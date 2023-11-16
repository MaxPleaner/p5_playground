####################################################
# Example subclass:
# module.exports = class NewProject extends P5Wrapper
  # constructor: (options = {}) ->
  #   { a, b, ...rest } = options # read additional options
  #   super(rest)
  # setup: (p) =>
  #   # Note: the setup function is unique in that it requires the p5 instance
  #   # as an argument
  # draw: =>
  #   # use @p5 to access the p5 instance
####################################################

module.exports = class P5Wrapper
  constructor: ({size = [500, 500], background_color = [0]} = {}) ->
    @size = size
    @background_color = background_color

  setup: (p) =>
    p.createCanvas @size...
    p.background @background_color... if @background_color
  
  draw: =>
    # Override this method in subclasses

  start: =>
    @p5 = new p5 (p) =>
      p.setup = => @setup(p)
      p.draw = @draw
    this

  stop: =>
    @p5.remove()