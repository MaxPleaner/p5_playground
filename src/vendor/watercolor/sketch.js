module.exports = function(params, { userSetup } = {}) {
  let sketch = function(p) {
    let points;

    let use_custom_color_seed = false;
    let custom_color_seed = 94938984;

    let use_custom_shape_seed = false;
    let custom_shape_seed = 94938984;

    let use_saved_palette = false;
    let current_palette = [];
    let random_palette = [];

    let COLOR_SEED;
    let SHAPE_SEED;

    p.setup = function() {
      var canvas = p.createCanvas(params.sizex, params.sizey);
      p.colorMode(p.HSB);
      p.blendMode(p.MULTIPLY);
      p.noStroke();
      p.noLoop();

      userSetup?.call(p)
    };

    p.draw = function() {
      // set_parameters();
      set_seeds();
      p.randomSeed(COLOR_SEED);
      set_colors();
      p.randomSeed(SHAPE_SEED);
      display();
    };

    function set_seeds() {
      // Using Math.random over P5.random to avoid the P5 seed.
      COLOR_SEED = use_custom_color_seed ? custom_color_seed : p.floor(Math.random() * 100000000);
      SHAPE_SEED = use_custom_shape_seed ? custom_shape_seed : p.floor(Math.random() * 100000000);
    }

    function set_colors() {
      random_palette = [];
      for (var i = 0; i < params.number_of_layers; i++) {
        random_palette.push(p.random(360));
      }
    }

    function display() {
      p.clear();
      p.background('#fff');
      for (var h = 0; h < params.number_of_layers; h++) {
        init(h * 250 - 100);
        let hue = use_saved_palette ? current_palette[h] : random_palette[h];
        current_palette[h] = hue;
        p.fill(hue, 100, 95, 0.012);
        for (var i = 0; i < params.shapes_per_layer; i++) {
          let shape = get_variant();
          display_shape(shape);
        }
      }
    }

    function init(ypos) {
      points = [];
      for (var i = 0; i < params.initial_size; i++) {
        let vec = p.createVector(i / (params.initial_size - 1) * p.width, ypos, p.random(-1, 1));
        move_nearby(vec, params.initial_deviation);
        points.push(vec);
      }
      for (let b = 0; b < params.number_of_interpolations; b++) {
        interpolate(points, params.initial_deviation);
      }
    }

    function get_variant() {
      let c = deep_copy(points);
      for (let b = 0; b < 8; b++) {
        c.forEach(function(pnt) {
          move_nearby(pnt, params.deviation);
        }, this);
      }
      return c;
    }

    function display_shape(shape) {
      p.beginShape();
      p.vertex(0, shape[0].y);

      shape.forEach(function(pnt) {
        p.vertex(pnt.x, pnt.y);
      });

      p.vertex(p.width, shape[shape.length - 1].y);
      p.vertex(p.width, p.height);
      p.vertex(0, p.height);
      p.endShape(p.CLOSE);
    }

    function interpolate(points, sd) {
      for (var i = points.length - 1; i > 0; i--) {
        points.splice(i, 0, generate_midpoint(points[i - 1], points[i], sd));
      }
    }

    function generate_midpoint(p1, p2, sd) {
      let p3 = p.createVector((p1.x + p2.x) / 2, (p1.y + p2.y) / 2, (p1.z + p2.z) / 2 * 0.45 * p.random(0.1, 3));
      move_nearby(p3, sd);
      return p3;
    }

    let move_nearby = function(pnt, sd) {
      pnt.x = p.randomGaussian(pnt.x, pnt.z * sd);
      pnt.y = p.randomGaussian(pnt.y, pnt.z * sd);
    };

    let deep_copy = function(arr) {
      let narr = [];
      for (var i = 0; i < arr.length; i++) {
        narr.push(arr[i].copy());
      }
      return narr;
    };


  };
  return new p5(sketch);
}