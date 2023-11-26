module.exports = ->
  Project = this

  @DESCRIPTION = "the famous '10 print algo' from commodore 64: 10 PRINT CHR$(205.5+RND(1)); : GOTO 10"
  @HAS_GUI = true

  @PARAMS = {
    fontSize: 12, fontSizeMin: 1, fontSizeMax: 100
    frameRate: 10, frameRateMin: 1, frameRateMax: 30
  }

  @setup = ->
    @idx = 0
    @stack = []
    @numCells = @width / Project.PARAMS.fontSize

    Utils.addGui(this, Project.PARAMS)
    
    for y in [0...@height / Project.PARAMS.fontSize + 5]
      line = []
      for x in [0..@numCells * 3.0]
        char = if Math.random() > 0.5 then "/" else "\\"
        line.push char
      @stack.push line

  @draw = ->
    @numCells = @width / Project.PARAMS.fontSize
    @frameRate Project.PARAMS.frameRate
    @background 0
    @fill 255
    @noStroke()
    @textSize Project.PARAMS.fontSize
    @textFont 'monospace'

    line = []
    for i in [0..@numCells * 3.0]
      x = i * Project.PARAMS.fontSize * 0.5
      y = @height
      char = if Math.random() > 0.5 then "/" else "\\"
      line.push char
    
    @stack.push line
    if @stack.length > @height / Project.PARAMS.fontSize * 1.3
      @stack.shift()

    for line, lineIdx in @stack
      for char, charIdx in line
        @text char, charIdx * Project.PARAMS.fontSize * 0.38, lineIdx * Project.PARAMS.fontSize * 0.8

  Project
.apply {}