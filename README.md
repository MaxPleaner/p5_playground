# Summary

This is a coffeescript based framework for building sketches with P5.js. It uses Webpack as a build system.

# Coffeescript in 2023?!

It's a fantastic language. 

# Installation

```
# install deps
$ yarn

# start dev server (live reload)
$ yarn start

# build static version
$ yarn build
```

# Code Dive

Find the wrapper html in `dist/index.html`.

The entry point to the script is `src/index.coffee`.

To add a project, create a new file in `src/projects/` and load it from `src/projects.coffee`.
It will then be automatically selectable on the UI.

Check an existing project for reference. All projects are run through `src/utils/p5_wrapper.coffee`;
Add more functionality here as needed.

It's important to mention that your project's functions will be called using the p5 instance as `this`. So, if you want to
access properties / methods on your own project, you'll want to use a static reference. For example:

```
module.exports = ->
  Project = this

  @preload = ->
    # @loadImage is the p5 method.
    # Project.img is changing a property on the project.
    Project.img = @loadImage("public/cat.jpeg")
  
  @setup = ->
    @image(Project.img, 0, 0, @width, @height)

  this
.apply {}
```

Access utility methods through the globally available `Utils` helper.
See `src/utils.coffee` for available helpers or to extend the functionality.

Shaders: See [docs/shaders.md]

# TODOS

- Refactor shader system to Mixin style and make it work with different contexts.
- Add mixins more generally
- Add parameter editor UI
- Add some better CSS