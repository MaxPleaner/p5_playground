window.p5 = require 'p5'
window.P5Wrapper = require './util/p5_wrapper'
window.$ = require('jquery')

projects = require './projects'
active_project = null
buttons = {}

$ ->
  $projects = $ "#projects"
  Object.entries(projects).forEach ([name, project]) ->
    $button = $ "<button>#{name}</button>"
    $projects.append $button
    $button.click (e) ->
      active_project?.stop()
      active_project = new project()
      active_project.start()
    buttons[name] = $button

  buttons['First'].click()