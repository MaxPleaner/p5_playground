(function() {
  // Yarn deps
  var SIZE, UI_Manager;

  window.p5 = require('p5');

  window.$ = require('jquery');

  window._ = require('lodash');

  // Custom deps
  window.Utils = require('./utils.coffee');

  window.Projects = require('./projects');

  // Global settings, these can be overridden
  // by setting a property on the individual project with the same name
  SIZE = [700, 700];

  // Project selector UI
  UI_Manager = function() {
    var active_button, buttons;
    window.active_project = null;
    active_button = null;
    buttons = {};
    return $(function() {
      var $projects;
      $projects = $("#projects");
      Object.entries(Projects).forEach(function([name, project]) {
        var $button;
        if (name === "DEFAULT_PROJECT_NAME") {
          return;
        }
        $button = $(`<button>${name}</button>`);
        $projects.append($button);
        $button.click(function(e) {
          $("#custom_msg").text("");
          $("#description").text(project.DESCRIPTION);
          if (active_button != null) {
            active_button.removeClass("active");
          }
          active_button = $button;
          active_button.addClass("active");
          if (typeof active_project !== "undefined" && active_project !== null) {
            active_project.remove();
          }
          window.active_project = new Utils.P5Wrapper(project);
          return active_project.start({
            size: project.SIZE || SIZE,
            background_color: project.BACKGROUND_COLOR
          });
        });
        return buttons[name] = $button;
      });
      $("#pause").click(function(e) {
        return typeof active_project !== "undefined" && active_project !== null ? active_project.pause() : void 0;
      });
      $("#resume").click(function(e) {
        return typeof active_project !== "undefined" && active_project !== null ? active_project.resume() : void 0;
      });
      $("#redraw").click(function(e) {
        return typeof active_project !== "undefined" && active_project !== null ? active_project.redraw() : void 0;
      });
      return buttons[Projects.DEFAULT_PROJECT_NAME].click();
    });
  };

  UI_Manager();

}).call(this);
