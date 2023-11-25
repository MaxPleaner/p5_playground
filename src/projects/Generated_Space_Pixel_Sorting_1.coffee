module.exports = ->
  Project = this

  @WEBGL = true
  @DESCRIPTION = "attempted clone of https://generated.space/sketch/pixel-sorting-1/"
  @HAS_GUI = true
  # @NO_LOOP = true
  @IMAGE_SIZE = [200,200]
  @RANDOM_SAMPLES = 5

  # This is broken with WEBGL images
  # @NO_SMOOTH = true

  @params = {
  }

  @preload = ->
    # @img = @loadImage("public/cat.jpeg")
    @img = @loadImage("public/dark_tree.jpeg")

  @setup = ->
    @pixelDensity(1)
    Project.gui = Utils.addGui this, Project.params
    @img.resize(Project.IMAGE_SIZE...)
    Utils.webglNoSmooth.call(this, @img)
    @stack = new Set()
    for x in [0..@img.width - 1]
      for y in [0..@img.height - 1]
        @stack.add([x, y].join(","))

  # ------------------------------------------------
  # Rearranges pixels in an image.
  # For each pixel P, from top to bottom, left to right,
  # take N random pixels not yet processed,
  # pick the one that is most similar with P’s surroundings
  # and swap the positions of the two.
  # ------------------------------------------------

  if @NO_LOOP # Processes all in one chunk .. will be slow for all but small images
    @draw = ->
      @img.loadPixels()
      for y in [0..@img.height]
        for x in [0..@img.width - 1]
          console.log("row: #{y}, col: #{x}")
          if @stack.has([x, y].join(","))
            @stack.delete([x,y].join(","))
            Project.step.call(this, x, y, Project.RANDOM_SAMPLES)
      @img.updatePixels()

      @image(@img, -@width / 2, -@height / 2, @width, @height)
  else # Processes one row at a time
    @draw = ->
      @img.loadPixels()
      @x ||= 0
      @y ||= 0
      step = @img.width
      for i in [0..step]
        if @x > @img.width - 1
          @x = 0
          @y += 1
        if @y > @img.height - 1
          return
        if @stack.has([@x, @y].join(","))
          @stack.delete([@x, @y].join(","))
          Project.step.call(this, @x, @y, Project.RANDOM_SAMPLES)
        @x += 1
      @img.updatePixels()
      @image(@img, -@width / 2, -@height / 2, @width, @height)    

  @step = (x, y, random_samples) ->
    pixel = @img.get(x, y)

    neighbors = [
      [x, y],
      [x + 1, y],
      [x - 1, y],
      [x, y + 1],
      [x, y - 1]
      [x + 1, y + 1],
      [x - 1, y - 1],
      [x + 1, y - 1],
      [x - 1, y + 1]
    ].map (neighbor_coord) =>
      [neighbor_x, neighbor_y] = neighbor_coord
      if neighbor_x < 0 or neighbor_x > @img.width - 1
        return null
      if neighbor_y < 0 or neighbor_y > @img.height - 1
        return null
      return @img.get(neighbor_x, neighbor_y)
    neighbors = _.compact(neighbors).map (neighbor) => chroma.rgb(neighbor)

    avg_neighbor_color = chroma.average(neighbors)._rgb

    options = _.compact([0...random_samples].map (i) =>
      idx = Math.floor(Math.random() * @stack.size);
      Array.from(@stack)[idx];
    ).map (option) =>
      option.split(",").map((x) -> parseInt(x))

    option = _.minBy(options, (coords) =>
      # deltas = neighbors.map (neighbor) =>
      #   chroma.deltaE(neighbor._rgb.slice(0,3), @img.get(coords...).slice(0,3))
      # Math.min(deltas...)
      option_pixel = @img.get(coords...)
      chroma.deltaE(option_pixel.slice(0,3), avg_neighbor_color.slice(0,3))
    )

    # debugger

    return unless options.length > 0
      
    # @stack.delete(option.join(","))

    pixel2 = @img.get option...
    @img.set(x, y, pixel2)
    @img.set(option..., pixel)
    
  Project
.apply {}