(function() {
  // The following methods will be invoked in the p5 lifecycle,
  // if they're defined on a particular project:

  //   - setup({size, background_color, extra_args})
  //   - onSetup()
  //      this is called inside setup() but after the default functionality happens
  //   - draw()
  //   - preload()
  //   - mousePressed()
  //   - mouseReleased()

  // As well as the following attributes:

  //   - WEBGL (boolean, optional)
  //   - DESCRIPTION (string, required)
  //   - NO_LOOP (boolean, optional)
  //       if true, draw will only happen manually
  //   - NO_SMOOTH (boolean, optional)
  //       if true, won't apply anti aliasing
  var P5Wrapper;

  module.exports = P5Wrapper = class P5Wrapper {
    constructor(processor) {
      this.start = this.start.bind(this);
      this.processor = processor;
      this.paused = false;
      this.redrawing = false;
    }

    // bound to @p5 instance
    default_setup({size, background_color, webgl} = {}) {
      this.createCanvas(size[0], size[1], webgl ? this.WEBGL : this.P2D);
      if (background_color) {
        return this.background(...background_color);
      }
    }

    start({size, background_color, extra_args = {}} = {}) {
      this.p5 = new p5((p) => {
        var ref, ref1, ref2;
        p.mousePressed = (ref = this.processor.mousePressed) != null ? ref.bind(p) : void 0;
        p.mouseReleased = (ref1 = this.processor.mouseReleased) != null ? ref1.bind(p) : void 0;
        p.preload = (ref2 = this.processor.preload) != null ? ref2.bind(p) : void 0;
        p.setup = () => {
          (this.processor.setup || this.default_setup).call(p, {
            size,
            background_color,
            webgl: this.processor.WEBGL,
            ...extra_args
          });
          if (this.processor.onSetup) {
            this.processor.onSetup.call(p);
          }
          if (this.processor.NO_LOOP) {
            p.noLoop();
          }
          if (this.processor.NO_SMOOTH) {
            return p.noSmooth();
          }
        };
        return p.draw = () => {
          var ref3;
          if (this.paused && !this.redrawing) {
            return;
          }
          if ((ref3 = this.processor.draw) != null) {
            ref3.call(p);
          }
          return this.redrawing = false;
        };
      });
      return this;
    }

    redraw() {
      this.redrawing = true;
      return this.p5.redraw();
    }

    remove() {
      return this.p5.remove();
    }

    pause() {
      return this.paused = true;
    }

    resume() {
      return this.paused = false;
    }

    halt() {
      return this.p5.noLoop(true);
    }

  };

}).call(this);
