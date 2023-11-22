module.exports = class Draggable
  constructor: ({webgl, x, y, w, h, color}) ->
    @webgl = webgl
    @dragging = false # Is the object being dragged?
    @rollover = false # Is the mouse over the ellipse?
    @x = x
    @y = y
    @w = w
    @h = h
    @offsetX = 0
    @offsetY = 0
    @color = color
  
  mouseX: (p5) ->
    if @webgl
      p5.mouseX - p5.width / 2
    else
      p5.mouseX
  
  mouseY: (p5) ->
    if @webgl
      p5.mouseY - p5.height / 2
    else
      p5.mouseY

  over: (p5) ->
    # Is mouse over object
    if @mouseX(p5) > @x and @mouseX(p5) < @x + @w and p5.mouseY > @y and p5.mouseY < @y + @h
      @rollover = true
    else
      @rollover = false

  update: (p5) ->
    # Adjust location if being dragged
    if @dragging
      @x = @mouseX(p5) + @offsetX
      @y = @mouseY(p5) + @offsetY

  show: (p5) ->
    p5.stroke 0
    # Different fill based on state
    if @dragging
      p5.fill [100, 100, 100]
    else if @rollover
      p5.fill [255, 255, 255]
    else
      p5.fill @color
    p5.rect @x, @y, @w, @h

  pressed: (p5) ->
    # Did I click on the rectangle?
    if @mouseX(p5) > @x and @mouseX(p5) < @x + @w and @mouseY(p5) > @y and @mouseY(p5) < @y + @h
      @dragging = true
      # If so, keep track of relative location of click to corner of rectangle
      @offsetX = @x - @mouseX(p5)
      @offsetY = @y - @mouseY(p5)

  released: ->
    # Quit dragging
    @dragging = false