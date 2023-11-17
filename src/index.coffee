# Yarn deps
window.p5 = require 'p5'
window.$ = require('jquery')
window._ = require('lodash')

# Custom deps
window.Projects = require './projects'
window.Utils = require './utils.coffee'

# Project selector UI
active_project = null
buttons = {}
$ ->
  $projects = $ "#projects"
  Object.entries(Projects).forEach ([name, project]) ->
    $button = $ "<button>#{name}</button>"
    $projects.append $button
    $button.click (e) ->
      active_project?.stop()
      active_project = new Utils.P5Wrapper(project)
      active_project.start()
    buttons[name] = $button

  buttons.First.click()