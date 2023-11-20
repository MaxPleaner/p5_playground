module.exports = class Draggable
  constructor: (x, y, w, h) ->
    @dragging = false # Is the object being dragged?
    @rollover = false # Is the mouse over the ellipse?
    @x = x
    @y = y
    @w = w
    @h = h
    @offsetX = 0
    @offsetY = 0

  over: (p5) ->
    # Is mouse over object
    if p5.mouseX > @x and p5.mouseX < @x + @w and p5.mouseY > @y and p5.mouseY < @y + @h
      @rollover = true
    else
      @rollover = false

  update: (p5) ->
    # Adjust location if being dragged
    if @dragging
      @x = p5.mouseX + @offsetX
      @y = p5.mouseY + @offsetY

  show: (p5) ->
    p5.stroke 0
    # Different fill based on state
    if @dragging
      p5.fill 50
    else if @rollover
      p5.fill 100
    else
      p5.fill 175, 200
    p5.rect @x, @y, @w, @h

  pressed: (p5) ->
    # Did I click on the rectangle?
    if p5.mouseX > @x and p5.mouseX < @x + @w and p5.mouseY > @y and p5.mouseY < @y + @h
      @dragging = true
      # If so, keep track of relative location of click to corner of rectangle
      @offsetX = @x - p5.mouseX
      @offsetY = @y - p5.mouseY

  released: ->
    # Quit dragging
    @dragging = false