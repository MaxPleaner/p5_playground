# Yarn deps
window.p5 = require 'p5'
window.$ = require('jquery')
window._ = require('lodash')

# Custom deps
window.Utils = require './utils.coffee'
window.Projects = require './projects'

# Global settings, these can be overridden
# by setting a property on the individual project with the same name
SIZE = [700, 700]

# Project selector UI
UI_Manager = ->
  active_project = null
  active_button = null
  buttons = {}
  $ ->
    $projects = $ "#projects"
    Object.entries(Projects).forEach ([name, project]) ->
      return if name == "DEFAULT_PROJECT_NAME"
      $button = $ "<button>#{name}</button>"
      $projects.append $button
      $button.click (e) ->
        $("#description").text(project.DESCRIPTION)
        active_button?.removeClass "active"
        active_button = $button
        active_button.addClass "active"
        active_project?.stop()
        active_project = new Utils.P5Wrapper(project)
        active_project.start({
          size: project.SIZE || SIZE,
          background_color: project.BACKGROUND_COLOR
        })
      buttons[name] = $button

    buttons[Projects.DEFAULT_PROJECT_NAME].click()
UI_Manager()