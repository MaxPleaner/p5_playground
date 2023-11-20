module.exports = (function() {
  var Project;
  Project = this;
  this.WEBGL = true;
  this.DESCRIPTION = "Using Image filters on things besides images. See https://p5js.org/reference/#/p5/filter";
  this.Shader = Utils.Shaders.PostProcessSinWave;
  this.onSetup = function() {
    // We create a 2d canvas that the line drawing is produced on
    this.g = this.createGraphics(this.width, this.height);
    this.g.stroke(255, 0, 130);
    this.g.strokeWeight(1);
    this.g.noFill();
    this.g.translate(this.width / 2, this.height / 2);
    return Project.Shader.setup.call(this, [this.g]);
  };
  this.draw = function() {
    Utils.showFps.call(this);
    this.g.background(0, 30);
    this.g.push();
    this.g.rotate(this.millis() / 1000);
    this.g.rect(-100, -100, 200, 200);
    this.g.pop();
    Project.Shader.draw.call(this, [this.g]);
    return this.rect(-this.width / 2, -this.height / 2, this.width, this.height);
  };
  return Project;
}).apply({});
