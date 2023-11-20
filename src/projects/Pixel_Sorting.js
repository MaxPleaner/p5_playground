module.exports = (function() {
  var Project;
  Project = this;
  this.BACKGROUND_COLOR = [255, 0, 0];
  this.DESCRIPTION = "Using a bezier as boundaries for a pixel sorting function. See https://happycoding.io/tutorials/p5js/images/pixel-sorter";
  this.NO_LOOP = true;
  this.NO_SMOOTH = true;
  this.preload = function() {
    return Project.img = this.loadImage("public/cat.jpeg");
  };
  this.onSetup = function() {
    return Project.img.resize(200, 200);
  };
  this.draw = function() {
    var bezier_pts, x_range;
    Utils.showFps.call(this);
    bezier_pts = [[255, 211], [260, 135], [335, 155], [322, 212]].map((pt) => {
      return [Utils.remap(pt[0], 0, this.width, 0, Project.img.width), Utils.remap(pt[1], 0, this.height, 0, Project.img.height)];
    });
    x_range = [
      _.min(bezier_pts.map(function(pt) {
        return pt[0];
      })),
      _.max(bezier_pts.map(function(pt) {
        return pt[0];
      }))
    ];
    Utils.update_image_pixels.call(this, Project.img, function(img) {
      var bezier_val, i, new_val, pixels, ref, results, sorted, valid_x, valid_y, x, y, y_val;
      valid_x = function(x) {
        return x > x_range[0] && x < x_range[1];
      };
      bezier_val = function(x) {
        var x_01;
        x_01 = Utils.remap(x, x_range[0], x_range[1], 0, 1);
        return Utils.cubicBezier(x_01, ...bezier_pts)[1];
      };
      valid_y = function(x, y) {
        return y > bezier_val(x);
      };
      results = [];
      for (x = i = 0, ref = img.width - 1; (0 <= ref ? i <= ref : i >= ref); x = 0 <= ref ? ++i : --i) {
        if (!(valid_x(x))) {
          continue;
        }
        pixels = (function() {
          var j, ref1, results1;
          results1 = [];
          for (y = j = 0, ref1 = img.height - 1; (0 <= ref1 ? j <= ref1 : j >= ref1); y = 0 <= ref1 ? ++j : --j) {
            if (valid_y(x, y)) {
              results1.push(img.get(x, y));
            }
          }
          return results1;
        })();
        sorted = pixels.sort(function(a, b) {
          return Utils.luminance(b) - Utils.luminance(a);
        });
        results.push((function() {
          var j, ref1, results1;
          results1 = [];
          for (y = j = 0, ref1 = img.height - 1; (0 <= ref1 ? j <= ref1 : j >= ref1); y = 0 <= ref1 ? ++j : --j) {
            if (!(valid_y(x, y))) {
              continue;
            }
            y_val = bezier_val(x);
            new_val = sorted[Math.round(y - y_val)];
            if (new_val) {
              results1.push(img.set(x, y, new_val));
            } else {
              results1.push(void 0);
            }
          }
          return results1;
        })());
      }
      return results;
    });
    return this.image(Project.img, 0, 0, this.width, this.height);
  };
  return Project;
}).apply({});
