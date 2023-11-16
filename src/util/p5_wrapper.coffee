module.exports = class P5Wrapper
  constructor: ({size = [500, 500], background_color = [0]} = {}) ->
    @size = size
    @background_color = background_color

  setup: =>
    @p5.createCanvas @size...
    @p5.background @background_color... if @background_color
  
  draw: =>
    @p5.fill 0, 0, 255
    @p5.ellipse @p5.mouseX, @p5.mouseY, 50, 50

  start: =>
    @p5 = new p5 (p) =>
      p.setup = @setup
      p.draw = @draw

  stop: =>
    @p5.remove()