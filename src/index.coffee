p5 = require 'p5'

new p5 (p) ->
  p.setup = ->
    p.createCanvas 400, 400
    p.background 200

  p.draw = ->
    p.fill 255, 0, 0
    p.ellipse p.mouseX, p.mouseY, 50, 50