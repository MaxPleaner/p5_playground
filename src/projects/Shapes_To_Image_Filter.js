module.exports = (function() {
  var Project;
  Project = this;
  this.DESCRIPTION = "Using Image filters on things besides images. In this case, some procedural RGB noise. Essentially we just draw our shapes into a `createGraphics()` and then call `image()` with that. See https://p5js.org/reference/#/p5/filter";
  this.NO_LOOP = true;
  this.onSetup = function() {
    var col, freq, j, k, ref, ref1, x, y;
    // We create a 2d canvas that the line drawing is produced on
    this.g = this.createGraphics(this.width, this.height);
    freq = 0.01;
    this.g.noStroke();
    for (x = j = 0, ref = this.width; j <= ref; x = j += 4) {
      for (y = k = 0, ref1 = this.height; k <= ref1; y = k += 4) {
        col = [0, 1, 2].map((i) => {
          return this.noise(freq * x + (i * 1000), freq * y + (i * 1000)) * 255;
        });
        this.g.fill(col);
        this.g.rect(x, y, 4, 4);
      }
    }
    this.image(this.g, 0, 0, this.width, this.height);
    return this.filter(this.POSTERIZE, 9);
  };
  // @draw = ->
  //   Utils.showFps.call(this)
  return Project;
}).apply({});
