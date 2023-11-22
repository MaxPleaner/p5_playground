module.exports = (Utils) ->
  ({initialPts, size = 10, strokeWeight = 4, strokeColor = [255, 0, 255], handleColor = [255, 100, 255]}) ->
    ->
      @setup = ->
        @pts = initialPts
        for pt in @pts
          webgl = @_renderer.drawingContext instanceof WebGL2RenderingContext
          pt.handle = new Utils.Draggable({
            webgl,
            x: pt.pos[0],
            y: pt.pos[1],
            w: size,
            h: size,
            color: handleColor
          })
      
      @draw = ->
        for pt in @pts
          pt.handle.update(this)
          pt.handle.show(this)
          pt.pos[0] = pt.handle.x
          pt.pos[1] = pt.handle.y

        pts = (pt.pos for pt in @pts).flat()

        @push()
        @stroke strokeColor
        @noFill()
        @strokeWeight strokeWeight
        @bezier(pts...)
        @pop()

        msg = "Bezier Points: " + @pts.map (pt) ->
          pt.pos.join(",")
        .join("   ")
        Utils.showMsg(msg)
 
      @mousePressed = () ->
        for pt in @pts
          pt.handle.pressed(this)

      @mouseReleased = () ->
        for pt in @pts
          pt.handle.released(this)

      this
    .apply {}