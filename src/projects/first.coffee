module.exports = class First extends P5Wrapper
  draw: =>
    @p5.fill 0, 0, 255
    @p5.ellipse @p5.mouseX, @p5.mouseY, 50, 50
