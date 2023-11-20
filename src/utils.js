module.exports = (function() {
  var Utils;
  Utils = this;
  
  //#######################################
  // Dont mess with the ordering here.
  // Some files depend on others being loaded beforehand.
  //#######################################

  // TODO: Make loading dependencies more explicit
  this.P5Wrapper = require('./utils/p5_wrapper');
  this.Draggable = require("./utils/draggable");
  Object.assign(this, require('./utils/cpu_pixel_utils')(this));
  Object.assign(this, require('./utils/cpu_pixel_operators')(this));
  this.ShaderBuilder = require('./utils/shader_builder');
  this.Shaders = require('./utils/shaders')(this);
  // Mixing are designed as feature sets which can be easily added to a project.
  this.Mixins = {
    BezierCreator: require('./utils/mixins/bezier_creator')(this)
  };
  // ===============
  // Pixel Utils
  // ===============
  this.luminance = function(pixel) {
    return 0.299 * pixel[0] + 0.587 * pixel[1] + 0.114 * pixel[2];
  };
  // ===============
  // Shaping Functions
  // ===============
  this.cubicBezier = function(t, P0, P1, P2, P3) {
    var x, y;
    x = (1 - t) ** 3 * P0[0] + 3 * (1 - t) ** 2 * t * P1[0] + 3 * (1 - t) * t ** 2 * P2[0] + t ** 3 * P3[0];
    y = (1 - t) ** 3 * P0[1] + 3 * (1 - t) ** 2 * t * P1[1] + 3 * (1 - t) * t ** 2 * P2[1] + t ** 3 * P3[1];
    return [x, y];
  };
  this.remap = function(value, oldMin, oldMax, newMin, newMax) {
    return (value - oldMin) * (newMax - newMin) / (oldMax - oldMin) + newMin;
  };
  // ===============
  // UI Helpers
  // ===============
  this.showFps = function() {
    Utils.fps || (Utils.fps = $("#fps"));
    return Utils.fps.text(`FPS: ${this.frameRate().toFixed()}`);
  };
  this.showMsg = function(msg) {
    Utils.custom_msg || (Utils.custom_msg = $("#custom_msg"));
    return Utils.custom_msg.text(msg);
  };
  return Utils;
}).apply({});
