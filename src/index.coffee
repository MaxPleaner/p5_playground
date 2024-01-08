# Yarn deps
window.p5 = require 'p5'
window.$ = require('jquery')
window._ = require('lodash')
require './vendor/p5.gui/p5.gui.js'
window.QuickSettings = require './vendor/p5.gui/quicksettings.js'
window.chromotome = require 'chromotome'
window.chroma = require 'chroma-js'

window.P5Capture = require 'p5.capture'

# Custom deps
window.Utils = require './utils.coffee'
window.Projects = require './projects'

# Project selector UI
UI_Manager = ->
  window.active_project = null
  active_button = null
  buttons = {}
  $ ->
    $projects = $ "#projects"
    Object.entries(Projects).forEach ([category, projects]) ->
      return if category == "DEFAULT_PROJECT_NAME"
      $categorySelector = $("<button class='category-selector'>#{category}</button>").data("name", category)
      $categoryWrapper = $ "<div class='category-wrapper'></div>"
      $categoryWrapper.append $categorySelector
      $category = $("<ul class='category'></ul>")
      $category.hide()
      $categorySelector.on "click", (e) ->
        $(".category").hide()
        $category.show()
      $projects.append $categoryWrapper
      $categoryWrapper.append("<br />")
      $categoryWrapper.append $category
      Object.entries(projects).forEach ([name, project]) ->
        $project = $ "<li class='project'></li>"
        $category.append $project
        $button = $ "<button>#{name}</button>"
        $project.append $button
        $button.click (e) ->
          $("#custom_msg").text("")
          $("#description").text(project.DESCRIPTION)
          $("#metadata").text("Metadata: webgl=#{!!project.WEBGL}, loop=#{!project.NO_LOOP}, smooth=#{!project.NO_SMOOTH}")
          active_button?.removeClass "active"
          active_button = $button
          active_button.addClass "active"
          active_project?.remove()

          if project.STANDALONE
            window.active_project = project.start()
          else
            window.active_project = new Utils.P5Wrapper(project)
            active_project.start()

          $(".p5c-container").hide()

          if active_project.processor?.HAS_GUI || active_project.HAS_GUI
            $("#toggle-gui").show()
            $toggle_gui.text("Hide GUI")
          else
            $("#toggle-gui").hide()
        buttons[name] = $button
    
    $("#pause").click (e) ->
      active_project?.pause()

    $("#recorder").click (e) ->
      $container = $(".p5c-container")
      if ($container.is(":visible"))
        $container.hide()
      else
        $container.show()

    $("#resume").click (e) ->
      active_project?.resume()

    $("#redraw").click (e) ->
      active_project?.redraw()

    $("#save-image").click (e) ->
      active_project.p5.saveCanvas("sketch", "png")

    $toggle_gui = $("#toggle-gui")
    $toggle_gui.click (e) ->
      gui = active_project.gui || active_project.processor.gui
      gui?.toggleVisibility()
      if $toggle_gui.text() == "Show GUI"
        $toggle_gui.text("Hide GUI")
      else
        $toggle_gui.text("Show GUI")


      # active_p  roject.gui?.

    category = Object.keys(Projects).find (category) ->
      Object.keys(Projects[category]).includes(Projects.DEFAULT_PROJECT_NAME)
    $categorySelector = $(".category-selector").filter (idx, el) ->
      $(el).data("name") == category
    $categorySelector.click()
    
    buttons[Projects.DEFAULT_PROJECT_NAME].click()

UI_Manager()