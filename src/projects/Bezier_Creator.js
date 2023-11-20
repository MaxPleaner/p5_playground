module.exports = (function() {
  var Project;
  Project = this;
  this.BACKGROUND_COLOR = [255, 0, 0];
  this.DESCRIPTION = "An interactive tool to create bezier formulas. Drag the points around to see updated point values. NOTE: if using these values for image manipulation, you'll have to remap them from canvas space to image space.";
  this.NO_SMOOTH = true;
  this.p1 = {
    pos: [255, 211],
    handle: null
  };
  this.p2 = {
    pos: [260, 135],
    handle: null
  };
  this.p3 = {
    pos: [335, 155],
    handle: null
  };
  this.p4 = {
    pos: [322, 212],
    handle: null
  };
  this.pts = [this.p1, this.p2, this.p3, this.p4];
  this.preload = function() {
    return Project.img = this.loadImage("public/cat.jpeg");
  };
  this.onSetup = function() {
    var i, len, pt, ref, results;
    Project.img.resize(200, 200);
    ref = Project.pts;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      pt = ref[i];
      results.push(pt.handle = new Utils.Draggable(pt.pos[0], pt.pos[1], 10, 10));
    }
    return results;
  };
  this.draw = function() {
    var i, len, msg, pt, pts, ref;
    Utils.showFps.call(this);
    this.image(Project.img, 0, 0, this.width, this.height);
    ref = Project.pts;
    for (i = 0, len = ref.length; i < len; i++) {
      pt = ref[i];
      pt.handle.update(this);
      pt.handle.show(this);
      pt.pos[0] = pt.handle.x;
      pt.pos[1] = pt.handle.y;
    }
    this.stroke(255, 0, 0);
    pts = ((function() {
      var j, len1, ref1, results;
      ref1 = Project.pts;
      results = [];
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        pt = ref1[j];
        results.push(pt.pos);
      }
      return results;
    })()).flat();
    this.bezier(...pts);
    msg = "Bezier Points: " + Project.pts.map(function(pt) {
      return pt.pos.join(",");
    }).join("   ");
    return Utils.showMsg(msg);
  };
  this.mousePressed = function() {
    var i, len, pt, ref, results;
    ref = Project.pts;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      pt = ref[i];
      results.push(pt.handle.pressed(this));
    }
    return results;
  };
  this.mouseReleased = function() {
    var i, len, pt, ref, results;
    ref = Project.pts;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      pt = ref[i];
      results.push(pt.handle.released(this));
    }
    return results;
  };
  return Project;
}).apply({});
